//
//  HTFileUploadManager.h
//  HybridForiOS
//
//  Created by wjx on 2020/3/19.
//  Copyright © 2020 WJX. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class HTUploadTask;
@class HTFileStreamSeparation;
@interface HTFileUploadManager : NSObject
//总的文件分片模型数
@property (nonatomic,readonly)NSMutableDictionary *fileStreamDict;

//总任务数
@property (nonatomic,readonly)NSMutableDictionary *allTasks;

//正在上传中的任务
@property (nonatomic,readonly)NSMutableDictionary *uploadingTasks;

//正在等待上传的任务
@property (nonatomic,readonly)NSMutableDictionary *uploadWaitTasks;

//已经上传完的任务
@property (nonatomic,readonly)NSMutableDictionary *uploadEndTasks;

//同时上传的任务数
@property (nonatomic,readonly)NSInteger uploadMaxNum;

//配置的上传路径
@property (nonatomic,readonly)NSURL *url;

//配置的请求体
@property (nonatomic,readonly)NSMutableURLRequest *request;

//获得管理类单例对象
+ (instancetype)shardUploadManager;

//配置全局默认参数
/**
 @param request 默认请求头
 @param num 最大任务数
 */
- (void)config:(NSMutableURLRequest * _Nonnull)request maxTask:(NSInteger)num;

//根据文件路径创建上传任务
- (HTUploadTask *_Nullable)createUploadTask:(NSString *_Nonnull)filePath;


/**
 暂停一个上传任务
 
 @param fileStream 上传文件的路径
 */
- (void)pauseUploadTask:(HTFileStreamSeparation *_Nonnull)fileStream;

/**
 继续开始一个上传任务
 
 @param fileStream 上传文件的路径
 */
- (void)resumeUploadTask:(HTFileStreamSeparation *_Nonnull)fileStream;

/**
 删除一个上传任务，同时会删除当前任务上传的缓存数据
 
 @param fileStream 上传文件的路径
 */
- (void)removeUploadTask:(HTFileStreamSeparation *_Nonnull)fileStream;

/**
 暂停所有上传任务
 */
- (void)pauseAllUploadTask;

/**
 删除所有上传任务
 */
- (void)removeAllUploadTask;


@end

NS_ASSUME_NONNULL_END
