//
//  WebViewJavascriptBridgeBase.m
//  HybridForiOS
//
//  Created by wjx on 2020/3/2.
//  Copyright © 2020 WJX. All rights reserved.
//

#import "WebViewJavascriptBridgeBase.h"
#import "NSBundle+Resource.h"
@implementation WebViewJavascriptBridgeBase
{
      __weak id _webViewDelegate;
     long _uniqueId;
    
}
static bool logging = false;
static int logMaxLength = 500;
static WebViewJavascriptBridgeBase *_sharedInstance = nil;

+(instancetype)bridgeBase {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}


- (id)init {
    if (self = [super init]) {
        self.messageHandlers = [NSMutableDictionary dictionary];
        self.startupMessageQueue = [NSMutableArray array];
        self.responseCallbacks = [NSMutableDictionary dictionary];
               _uniqueId = 0;
    }
    return self;
}

- (void)dealloc {
    self.startupMessageQueue = nil;
    self.responseCallbacks = nil;
    self.messageHandlers = nil;
}

+ (void)enableLogging{
    logging = true;
}

+ (void)setLogMaxLength:(int)length {
    logMaxLength = length;
}

- (void)reset {
    self.startupMessageQueue = [NSMutableArray array];
    self.responseCallbacks = [NSMutableDictionary dictionary];
    _uniqueId = 0;
}

- (void)sendData:(id)data responseCallback:(HTJBResponseCallback)responseCallback handlerName:(NSString*)handlerName {
    NSMutableDictionary *message = [NSMutableDictionary dictionary];
    if (data) {
        message[@"data"] = data;
    }
     if (responseCallback) {
           NSString* callbackId = [NSString stringWithFormat:@"objc_cb_%ld", ++_uniqueId];
           self.responseCallbacks[callbackId] = [responseCallback copy];
           message[@"callbackId"] = callbackId;
       }
       
       if (handlerName) {
           message[@"handlerName"] = handlerName;
       }
       [self _queueMessage:message];
    
}

- (void)_queueMessage:(HTJBMessage*)message {
    if (self.startupMessageQueue) {
        [self.startupMessageQueue addObject:message];
    }else{
        [self _dispatchMessage:message];
    }
}

- (void)_dispatchMessage:(HTJBMessage*)message{
    NSString *messageJSON = [self _serializeMessage:message pretty:NO];
    [self _log:@"SEND" json:messageJSON];
    
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\'" withString:@"\\\'"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\f" withString:@"\\f"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\u2028" withString:@"\\u2028"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\u2029" withString:@"\\u2029"];
    NSString *javascriptCommand = [NSString stringWithFormat:@"WebViewJavascriptBridge._handleMessageFromObjC('%@');",messageJSON];
    
    if ([[NSThread currentThread] isMainThread]) {
        
        [self _evaluateJavascript:javascriptCommand];
    }else{
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self _evaluateJavascript:javascriptCommand];
        });
    }
    
}
- (void)_log:(NSString *)action json:(id)json{
    if (!logging) {
        return;
    }
    if (![json isKindOfClass:[NSString class]]) {
        json = [self _serializeMessage:json pretty:YES];
    }
    if ([json length] > logMaxLength) {
           NSLog(@"HTJB %@: %@ [...]", action, [json substringToIndex:logMaxLength]);
       } else {
           NSLog(@"HTJB %@: %@", action, json);
       }
}

- (NSString*)_serializeMessage:(HTJBMessage*)message pretty:(BOOL)pretty{
    return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:message options:(NSJSONWritingOptions)(pretty ? NSJSONWritingPrettyPrinted : 0) error:nil] encoding:NSUTF8StringEncoding];
}
#pragma #########################华丽分割线 私有方法部分################
- (void) _evaluateJavascript:(NSString *)javascriptCommand {
    [self.delegate _evaluateJavascript:javascriptCommand];
}
#pragma ##########################################################


