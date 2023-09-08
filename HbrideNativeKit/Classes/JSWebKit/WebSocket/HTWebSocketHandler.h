//
//  HTWebSocketHandler.h
//  HybridForiOS
//
//  Created by wjx on 2020/3/10.
//  Copyright © 2020 WJX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTWebBridgeProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@protocol HTWebSocketDelegate<NSObject>
- (void)didOpen;
- (void)didFailWithError:(NSError *)error;
- (void)didReceiveMessage:(id)message;
- (void)didCloseWithCode:(NSInteger)code reason:(nullable NSString *)reason wasClean:(BOOL)wasClean;
@end

@protocol HTWebSocketHandler <NSObject>
- (void)open:(NSString *)url protocol:(NSString *)protocol identifier:(nullable NSString *)identifier withDelegate:(id<HTWebSocketDelegate>)delegate;
- (void)send:(NSString *)identifier data:(NSString *)data;
- (void)close:(NSString *)identifier;
- (void)close:(NSString *)identifier code:(NSInteger)code reason:(nullable NSString *)reason;
- (void)clear:(NSString *)identifier;
@end

NS_ASSUME_NONNULL_END
