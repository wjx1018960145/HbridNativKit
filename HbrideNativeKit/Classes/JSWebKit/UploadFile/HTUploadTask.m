//
//  HTUploadTask.m
//  HybridForiOS
//
//  Created by wjx on 2020/3/19.
//  Copyright © 2020 WJX. All rights reserved.
//

#import "HTUploadTask.h"
#import "HTFileUploadManager.h"
#import "HTFileStreamSeparation.h"
#import "HTFileManager.h"
#import "HTUploadTask+CheckInfo.h"


//分隔符
#define Boundary @"1a2b3c"
//一般换行
#define Wrap1 @"\r\n"
//key-value换行
#define Wrap2 @"\r\n\r\n"
//开始分割
#define StartBoundary [NSString stringWithFormat:@"--%@%@",Boundary,Wrap1]
//文件分割完成
#define EndBody [NSString stringWithFormat:@"--%@--",Boundary]
//一个片段上传失败默认重试3次
#define REPEAT_MAX 3

#define plistPath [[HTFileManager cachesDir] stringByAppendingPathComponent:uploadPlist]

NSString *const HTUploadTaskExeing = @"TaskExeing";
NSString *const HTUploadTaskExeError = @"TaskExeError";
NSString *const HTUploadTaskExeEnd = @"TaskExeEnd";
NSString *const HTUploadTaskExeSuspend = @"TaskExeSuspend";

@interface HTUploadTask()

@property (nonatomic,strong)NSURLSessionUploadTask *uploadTask;

@property (nonatomic,strong)NSMutableURLRequest *request;

@property (nonatomic,readwrite)NSURL * url;

@property (nonatomic,readwrite)NSString *ID;

@property (nonatomic,readwrite)NSMutableDictionary *param;//上传时参数

@property (nonatomic,readwrite)NSURLSessionTaskState taskState;

@property (nonatomic,readwrite)HTFileStreamSeparation *fileStream;

@property (nonatomic,copy)finishHandler finishBlock;//片段上传成功上传的回调block

@property (nonatomic,copy)success successBlock;//整体上传成功上传的回调block

@property (nonatomic,copy)NSString *chunkNumName;//片段编号这一参数的参数名

@property (nonatomic,copy)NSDictionary *lastParam;//片段完成上传后的参数

@property (nonatomic,assign)NSInteger chunkNo;//片段完成上传后的编号

@property (nonatomic,assign)NSInteger taskRepeatNum;//重试次数

@property (nonatomic,assign)BOOL isSuspendedState;//记录状态更改

@property (nonatomic,strong)HTFileUploadManager *uploadManager;

@end



@implementation HTUploadTask

-(HTFileUploadManager *)uploadManager
{
    if (!_uploadManager) {
        _uploadManager = [HTFileUploadManager shardUploadManager];
    }
    return _uploadManager;
}

- (void)setFileStream:(HTFileStreamSeparation *)fileStream
{
    _fileStream.fileStatus = HTUploadStatusWaiting;
    _taskRepeatNum = 0;
    _ID = fileStream.md5String;
    for (NSInteger idx=0; idx<fileStream.streamFragments.count; idx++) {
        HTStreamFragment *fragment = fileStream.streamFragments[idx];
        if (!fragment.fragmentStatus) {
            _chunkNo = idx;
        }
    }
    _fileStream = fileStream;
}


+ (NSMutableDictionary<NSString*,HTUploadTask*> *)uploadTasksWithDict:(NSDictionary<NSString*,HTFileStreamSeparation*> *)dict{
    NSMutableDictionary *taskDict = [NSMutableDictionary dictionary];
    for (NSString *key in dict.allKeys) {
        HTFileStreamSeparation *fs = [dict objectForKey:key];
        HTUploadTask *task = [HTUploadTask initWithStreamModel:fs];
        [taskDict setValue:task forKey:key];
    }
    return taskDict;
}

+ (instancetype)initWithStreamModel:(HTFileStreamSeparation *)fileStream
{
    HTUploadTask *task = [HTUploadTask new];
    task.fileStream = fileStream;
    task.isSuspendedState = NO;
    task.url = [HTFileUploadManager shardUploadManager].url;
    return task;
}

