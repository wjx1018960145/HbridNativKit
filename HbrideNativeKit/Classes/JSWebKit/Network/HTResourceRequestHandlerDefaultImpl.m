//
//  HTResourceRequestHandlerDefaultImpl.m
//  HybridForiOS
//
//  Created by wjx on 2020/3/10.
//  Copyright © 2020 WJX. All rights reserved.
//

#import "HTResourceRequestHandlerDefaultImpl.h"
#import "HTThreadSafeMutableDictionary.h"
#import "HTAppConfiguration.h"
#import "HTResourceResponse.h"
@interface HTResourceRequestHandlerDefaultImpl()<NSURLSessionDataDelegate>


@end



@implementation HTResourceRequestHandlerDefaultImpl
{
    NSURLSession *_session;
    HTThreadSafeMutableDictionary<NSURLSessionDataTask *, id<HTResourceRequestDelegate>> *_delegates;
}

#pragma mark - WXResourceRequestHandler

- (void)sendRequest:(HTResourceRequest *)request withDelegate:(id<HTResourceRequestDelegate>)delegate
{
    if (!_session) {
        NSURLSessionConfiguration *urlSessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        if ([HTAppConfiguration customizeProtocolClasses].count > 0) {
            NSArray *defaultProtocols = urlSessionConfig.protocolClasses;
            urlSessionConfig.protocolClasses = [[HTAppConfiguration customizeProtocolClasses] arrayByAddingObjectsFromArray:defaultProtocols];
        }
        _session = [NSURLSession sessionWithConfiguration:urlSessionConfig
                                                 delegate:self
                                            delegateQueue:[NSOperationQueue mainQueue]];
        _delegates = [HTThreadSafeMutableDictionary new];
    }
    
    NSURLSessionDataTask *task = [_session dataTaskWithRequest:request];
    request.taskIdentifier = task;
    [_delegates setObject:delegate forKey:task];
    [task resume];
}
- (void)cancelRequest:(HTResourceRequest *)request
{
    if ([request.taskIdentifier isKindOfClass:[NSURLSessionTask class]]) {
        NSURLSessionTask *task = (NSURLSessionTask *)request.taskIdentifier;
        [task cancel];
        [_delegates removeObjectForKey:task];
    }
}
#pragma mark - NSURLSessionTaskDelegate & NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    id<HTResourceRequestDelegate> delegate = [_delegates objectForKey:task];
    [delegate request:(HTResourceRequest *)task.originalRequest didSendData:bytesSent totalBytesToBeSent:totalBytesExpectedToSend];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)task
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    id<HTResourceRequestDelegate> delegate = [_delegates objectForKey:task];
    [delegate request:(HTResourceRequest *)task.originalRequest didReceiveResponse:(HTResourceResponse *)response];
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)task didReceiveData:(NSData *)data
{
    id<HTResourceRequestDelegate> delegate = [_delegates objectForKey:task];
    [delegate request:(HTResourceRequest *)task.originalRequest didReceiveData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    id<HTResourceRequestDelegate> delegate = [_delegates objectForKey:task];
    if (error) {
        [delegate request:(HTResourceRequest *)task.originalRequest didFailWithError:error];
    }else {
        [delegate requestDidFinishLoading:(HTResourceRequest *)task.originalRequest];
    }
    [_delegates removeObjectForKey:task];
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * __nullable credential))completionHandler {
    
    //    NSURLSessionAuthChallengeUseCredential = 0, 使用（信任）证书
    //    NSURLSessionAuthChallengePerformDefaultHandling = 1, 默认，忽略
    //    NSURLSessionAuthChallengeCancelAuthenticationChallenge = 2,   取消
    //    NSURLSessionAuthChallengeRejectProtectionSpace = 3,      这次取消，下载次还来问
    
    NSLog(@"%@>>>>>>>>>>>>>>>>>>>>>>>>",challenge.protectionSpace);
    // 如果是请求证书信任，我们再来处理，其他的不需要处理
    
    if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
        NSURLCredential *cre = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        // 调用block
        completionHandler(NSURLSessionAuthChallengeUseCredential,cre);
    }
}

#ifdef __IPHONE_10_0
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didFinishCollectingMetrics:(NSURLSessionTaskMetrics *)metrics
{
    id<HTResourceRequestDelegate> delegate = [_delegates objectForKey:task];
    [delegate request:(HTResourceRequest *)task.originalRequest didFinishCollectingMetrics:metrics];
}
#endif

@end
