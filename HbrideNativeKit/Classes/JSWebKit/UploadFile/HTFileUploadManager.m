//
//  HTFileUploadManager.m
//  HybridForiOS
//
//  Created by wjx on 2020/3/19.
//  Copyright © 2020 WJX. All rights reserved.
//

#import "HTFileUploadManager.h"
#import "HTFileStreamSeparation.h"
#import "HTUploadTask.h"
#import "HTFileManager.h"

#define plistPath [[HTFileManager cachesDir] stringByAppendingPathComponent:uploadPlist]
#define default_max @"uploadMax"
@interface HTFileUploadManager()

@property (nonatomic,strong)NSMutableDictionary *fileStreamDict;

@property (nonatomic,strong)NSMutableDictionary *allTasks;

//正在上传中的任务
@property (nonatomic,strong)NSMutableDictionary *uploadingTasks;

//正在等待上传的任务
@property (nonatomic,strong)NSMutableDictionary *uploadWaitTasks;

//已经上传完的任务
@property (nonatomic,strong)NSMutableDictionary *uploadEndTasks;

@property (nonatomic,assign)NSInteger uploadMaxNum;

@property (nonatomic,strong)NSURL *url;
@property (nonatomic,strong)NSMutableURLRequest *request;

@end

@implementation HTFileUploadManager

static HTFileUploadManager * _instance;

-(NSMutableDictionary *)fileStreamDict{
    if (!_fileStreamDict) {
        _fileStreamDict = [NSMutableDictionary dictionary];
    }
    return _fileStreamDict;
}

- (NSMutableDictionary *)allTasks
{
    if (!_allTasks) {
        _allTasks = [_instance allUploadTasks];
    }
    return _allTasks;
}

- (NSMutableDictionary *)uploadingTasks
{
    return [self allUploadingTasks];
}

- (NSMutableDictionary *)uploadWaitTasks
{
    return [self allUploadWaitTasks];
}

- (NSMutableDictionary *)uploadEndTasks
{
    return [self allUploadEndTasks];
}

+ (instancetype)shardUploadManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        [_instance registeNotification];
        [_instance defaultsTask];
        
    });
    return _instance;
}

+ (HTUploadTask *)startUploadWithPath:(NSString *)path
{
    //是否是在册任务
    if (![HTFileUploadManager isUploadTask:path]) {
        [_instance taskRecord:path];
        
    }
    return [_instance continuePerformTaskWithFilePath:path];
}

- (HTUploadTask *_Nullable)createUploadTask:(NSString *_Nonnull)filePath
{
    //是否是在册任务
    if (![HTFileUploadManager isUploadTask:filePath]) {
        [_instance taskRecord:filePath];
        
    }
    return [self continuePerformTaskWithFilePath:filePath];
}

//配置全局默认的参数
- (void)config:(NSMutableURLRequest *)request maxTask:(NSInteger)num
{
    if (!request.URL) {
        NSLog(@"request缺少URL");
    }
    [[NSUserDefaults standardUserDefaults] setInteger:num forKey:default_max];
    self.uploadMaxNum = num;
    self.url = request.URL;
    self.request = request;
}

//设置最大任务数
- (void)setUploadMaxNum:(NSInteger)uploadMaxNum
{
    if (_uploadMaxNum<3) {
        _uploadMaxNum = uploadMaxNum;
    }else if (_uploadMaxNum<0){
        _uploadMaxNum = 3;
    }else if(_uploadMaxNum>=3){
        _uploadMaxNum = 3;
    }
}

- (void)defaultsTask{
    NSInteger tmpMax = [[NSUserDefaults standardUserDefaults] integerForKey:default_max];
    self.uploadMaxNum = tmpMax?tmpMax:3;
}

/**
 暂停一个上传任务
 */
- (void)pauseUploadTask:(HTFileStreamSeparation *_Nonnull)fileStream
{
    HTUploadTask *task = [self.allTasks objectForKey:fileStream.fileName];
    [task taskCancel];
}

/**
 继续开始一个上传任务
 */
- (void)resumeUploadTask:(HTFileStreamSeparation *_Nonnull)fileStream
{
    HTUploadTask *task = [self.allTasks objectForKey:fileStream.fileName];
    [task taskResume];
}

/**
 删除一个上传任务，同时会删除当前任务上传的缓存数据
 */
- (void)removeUploadTask:(HTFileStreamSeparation *_Nonnull)fileStream
{
    HTUploadTask *task = [self.allTasks objectForKey:fileStream.fileName];
    
    [task taskCancel];
    
    [_allTasks removeObjectForKey:fileStream.fileName];
    [_uploadingTasks removeObjectForKey:fileStream.fileName];
    if (_fileStreamDict[fileStream.fileName]) {
        _fileStreamDict = [self unArcherThePlist:plistPath];
    }
    [_fileStreamDict removeObjectForKey:fileStream.fileName];
    
    [self archerTheDictionary:_fileStreamDict file:plistPath];
    NSLog(@"删除任务");
}

/**
 暂停所有的上传任务
 */
- (void)pauseAllUploadTask
{
    for (HTUploadTask *task in [self.allTasks allValues]) {
        [task taskCancel];
    }
}

/**
删除所有的上传任务
 */