- (void)listenTaskExeCallback:(finishHandler _Nonnull)block success:(success)successBlock
{
    self.finishBlock = block;
    self.successBlock = successBlock;
    if (_finishBlock) _finishBlock(_fileStream,nil);
}


- (instancetype _Nonnull)initWithStreamModel:(HTFileStreamSeparation *)fileStream finish:(finishHandler _Nonnull)block success:(success)successBlock

{
    if (self = [super init]) {
        self.fileStream = fileStream;
        _finishBlock = block;
        _successBlock = successBlock;
    }
    return self;
}

-(NSMutableURLRequest*)uploadRequest
{
    if ([HTFileUploadManager shardUploadManager].request) {
        _request = [HTFileUploadManager shardUploadManager].request;
    }else{
        NSLog(@"请配置上传任务的request");
    }
    return _request;
    
}

-(NSData*)taskRequestBodyWithParam:(NSDictionary *)param uploadData:(NSData *)data
{
    NSMutableData* totlData=[NSMutableData new];

    NSArray* allKeys=[param allKeys];
    for (int i=0; i<allKeys.count; i++)
    {
        
        NSString *disposition = [NSString stringWithFormat:@"%@Content-Disposition: form-data; name=\"%@\"%@",StartBoundary,allKeys[i],Wrap2];
        NSString* object=[param objectForKey:allKeys[i]];
        disposition =[disposition stringByAppendingString:[NSString stringWithFormat:@"%@",object]];
        disposition =[disposition stringByAppendingString:Wrap1];
        [totlData appendData:[disposition dataUsingEncoding:NSUTF8StringEncoding]];
        
    }
    NSString *body=[NSString stringWithFormat:@"%@Content-Disposition: form-data; name=\"picture\"; filename=\"%@\";Content-Type:image/png%@",StartBoundary,@"file",Wrap2];
    [totlData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    [totlData appendData:data];
    [totlData appendData:[Wrap1 dataUsingEncoding:NSUTF8StringEncoding]];
    [totlData appendData:[EndBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    return totlData;
}

/**
 *  上传任务
 */
-(void)uploadTaskWithUrl:(NSURL *)url param:(NSDictionary *)param uploadData:(NSData *)data completionHandler:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler

{
    if (_isSuspendedState){
        [self taskCancel];
        return;
    }
    _param = [NSMutableDictionary dictionaryWithDictionary:param];;
    NSURLSession *session = [NSURLSession sharedSession];
    self.uploadTask = [session uploadTaskWithRequest:[self uploadRequest] fromData:[self taskRequestBodyWithParam:param uploadData:data] completionHandler:completionHandler];
    self.taskState = _uploadTask.state;
    [_uploadTask resume];
}

//上传文件相关信息，返回文件上传相关参数
- (void)postFileInfo
{
    __weak typeof(self) weekSelf = self;
    [self checkParamFromServer:_fileStream paramCallback:^(NSString * _Nonnull chunkNumName, NSDictionary * _Nullable param) {
        weekSelf.chunkNumName = chunkNumName;
        weekSelf.param = [NSMutableDictionary dictionaryWithDictionary:param];
        [weekSelf startExe];
    }];
}

//上传文件的核心方法
- (void)startExe{
    //判断无参数的情况下先将文件信息上传并获得参数
    if (!_param) [self postFileInfo];
    dispatch_group_t group = dispatch_group_create();
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_queue_t queue = dispatch_queue_create(NULL, DISPATCH_QUEUE_SERIAL);
    
    if (_fileStream.fileStatus == HTUploadStatusFinished && _successBlock) {
        _successBlock(_fileStream);
        [self sendNotionWithKey:HTUploadTaskExeEnd userInfo:@{@"fileStream":_fileStream}];
        return;
    };
    for (NSInteger i=0; i<_fileStream.streamFragments.count; i++) {
        HTStreamFragment *fragment = _fileStream.streamFragments[i];
        if (fragment.fragmentStatus) continue;
        dispatch_group_async(group, queue, ^{
            @autoreleasepool {
                NSData *data = [self->_fileStream readDateOfFragment:fragment];
                __weak typeof(self) weekSelf = self;
                [self->_param setObject:[NSString stringWithFormat:@"%zd",(i+1)] forKey:self->_chunkNumName];
                self.lastParam = self->_param;
//                NSLog(@"*******参数*******\n%@",_param);
                [self uploadTaskWithUrl:self->_url param:self->_param uploadData:data completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
                    if (!error && httpResponse.statusCode==200) {
                        weekSelf.taskRepeatNum = 0;
                        fragment.fragmentStatus = YES;
                        weekSelf.fileStream.fileStatus = HTUploadStatusUpdownloading;
                        [weekSelf archTaskFileStream];
                        weekSelf.chunkNo = i+1;
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            if (weekSelf.finishBlock) weekSelf.finishBlock(weekSelf.fileStream,nil);
                            [weekSelf sendNotionWithKey:HTUploadTaskExeing userInfo:@{@"fileStream":weekSelf.fileStream,@"lastParam":weekSelf.lastParam,@"indexNo":@(weekSelf.chunkNo)}];
                        });
                        dispatch_semaphore_signal(semaphore);
                    }else{
                        if (weekSelf.taskRepeatNum<REPEAT_MAX) {
                            weekSelf.taskRepeatNum++;
                            [weekSelf startExe];
                        }else{
                            weekSelf.fileStream.fileStatus = HTUploadStatusFailed;
                            dispatch_sync(dispatch_get_main_queue(), ^{
                                if (weekSelf.finishBlock) weekSelf.finishBlock(weekSelf.fileStream,error);
                                [weekSelf sendNotionWithKey:HTUploadTaskExeError userInfo:@{@"fileStream":weekSelf.fileStream,@"error":error?error:@""}];
                            });
                            [weekSelf deallocSession];
                            return;
                        }
                    }
                }];
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            }
        });
    }
    
    dispatch_group_notify(group, queue, ^{
        self->_fileStream.fileStatus = HTUploadStatusFinished;
        [self archTaskFileStream];
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (self->_finishBlock) self->_finishBlock(self->_fileStream,nil);
            [self sendNotionWithKey:HTUploadTaskExeEnd userInfo:@{@"fileStream":self->_fileStream}];
        });
        [self deallocSession];
    });
}

