//
//  HTImageUploadTask.m
//  HybridForiOS
//
//  Created by wjx on 2020/4/22.
//  Copyright © 2020 WJX. All rights reserved.
//

#import "HTImageUploadTask.h"
#import "HTImageUploadManager.h"
#import <UIKit/UIKit.h>
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

NSString *const HTImageUploadTaskExeing = @"TaskExeing";
NSString *const HTImageUploadTaskExeError = @"TaskExeError";
NSString *const HTImageUploadTaskExeEnd = @"TaskExeEnd";
NSString *const HTImageUploadTaskExeSuspend = @"TaskExeSuspend";

@interface HTImageUploadTask()<NSURLSessionDataDelegate>
@property (nonatomic,strong)NSURLSessionUploadTask *uploadTask;
@property (nonatomic,strong)NSMutableURLRequest *request;
@property (nonatomic, strong) NSURLSession *session;
@end

@implementation HTImageUploadTask


- (void)taskResume {
    [self startExe];
}

- (void)startExe{
    
    
    
 
    [self uploadTaskWithUrl:self.url param:self.param uploadData:UIImageJPEGRepresentation([UIImage imageWithContentsOfFile:self.filePath],0.01) completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
         NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
        if (!error && httpResponse.statusCode==200) {
            
             NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingFragmentsAllowed error:nil];
            if ([dic[@"code"] isEqualToString:@"S"]) {
                       [self sendNotionWithKey:HTImageUploadTaskExeEnd userInfo:dic];
                }
            
            
        }else{
             [self sendNotionWithKey:HTImageUploadTaskExeError userInfo:@{@"error":@(httpResponse.statusCode)}];
        }
       
        
     
           
        
        
        NSLog(@"%@",data);
        
    }];
}

#pragma mark NSURLSessionDataDelegate
/*
 *  @param bytesSent                本次发送的数据
 *  @param totalBytesSent           上传完成的数据大小
 *  @param totalBytesExpectedToSend 文件的总大小
 */
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    [self sendNotionWithKey:HTImageUploadTaskExeing userInfo:@{@"value":@(1.0 *totalBytesSent / totalBytesExpectedToSend)}];
    
    NSLog(@"%f",1.0 *totalBytesSent / totalBytesExpectedToSend);
}
- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * __nullable credential))completionHandler {
    
    //    NSURLSessionAuthChallengeUseCredential = 0, 使用（信任）证书
    //    NSURLSessionAuthChallengePerformDefaultHandling = 1, 默认，忽略
    //    NSURLSessionAuthChallengeCancelAuthenticationChallenge = 2,   取消
    //    NSURLSessionAuthChallengeRejectProtectionSpace = 3,      这次取消，下载次还来问
    
    
    
//     if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
//            NSURLCredential *cre = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
//            // 调用block
//            completionHandler(NSURLSessionAuthChallengeUseCredential,cre);
//        }
//
    
//    return;
    
//    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
//
//    NSURLCredential *credential = nil;
//
//    // 服务器验证
//
//    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
//
//    {
//
//        /* 调用自定义的验证过程 */
//
//        if ([self myCustomValidation:challenge]) {
//
//            credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
//
//            if (credential) {
//
//                disposition = NSURLSessionAuthChallengeUseCredential;
//
//            }
//
//        } else {
//
//            /* 无效的话，取消 */
//
//            disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
//
//        }
//
//    }else if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodClientCertificate])
//
//    {//客户端认证
//
//        NSString *thePath = [[NSBundle mainBundle] pathForResource:@"gtw" ofType:@"p12"];
//
//        NSData *PKCS12Data = [[NSData alloc] initWithContentsOfFile:thePath];
//
//        CFDataRef inPKCS12Data = (CFDataRef)CFBridgingRetain(PKCS12Data);
//
//        SecIdentityRef identity;
//
//        // 读取p12证书中的内容
//
//        OSStatus result = [self extractP12Data:inPKCS12Data toIdentity:&identity];
//
//        if(result != errSecSuccess){
//
//            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
//
//            return;
//
//        }
//
//        SecCertificateRef certificate = NULL;
//
//        SecIdentityCopyCertificate (identity, &certificate);
//
//        const void *certs[] = {certificate};
//
//        CFArrayRef certArray = CFArrayCreate(kCFAllocatorDefault, certs, 1, NULL);
//
//        credential = [NSURLCredential credentialWithIdentity:identity certificates:(NSArray*)CFBridgingRelease(certArray) persistence:NSURLCredentialPersistencePermanent];
//
//        if (credential) {
//
//            disposition = NSURLSessionAuthChallengeUseCredential;
//
//        }
//
//    }
//
//    if (completionHandler) {
//
//        completionHandler(disposition, credential);
//
//    }
//
    
    
    
    
    NSLog(@"%@>>>>>>>>>>>>>>>>>>>>>>>>",challenge.protectionSpace);
    // 如果是请求证书信任，我们再来处理，其他的不需要处理
    
    if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
        NSURLCredential *cre = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        // 调用block
        completionHandler(NSURLSessionAuthChallengeUseCredential,cre);
    }
}


- (void)sendNotionWithKey:(NSString *)key userInfo:(NSDictionary *)dict{
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:key object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}


/**
 *  上传任务
 */
-(void)uploadTaskWithUrl:(NSURL *)url param:(NSDictionary *)param uploadData:(NSData *)data completionHandler:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler

{
   
    _param = [NSMutableDictionary dictionaryWithDictionary:param];
    
   
    self.uploadTask = [self.session uploadTaskWithRequest:[self uploadRequest] fromData:[self taskRequestBodyWithParam:param uploadData:data] completionHandler:completionHandler];
    
    [_uploadTask resume];
    
}

-(NSURLSession *)session
{
    if (_session == nil) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        //是否运行蜂窝访问
        config.allowsCellularAccess = YES;
        config.timeoutIntervalForRequest = 15;
        
        _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}

-(NSMutableURLRequest*)uploadRequest
{
    if ([HTImageUploadManager shardUploadManager].request) {
      
        _request = [HTImageUploadManager shardUploadManager].request;
        [_request setValue:self.param[@"token"] forHTTPHeaderField:@"ht_token"];
         [_request setValue:self.param[@"htsign"] forHTTPHeaderField:@"ht_sign"];
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
    
    NSString *body=[NSString stringWithFormat:@"%@Content-Disposition: form-data; name=\"picture\"; filename=\"%@\";%@",StartBoundary,param[@"fileName"],Wrap2];
    [totlData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    [totlData appendData:data];
    [totlData appendData:[Wrap1 dataUsingEncoding:NSUTF8StringEncoding]];
    [totlData appendData:[EndBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    return totlData;
}
@end
