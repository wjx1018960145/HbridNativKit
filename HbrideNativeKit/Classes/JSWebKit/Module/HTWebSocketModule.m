//
//  HTWebSocketModule.m
//  HybridForiOS
//
//  Created by wjx on 2020/3/10.
//  Copyright © 2020 WJX. All rights reserved.
//

#import "HTWebSocketModule.h"
#import "HTWebSocketLoader.h"
#import "HTUtility.h"
#import "HTLog.h"
@interface HTWebSocketModule()
@property(nonatomic,copy)HTModuleKeepAliveCallback errorCallBack;
@property(nonatomic,copy)HTModuleKeepAliveCallback messageCallBack;
@property(nonatomic,copy)HTModuleKeepAliveCallback openCallBack;
@property(nonatomic,copy)HTModuleKeepAliveCallback closeCallBack;

@end

@implementation HTWebSocketModule{
    HTWebSocketLoader *loader;
}

@synthesize htInstance;

- (BOOL)registerBridge:(nonnull WKWebViewJavascriptBridge *)bridge {
    
    [bridge registerHandler:@"WebSocket" handler:^(id data, HTJBResponseCallback responseCallback) {
        NSLog(@"%@",data);
        NSString *url = data[@"url"];
        NSString *protocol = data[@"protocol"];
        // check url
           NSURL* theURL = [NSURL URLWithString:url];
           if (theURL == nil) {
               return;
           }
           NSString *scheme = theURL.scheme.lowercaseString;
           if (!([scheme isEqualToString:@"ws"] || [scheme isEqualToString:@"http"] ||
                 [scheme isEqualToString:@"wss"] || [scheme isEqualToString:@"https"])) {
               return;
           }
           
        if(self->loader)
           {
               [self->loader clear];
           }
        self->loader = [[HTWebSocketLoader alloc] initWithUrl:url protocol:protocol];
           __weak typeof(self) weakSelf = self;
        self->loader.onReceiveMessage = ^(id message) {
               if (weakSelf) {
                   NSMutableDictionary *dic = [NSMutableDictionary new];
                   if([message isKindOfClass:[NSString class]]) {
                       [dic setObject:message forKey:@"data"];
                   }else if([message isKindOfClass:[NSData class]]){
                       [dic setObject:[HTUtility dataToBase64Dict:message] forKey:@"data"];
                   }
                   if (weakSelf.messageCallBack) {
                       weakSelf.messageCallBack(dic,true);;
                   }
               }
           };
        self->loader.onOpen = ^() {
               if (weakSelf) {
                   if (weakSelf.openCallBack) {
                       NSMutableDictionary *dict = [NSMutableDictionary new];
                       weakSelf.openCallBack(dict,true);;
                   }
               }
           };
        self->loader.onFail = ^(NSError *error) {
               if (weakSelf) {
                   HTLogError(@":( Websocket Failed With Error %@", error);
                   NSMutableDictionary *dict = [NSMutableDictionary new];
                   [dict setObject:error.userInfo?[HTUtility JSONString:error.userInfo]:@"" forKey:@"data"];
                   if (weakSelf.errorCallBack) {
                       weakSelf.errorCallBack(dict, true);
                   }
               }
           };
        self->loader.onClose = ^(NSInteger code,NSString *reason,BOOL wasClean) {
               if (weakSelf) {
                   if (weakSelf.closeCallBack) {
                       HTLogInfo(@"Websocket colse ");
                       NSMutableDictionary * callbackRsp = [[NSMutableDictionary alloc] init];
                       [callbackRsp setObject:[NSNumber numberWithInteger:code] forKey:@"code"];
                       [callbackRsp setObject:reason?reason:@"" forKey:@"reason"];
                       [callbackRsp setObject:wasClean?@true:@false forKey:@"wasClean"];
                       if (weakSelf.closeCallBack) {
                           weakSelf.closeCallBack(callbackRsp,false);
                       }
                   }
               }
           };
           
        [self->loader open];
    }];
    
    [bridge registerHandler:@"send" handler:^(id data, HTJBResponseCallback responseCallback) {
        
        if([data isKindOfClass:[NSString class]]){
            [self->loader send:data];
        }else if([data isKindOfClass:[NSDictionary class]]){
            NSData *sendData = [HTUtility base64DictToData:data];
            if(sendData){
                [self->loader send:sendData];
            }
        }
        
    }];
    
    [bridge registerHandler:@"close" handler:^(id data, HTJBResponseCallback responseCallback) {
    [self->loader close];
    }];
    
    [bridge registerHandler:@"close" handler:^(id data, HTJBResponseCallback responseCallback) {
        NSString *code = data[@"code"];
        NSString *reason = data[@"reason"];
    if([HTUtility isBlankString:code])
        
       {
           [self->loader close];
           return;
       }
       [self->loader close:[code integerValue] reason:reason];
        
    }];
    
    [bridge registerHandler:@"onerror" handler:^(id data, HTJBResponseCallback responseCallback) {
        
    }];
    
    return YES;
}


-(void)dealloc
{
    [loader clear];
}
@end
