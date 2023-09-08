//
//  HTWebBridgeProtocol.h
//  HybridForiOS
//
//  Created by wjx on 2020/3/4.
//  Copyright © 2020 WJX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTH5ViewController.h"

@class WKWebViewJavascriptBridge;

NS_ASSUME_NONNULL_BEGIN

#define MSG_SUCCESS     @"HT_SUCCESS"
#define MSG_NO_HANDLER  @"HT_NO_HANDLER"
#define MSG_NO_PERMIT   @"HT_NO_PERMISSION"
#define MSG_FAILED      @"HT_FAILED"
#define MSG_PARAM_ERR   @"HT_PARAM_ERR"
#define MSG_EXP         @"HT_EXCEPTION"

@protocol HTWebBridgeProtocol <NSObject>
// Plugin在 WebViewJavascriptBridge 中 注册
- (BOOL)registerBridge:(WKWebViewJavascriptBridge*)bridge;
@property (nonatomic, weak) UIViewController *htInstance;

@optional

- (NSString *)handlerName;

- (BOOL)responseToHandler:(NSString *)handlerName;

- (void)performHandler:(NSString *)handlerName parameter:(NSObject *)parameter;
typedef void (^HTModuleKeepAliveCallback)(id _Nullable result, BOOL keepAlive);
@end

NS_ASSUME_NONNULL_END
