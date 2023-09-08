//
//  HTImageUploadManager.h
//  HybridForiOS
//
//  Created by wjx on 2020/4/22.
//  Copyright © 2020 WJX. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HTImageUploadTask;
NS_ASSUME_NONNULL_BEGIN

typedef void(^Progress)(float value);
typedef void(^Success)(NSDictionary *value);
typedef void(^Fail)(NSError *error);

@interface HTImageUploadManager : NSObject
//配置的上传路径
@property (nonatomic,readonly)NSURL *url;

//配置的请求体
@property (nonatomic,readonly)NSMutableURLRequest *request;


//获得管理类单例对象
+ (instancetype)shardUploadManager;

//配置全局默认参数
/**
 @param request 默认请求头
 */
- (void)config:(NSMutableURLRequest * _Nonnull)request;
//根据文件路径创建上传任务
- (HTImageUploadTask *_Nullable)createUploadTask:(NSString *_Nonnull)filePath params:(NSDictionary*)params success:(Success)success progress:(Progress)progress fail:(Fail)fail;
@end

NS_ASSUME_NONNULL_END
