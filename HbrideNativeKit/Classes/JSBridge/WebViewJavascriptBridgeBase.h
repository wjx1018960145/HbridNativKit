//
//  WebViewJavascriptBridgeBase.h
//  HybridForiOS
//
//  Created by wjx on 2020/3/2.
//  Copyright © 2020 WJX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebViewJavascriptBridge_JS.h"
#define kOldProtocolScheme @"htjbscheme"
#define kNewProtocolScheme @"https"
#define kQueueHasMessage   @"__htjb_queue_message__"
#define kBridgeLoaded      @"__bridge_loaded__"

typedef void(^HTJBResponseCallback)(id _Nullable  responseData);
typedef void(^HTJBProgessCallback)(id _Nullable progressData);
//typedef void (^HTModuleKeepAliveCallback)(id _Nullable result, BOOL keepAlive);
typedef void(^HTJBHandler)(id _Nullable data,HTJBResponseCallback _Nullable responseCallback);
typedef void(^HTJBNoParamsHandler)(HTJBResponseCallback _Nullable responseCallback);
typedef void(^HTJBBlackHandler)(id _Nullable data,HTJBProgessCallback _Nullable progressCallback,HTJBResponseCallback _Nullable responseCallback);

typedef NSDictionary  HTJBMessage;

@protocol WebViewJavascriptBridgeBaseDelegate <NSObject>

- (NSString*_Nullable) _evaluateJavascript:(NSString*_Nullable)javascriptCommand;

@end

@interface WebViewJavascriptBridgeBase : NSObject
@property (nonatomic, weak) id<WebViewJavascriptBridgeBaseDelegate> _Nullable delegate;
@property (nonatomic, strong) NSMutableArray * _Nullable startupMessageQueue;
@property (nonatomic, strong) NSMutableDictionary * _Nullable responseCallbacks;
@property (nonatomic, strong) NSMutableDictionary * _Nullable messageHandlers;
@property (nonatomic, strong) HTJBHandler _Nullable messageHandler;
+ (instancetype _Nullable )bridgeBase;
+ (void)enableLogging;
+ (void)setLogMaxLength:(int)length;
- (void)reset;
- (void)sendData:(id _Nullable )data responseCallback:(HTJBResponseCallback _Nonnull )responseCallback handlerName:(NSString*_Nullable)handlerName;
- (void)flushMessageQueue:(NSString *_Nullable)messageQueueString;
- (void)injectJavascriptFile;
- (BOOL)isWebViewJavascriptBridgeURL:(NSURL*_Nullable)url;
- (BOOL)isQueueMessageURL:(NSURL*_Nullable)urll;
- (BOOL)isBridgeLoadedURL:(NSURL*_Nullable)urll;
- (void)logUnkownMessage:(NSURL*_Nullable)url;
- (NSString *_Nullable)webViewJavascriptCheckCommand;
- (NSString *_Nullable)webViewJavascriptFetchQueyCommand;
- (void)disableJavscriptAlertBoxSafetyTimeout;

@end