- (void)taskResume{
    _isSuspendedState = NO;
    if (!(self.uploadManager.uploadingTasks.count<self.uploadManager.uploadMaxNum)) {
        _fileStream.fileStatus = HTUploadStatusWaiting;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->_successBlock)  self->_successBlock(self->_fileStream);
            [self sendNotionWithKey:HTUploadTaskExeEnd userInfo:@{@"fileStream":self->_fileStream}];
        });
        return;
    }
    _uploadTask == nil?[self postFileInfo]:[self startExe];
}

- (void)taskCancel{
    _fileStream.fileStatus = HTUploadStatusPaused;
    [self archTaskFileStream];
    _isSuspendedState = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self->_finishBlock) self->_finishBlock(self->_fileStream,nil);
        [self sendNotionWithKey:HTUploadTaskExeSuspend userInfo:@{@"fileStream":self->_fileStream}];
    });
    if (!_uploadTask) return;
    [self.uploadTask suspend];
    [self.uploadTask cancel];
    self.uploadTask = nil;
}

- (void)deallocSession{
    _taskRepeatNum = 0;
    self.uploadTask = nil;
    [[NSURLSession sharedSession] finishTasksAndInvalidate];
}

#pragma mark -- tools

- (void)archTaskFileStream{
    NSMutableDictionary *fsDic = [HTUploadTask unArcherThePlist:plistPath];
    if (!fsDic) {
        fsDic = [NSMutableDictionary dictionary];
    }
    [fsDic setObject:_fileStream forKey:_fileStream.fileName];
    [HTUploadTask archerTheDictionary:fsDic file:plistPath];
}


//归档
+ (void)archerTheDictionary:(NSDictionary *)dict file:(NSString *)path{
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dict];
    BOOL finish = [data writeToFile:path atomically:YES];
    if (finish) {};
    
}

//解档
+ (NSMutableDictionary *)unArcherThePlist:(NSString *)path{
    NSMutableDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    return dic;
}

- (void)sendNotionWithKey:(NSString *)key userInfo:(NSDictionary *)dict{
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:key object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}

@end
