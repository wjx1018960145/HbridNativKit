//
//  HTNetworkProtocol.h
//  HybridForiOS
//
//  Created by wjx on 2020/3/10.
//  Copyright © 2020 WJX. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
__attribute__ ((deprecated("Use HTResourceRequestHandler instead")))
@protocol HTNetworkProtocol <NSObject>

- (id)sendRequest:(NSURLRequest *)request withSendingData:(nullable void (^)(int64_t bytesSent, int64_t totalBytes))sendDataCallback
   withResponse:(nullable void (^)(NSURLResponse *response))responseCallback
withReceiveData:(nullable void (^)(NSData *data))receiveDataCallback
withCompeletion:(nullable void (^)(NSData *totalData, NSError *error))completionCallback;

@end

NS_ASSUME_NONNULL_END