- (void)flushMessageQueue:(NSString*)messageQueueString {
    if (messageQueueString==nil||messageQueueString.length == 0) {
         NSLog(@"WebViewJavascriptBridge: WARNING: ObjC got nil while fetching the message queue JSON from webview. This can happen if the WebViewJavascriptBridge JS is not currently present in the webview, e.g if the webview just loaded a new page.");
        return;
    }
    
    id messages = [self _deserializeMessageJSON:messageQueueString];
    for (HTJBMessage *message in messages) {
        if (![message isKindOfClass:[HTJBMessage class]]) {
            NSLog(@"WebViewJavascriptBridge: WARNING: Invalid %@ received: %@", [message class], message);
            continue;
        }
        [self _log:@"RCVD" json:message];
         NSString* responseId = message[@"responseId"];
        if (responseId) {
            HTJBResponseCallback responseCallback = _responseCallbacks[responseId];
            responseCallback(message[@"responseData"]);
            [self.responseCallbacks removeObjectForKey:responseId];
        }else{
             HTJBResponseCallback responseCallback = NULL;
            HTJBProgessCallback   progessCallback = NULL;
            NSString* callbackId = message[@"callbackId"];
            if (callbackId) {
                responseCallback = ^(id responseData){
                    if (responseData == nil) {
                        responseData = [NSNull null];
                    }
                    HTJBMessage *msg = @{
                        @"responseId":callbackId,
                        @"responseData":responseData
                    };
                    
                    [self _queueMessage:msg];
                };
                progessCallback =^(id progressData){
                    if (progressData == nil) {
                        progressData = [NSNull null];
                    }
                    HTJBMessage *msg = @{
                        @"responseId":callbackId,
                        @"progressData":progressData
                    };
                    [self _queueMessage:msg];
                };
            }else{
                responseCallback = ^(id ignoreResponseData) {
                    // Do nothing
                };
                progessCallback = ^(id ignoreProgressData){
                    
                };
            }
            
            
            
            HTJBHandler handler = self.messageHandlers[message[@"handlerName"]];
            NSLog(@"%@",handler);
//            if (self.messageHandlers[messages[@"handlerName"]]  ) {
//
//            }
            
          
            
            if (!handler) {
                   NSLog(@"HTJBNoHandlerException, No handler for message from JS: %@", message);
                   continue;
                    }
                       
            handler(message[@"data"], responseCallback);
            
        }
        
    }
    
}

- (NSString*)_deserializeMessageJSON:(NSString*)messageJSON{
    return [NSJSONSerialization JSONObjectWithData:[messageJSON dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
}


- (void)injectJavascriptFile {
    NSString *js = WebViewJavascriptBridge_js();
    [self _evaluateJavascript:js];
    if (self.startupMessageQueue) {
         NSArray* queue = self.startupMessageQueue;
        self.startupMessageQueue = nil;
        for (id queuedMessage in queue) {
            [self _dispatchMessage:queuedMessage];
            }
    }
    
    
}
- (BOOL)isWebViewJavascriptBridgeURL:(NSURL*)url {
    if (![self isSchemeMatch:url]) {
        return NO;
    }else{
        return [self isBridgeLoadedURL:url] || [self isQueueMessageURL:url];
    }
}
- (BOOL)isSchemeMatch:(NSURL*)url {
    NSString *scheme = url.scheme.lowercaseString;
    return [scheme isEqualToString:kNewProtocolScheme]||[scheme isEqualToString:kOldProtocolScheme];
    
}
- (BOOL)isQueueMessageURL:(NSURL*)url {
    NSString* host = url.host.lowercaseString;
    return [self isSchemeMatch:url] && [host isEqualToString:kQueueHasMessage];
}

- (BOOL)isBridgeLoadedURL:(NSURL*)url {
    NSString* host = url.host.lowercaseString;
    return [self isSchemeMatch:url] && [host isEqualToString:kBridgeLoaded];
}
- (void)logUnkownMessage:(NSURL*)url {
     NSLog(@"WebViewJavascriptBridge: WARNING: Received unknown WebViewJavascriptBridge command %@", [url absoluteString]);
}
- (NSString*)webViewJavascriptCheckCommand {
    return @"typeof WebViewJavascriptBridge == \'object\';";
}
- (NSString*)webViewJavascriptFetchQueyCommand {
     return @"WebViewJavascriptBridge._fetchQueue();";
}
- (void)disableJavscriptAlertBoxSafetyTimeout {
    [self sendData:nil responseCallback:nil handlerName:@"_disableJavascriptAlertBoxSafetyTimeout"];

}

@end

