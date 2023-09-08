//
//  HTImageUploadTask.h
//  HybridForiOS
//
//  Created by wjx on 2020/4/22.
//  Copyright © 2020 WJX. All rights reserved.
//

#import <Foundation/Foundation.h>



NS_ASSUME_NONNULL_BEGIN

#ifdef __cplusplus
#define TASK_EXTERN        extern "C" __attribute__((visibility ("default")))
#else
#define TASK_EXTERN            extern __attribute__((visibility ("default")))
#endif


TASK_EXTERN NSString * _Nonnull const HTImageUploadTaskExeing;//上传中
TASK_EXTERN NSString * _Nonnull const HTImageUploadTaskExeError;//上传失败
TASK_EXTERN NSString * _Nonnull const HTImageUploadTaskExeEnd;//上传完成
TASK_EXTERN NSString * _Nonnull const HTImageUploadTaskExeSuspend;//上传暂停/取消

@interface HTImageUploadTask : NSObject

//当前上传任务的URL
@property (nonatomic,strong)NSURL * _Nullable url;
//当前上传任务的参数
@property (nonatomic,strong)NSMutableDictionary * _Nullable param;
//文件路径
@property (nonatomic, strong) NSString *filePath;
//继续/开始上传
- (void)taskResume;

@end

NS_ASSUME_NONNULL_END
