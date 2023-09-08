//
//  HTResourceLoader.m
//  HybridForiOS
//
//  Created by wjx on 2020/3/10.
//  Copyright © 2020 WJX. All rights reserved.
//

#import "HTResourceLoader.h"
#import "HTLog.h"
#import "HTDefine.h"
#import "HTResourceRequestHandler.h"
#import "HTHandlerFactory.h"
//deprecated
#import "HTNetworkProtocol.h"
@interface HTResourceLoader()<HTResourceRequestDelegate>


@end


@implementation HTResourceLoader
{
    NSMutableData *_data;
    HTResourceResponse *_response;
}
- (instancetype)initWithRequest:(HTResourceRequest *)request
{
    if (self = [super init]) {
        self.request = request;
    }
    
    return self;
}
- (void)setRequest:(HTResourceRequest *)request
{
    if (_request) {
        [self cancel:nil];
    }
    
    _request = request;
}
- (void)start
{
    if ([_request.URL isFileURL]) {
        [self _handleFileURL:_request.URL];
        return;
    }
    
    id<HTResourceRequestHandler> requestHandler = [HTHandlerFactory handlerForProtocol:@protocol(HTResourceRequestHandler)];
    
     if ([HTHandlerFactory handlerForProtocol:NSProtocolFromString(@"HTNetworkProtocol")] ) {
         [self _handleDEPRECATEDNetworkHandler];
            
            // deprecated logic
    //
        } else if ( requestHandler){
            [requestHandler sendRequest:_request withDelegate:self];
           
        } else {
            HTLogError(@"No resource request handler found!");
        }
    
}

- (void)cancel:(NSError *__autoreleasing *)error
{
    id<HTResourceRequestHandler> requestHandler = [HTHandlerFactory handlerForProtocol:@protocol(HTResourceRequestHandler)];
    if ([requestHandler respondsToSelector:@selector(cancelRequest:)]) {
        [requestHandler cancelRequest:_request];
    } else if (error) {
        *error = [NSError errorWithDomain:HT_ERROR_DOMAIN code:-2204 userInfo:@{NSLocalizedDescriptionKey: @"handle:%@ not respond to cancelRequest"}];
    }
}
- (void)_handleFileURL:(NSURL *)url
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *fileData = [[NSFileManager defaultManager] contentsAtPath:[url path]];
        if (self.onFinished) {
            self.onFinished([[HTResourceResponse alloc]initWithURL:url statusCode:200 HTTPVersion:@"1.1" headerFields:nil], fileData);
        }
    });
}

- (void)_handleDEPRECATEDNetworkHandler
{
    HTLogWarning(@"HTNetworkProtocol is deprecated, use HTResourceRequestHandler instead!");
    id networkHandler = [HTHandlerFactory handlerForProtocol:NSProtocolFromString(@"HTNetworkProtocol")];
    __weak typeof(self) weakSelf = self;
    [networkHandler sendRequest:_request withSendingData:^(int64_t bytesSent, int64_t totalBytes) {
        if (weakSelf.onDataSent) {
            weakSelf.onDataSent(bytesSent, totalBytes);
        }
    } withResponse:^(NSURLResponse *response) {
        self->_response = (HTResourceResponse *)response;
        if (weakSelf.onResponseReceived) {
            weakSelf.onResponseReceived((HTResourceResponse *)response);
        }
    } withReceiveData:^(NSData *data) {
        if (weakSelf.onDataReceived) {
            weakSelf.onDataReceived(data);
        }
    } withCompeletion:^(NSData *totalData, NSError *error) {
        if (error) {
            if (weakSelf.onFailed) {
                weakSelf.onFailed(error);
            }
        } else {
            weakSelf.onFinished(self->_response, totalData);
            self->_response = nil;
        }
    }];
}
#pragma mark - WXResourceRequestDelegate

- (void)request:(HTResourceRequest *)request didSendData:(unsigned long long)bytesSent totalBytesToBeSent:(unsigned long long)totalBytesToBeSent
{
    HTLogDebug(@"request:%@ didSendData:%llu totalBytesToBeSent:%llu", request, bytesSent, totalBytesToBeSent);
    
    if (self.onDataSent) {
        self.onDataSent(bytesSent, totalBytesToBeSent);
    }
}
- (void)request:(HTResourceRequest *)request didReceiveResponse:(HTResourceResponse *)response
{
    HTLogDebug(@"request:%@ didReceiveResponse:%@ ", request, response);
    
    _response = response;
    _data = nil;
    
    if (self.onResponseReceived) {
        self.onResponseReceived(response);
    }
}

- (void)request:(HTResourceRequest *)request didReceiveData:(NSData *)data
{
    HTLogDebug(@"request:%@ didReceiveDataLength:%ld", request, (unsigned long)data.length);
    
    if (!_data) {
        _data = [NSMutableData new];
    }
    [_data appendData:data];
    
    if (self.onDataReceived) {
        self.onDataReceived(data);
    }
}
- (void)requestDidFinishLoading:(HTResourceRequest *)request
{
    HTLogDebug(@"request:%@ requestDidFinishLoading", request);
    
    if (self.onFinished) {
        self.onFinished(_response, _data);
    }
    
    _data = nil;
    _response = nil;
}
- (void)request:(HTResourceRequest *)request didFailWithError:(NSError *)error
{
    HTLogDebug(@"request:%@ didFailWithError:%@", request, error.localizedDescription);
    
    if (self.onFailed) {
        self.onFailed(error);
    }
    
    _data = nil;
    _response = nil;
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
- (void)request:(HTResourceRequest *)request didFinishCollectingMetrics:(NSURLSessionTaskMetrics *)metrics
{
    HTLogDebug(@"request:%@ didFinishCollectingMetrics", request);
}
#endif
@end