- (void)removeAllUploadTask
{
    for (HTUploadTask *task in [self.allTasks allValues]) {
        [self removeUploadTask:task.fileStream];
    }
}

/**
 获取所有文件分片模型的上传任务字典
 */
- (NSMutableDictionary<NSString*,HTUploadTask*>*_Nullable)allUploadTasks
{
    if (self.fileStreamDict.count == 0) {
        self.fileStreamDict = [self unArcherThePlist:plistPath];
    }
    NSDictionary *tmpDict = _allTasks?_allTasks:@{};
    NSMutableDictionary *fileWithTasks = [HTUploadTask uploadTasksWithDict:_instance.fileStreamDict];
    
    [fileWithTasks addEntriesFromDictionary:tmpDict];
    return fileWithTasks;
}

- (NSMutableDictionary<NSString*,HTUploadTask*>*_Nullable)allUploadWaitTasks
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [self.allTasks enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        HTUploadTask *task = obj;
        if (task.fileStream.fileStatus == HTUploadStatusWaiting &&
            task.fileStream.fileStatus != HTUploadStatusFailed) {
            [dic setObject:task forKey:key];
        }
    }];
    return dic;
}

- (NSMutableDictionary<NSString*,HTUploadTask*>*_Nullable)allUploadEndTasks
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [self.uploadingTasks enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        HTUploadTask *task = obj;
        if (task.fileStream.fileStatus == HTUploadStatusFinished) {
            [dic setObject:task forKey:key];
        }
    }];
    return dic;
}

- (NSMutableDictionary<NSString*,HTUploadTask*>*_Nullable)allUploadingTasks
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [self.allTasks enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        HTUploadTask *task = obj;
        if (task.fileStream.fileStatus == HTUploadStatusUpdownloading) {
            [dic setObject:task forKey:key];
        }
    }];

    return dic;
}

#pragma 工具方法
- (HTUploadTask *)continuePerformTaskWithFilePath:(NSString *)path{
    
    //获取任务数据字段
    HTFileStreamSeparation *fstream = [self.fileStreamDict objectForKey:path.lastPathComponent];
    HTUploadTask *uploadTask = self.allTasks[path.lastPathComponent];
    if (!uploadTask) {
        uploadTask = [HTUploadTask initWithStreamModel:fstream];
        [self.allTasks setObject:uploadTask forKey:path.lastPathComponent];
    }
    [uploadTask taskResume];
    return uploadTask;
}

+ (BOOL)isUploadTask:(NSString *)path{
    _instance = [HTFileUploadManager shardUploadManager];
    if (![HTFileManager isFileAtPath:plistPath]) {
        [HTFileManager createFileAtPath:plistPath overwrite:NO];
    }
    _instance.fileStreamDict = [_instance unArcherThePlist:plistPath];
    if (_instance.fileStreamDict[path.lastPathComponent] == nil) {
        return NO;
    }else{
        return YES;
    }
}

//新建任务分片模型并存入plist文件
- (HTFileStreamSeparation * _Nullable)taskRecord:(NSString *)path{
    
    HTFileStreamSeparation *file = [[HTFileStreamSeparation alloc]initFileOperationAtPath:path forReadOperation:YES];
    [self.fileStreamDict setObject:file forKey:path.lastPathComponent];
    
    [self archerTheDictionary:_fileStreamDict file:plistPath];
    
    return file;
}

#pragma mark - notification

- (void)registeNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(taskExeEnd:) name:HTUploadTaskExeEnd object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(taskExeError:) name:HTUploadTaskExeError object:nil];
}

//app启动或者app从后台进入前台都会调用这个方法
- (void)applicationBecomeActive{
    [self uploadingTasksItemExe];
}

- (void)taskExeEnd:(NSNotification *)notification
{
    HTFileStreamSeparation *fs = notification.userInfo.allValues.firstObject;
    [_uploadingTasks removeObjectForKey:fs.fileName];
    [self.uploadWaitTasks enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        HTUploadTask *task = obj;
        if (_uploadWaitTasks.count<self.uploadMaxNum) {
            [task taskResume];
        }else{
            *stop = YES;
        }
    }];
    [self allUploadingTasks];
}

- (void)taskExeError:(NSNotification *)notification
{
    HTFileStreamSeparation *fs = notification.userInfo[@"fileStream"];
    NSError *error = (NSError *)notification.userInfo[@"error"];
    [_uploadingTasks removeObjectForKey:fs.fileName];
    NSLog(@"taskError:%@",error);
}

- (void)uploadingTasksItemExe{
    NSDictionary *dict = [NSDictionary dictionaryWithDictionary:self.uploadingTasks];
    [_uploadingTasks removeAllObjects];
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        HTUploadTask *task = obj;
        [task taskResume];
    }];
    [self.uploadWaitTasks enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        HTUploadTask *task = obj;
        if (_uploadingTasks.count<self.uploadMaxNum) {
            [task taskResume];
        }else{
            *stop = YES;
        }
    }];
    [self allUploadingTasks];
}

#pragma mark - tools
//归档
- (void)archerTheDictionary:(NSDictionary *)dict file:(NSString *)path{
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dict];
    BOOL finish = [data writeToFile:path atomically:YES];
    if (finish) {};
    
}

//解档
- (NSMutableDictionary *)unArcherThePlist:(NSString *)path{
    NSMutableDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    return dic;
}


@end
