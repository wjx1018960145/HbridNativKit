//
//  HTResourceRequestHandler.h
//  HybridForiOS
//
//  Created by wjx on 2020/3/10.
//  Copyright © 2020 WJX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTResourceRequest.h"
#import "HTResourceResponse.h"
NS_ASSUME_NONNULL_BEGIN
@protocol HTResourceRequestDelegate <NSObject>

// Periodically informs the delegate of the progress of sending content to the server.
- (void)request:(HTResourceRequest *)request didSendData:(unsigned long long)bytesSent totalBytesToBeSent:(unsigned long long)totalBytesToBeSent;

// Tells the delegate that the request received the initial reply (headers) from the server.
- (void)request:(HTResourceRequest *)request didReceiveResponse:(HTResourceResponse * _Nullable)response;

// Tells the delegate that the request has received some of the expected data.
- (void)request:(HTResourceRequest *)request didReceiveData:(NSData * _Nullable)data;

// Tells the delegate that the request finished transferring data.
- (void)requestDidFinishLoading:(HTResourceRequest *)request;

// Tells the delegate that the request failed to load successfully.
- (void)request:(HTResourceRequest *)request didFailWithError:(NSError * _Nullable)error;
    
// Tells the delegate that when complete statistics information has been collected for the task.
#ifdef __IPHONE_10_0
- (void)request:(HTResourceRequest *)request didFinishCollectingMetrics:(NSURLSessionTaskMetrics *)metrics API_AVAILABLE(macosx(10.12), ios(10.0), watchos(3.0), tvos(10.0));
#endif

@end
@protocol HTResourceRequestHandler <NSObject>
// Send a resource request with a delegate
- (void)sendRequest:(HTResourceRequest *)request withDelegate:(id<HTResourceRequestDelegate>)delegate;

@optional

// Cancel the ongoing request
- (void)cancelRequest:(HTResourceRequest *)request;
@end

NS_ASSUME_NONNULL_END
