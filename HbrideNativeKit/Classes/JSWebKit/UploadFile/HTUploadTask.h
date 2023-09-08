//
//  HTUploadTask.h
//  HybridForiOS
//
//  Created by wjx on 2020/3/19.
//  Copyright © 2020 WJX. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class HTFileStreamSeparation;

#ifdef __cplusplus
#define TASK_EXTERN        extern "C" __attribute__((visibility ("default")))
#else
#define TASK_EXTERN            extern __attribute__((visibility ("default")))
#endif

/**
 通知监听上传状态的key
 */
TASK_EXTERN NSString * _Nonnull const HTUploadTaskExeing;//上传中
TASK_EXTERN NSString * _Nonnull const HTUploadTaskExeError;//上传失败
TASK_EXTERN NSString * _Nonnull const HTUploadTaskExeEnd;//上传完成
TASK_EXTERN NSString * _Nonnull const HTUploadTaskExeSuspend;//上传暂停/取消

typedef void(^finishHandler)(HTFileStreamSeparation * _Nullable fileStream, NSError * _Nullable error);

typedef void(^success)(HTFileStreamSeparation * _Nullable fileStream);

@interface HTUploadTask : NSObject

@property (nonatomic,readonly,strong)HTFileStreamSeparation *_Nullable fileStream;
//当前上传任务的URL
@property (nonatomic,readonly,strong)NSURL * _Nullable url;
//当前上传任务的参数
@property (nonatomic,readonly,strong)NSMutableDictionary * _Nullable param;
//任务对象的执行状态
@property (nonatomic,readonly,assign)NSURLSessionTaskState taskState;
//上传任务的唯一ID
@property (nonatomic,readonly,copy)NSString * _Nullable ID;

/**
 根据一个文件分片模型创建一个上传任务，执行 taskResume 方法开始上传
 使用 listenTaskExeCallback 方法传递block进行回调监听
 同时也可以选择实现协议方法进行回调监听
 */
+ (instancetype _Nonnull )initWithStreamModel:(HTFileStreamSeparation * _Nonnull)fileStream;

/**
 监听一个已存在的上传任务的状态
 */
- (void)listenTaskExeCallback:(finishHandler _Nonnull)block
                      success:(success _Nonnull)successBlock;

/**
 根据一个文件分片模型的字典创建一个上传任务(处于等待状态)字典
 */
+ (NSMutableDictionary<NSString*,HTUploadTask*> *_Nullable)uploadTasksWithDict:(NSDictionary<NSString*,HTFileStreamSeparation*> *_Nullable)dict;

/**
 根据一个文件分片模型创建一个上传任务,执行 startExe 方法开始上传,结果会由block回调出来
 */
- (instancetype _Nonnull)initWithStreamModel:(HTFileStreamSeparation *_Nonnull)fileStream
                                      finish:(finishHandler _Nonnull)block
                                     success:(success _Nonnull)successBlock;


//继续/开始上传
- (void)taskResume;

//取消/暂停上传
- (void)taskCancel;

@end

NS_ASSUME_NONNULL_END
