//
//  WKWebViewJavascriptBridge.h
//  HybridForiOS
//
//  Created by wjx on 2020/3/2.
//  Copyright © 2020 WJX. All rights reserved.
//
#if (__MAC_OS_X_VERSION_MAX_ALLOWED > __MAC_10_9 || __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_1)
#define supportsWKWebView
#endif

#if defined supportsWKWebView

#import <Foundation/Foundation.h>
#import "WebViewJavascriptBridgeBase.h"
#import <WebKit/WebKit.h>

@interface WKWebViewJavascriptBridge : NSObject<WKNavigationDelegate,WebViewJavascriptBridgeBaseDelegate>

+(instancetype)bridgeForWebView:(WKWebView*)webView;
+(void)enableLogging;
- (void)registerHandler:(NSString*)handlerName handler:(HTJBHandler)handler;
- (void)registerNoParamsHandler:(NSString *)handlerName handler:(HTJBNoParamsHandler)handler;
- (void)registerMoreHandler:(NSString*)handleName handler:(HTJBBlackHandler)handler;

//自定义不用可以删除
- (void)registerModules:(NSDictionary *)modules;


- (void)removeHandler:(NSString*)handlerName;
- (void)callHandler:(NSString*)handlerName;
- (void)callHandler:(NSString*)handlerName data:(id)data;
- (void)callHandler:(NSString*)handlerName data:(id)data responseCallback:(HTJBResponseCallback)responseCallback;
- (void)reset;
- (void)setWebViewDelegate:(id)webViewDelegate;
- (void)disableJavscriptAlertBoxSafetyTimeout;

@end

#endif
