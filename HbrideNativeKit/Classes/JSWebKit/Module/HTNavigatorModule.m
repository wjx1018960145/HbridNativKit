//
//  HTNavigatorModule.m
//  HybridForiOS
//
//  Created by wjx on 2020/3/9.
//  Copyright © 2020 WJX. All rights reserved.
//

#import "HTNavigatorModule.h"
#import "HTBridgeCallBack.h"
#import "HTNavigationProtocol.h"
#import "HTHandlerFactory.h"
#import "HTConvert.h"
#import "NSDictionary+NilSafe.h"
@implementation HTNavigatorModule


- (BOOL)registerBridge:(nonnull WKWebViewJavascriptBridge *)bridge {
    
    [bridge registerHandler:@"push" handler:^(id data, HTJBResponseCallback responseCallback) {
        id<HTNavigationProtocol> navigator = [self navigator];
        UIViewController *container = self->htInstance;
        [navigator pushViewControllerWithParam:data completion:^(NSString * _Nonnull code, NSDictionary * _Nonnull responseData) {
            if (responseCallback && code) {
                responseCallback(code);
            }
        } withContainer:container];
//               NSLog(@"-----%@",data);
//               NSString *str = @"这是参数";
//               [HTBridgeCallBack wrapResponseCallBack:responseCallback message:@"点击了" result:YES responseObject:str];
           }];
    
    [bridge registerHandler:@"pop" handler:^(id  _Nullable data, HTJBResponseCallback  _Nullable responseCallback) {
        
        id<HTNavigationProtocol> navigator = [self navigator];
        UIViewController *container = self->htInstance;
        [navigator popViewControllerWithParam:data completion:^(NSString *code, NSDictionary *responseData) {
            if (responseCallback && code) {
                responseCallback(code);
            }
        } withContainer:container];
    }];
    
    [bridge registerHandler:@"popToRoot" handler:^(id  _Nullable data, HTJBResponseCallback  _Nullable responseCallback) {
          UIViewController *container = self->htInstance;
            BOOL animated = YES;
            [container.navigationController popToRootViewControllerAnimated:animated];
        if (responseCallback) {
            responseCallback(MSG_SUCCESS);
        }
    }];
    
#pragma mark Navigation Setup
    [bridge registerHandler:@"setNavBarBackgroundColor" handler:^(id  _Nullable data, HTJBResponseCallback  _Nullable responseCallback) {
        NSString *backgroundColor = data[@"backgroundColor"];
           if (!backgroundColor) {
               if (responseCallback) {
                   responseCallback(MSG_PARAM_ERR);
               }
           }
           
           id<HTNavigationProtocol> navigator = [self navigator];
           UIViewController *container = self->htInstance;
           [navigator setNavigationBackgroundColor:[HTConvert UIColor:backgroundColor] withContainer:container];
           if (responseCallback) {
               responseCallback(MSG_SUCCESS);
           }
    }];
    [bridge registerHandler:@"setNavBarLeftItem" handler:^(id  _Nullable data, HTJBResponseCallback  _Nullable responseCallback) {
         [self setNavigationItemWithParam:data position:HTNavigationItemPositionLeft withCallback:responseCallback];
    }];
    [bridge registerHandler:@"clearNavBarLeftItem" handler:^(id  _Nullable data, HTJBResponseCallback  _Nullable responseCallback) {
         [self clearNavigationItemWithParam:data position:HTNavigationItemPositionLeft withCallback:responseCallback];
    }];
    [bridge registerHandler:@"setNavBarRightItem" handler:^(id  _Nullable data, HTJBResponseCallback  _Nullable responseCallback) {
        [self setNavigationItemWithParam:data position:HTNavigationItemPositionRight withCallback:responseCallback];
    }];
    [bridge registerHandler:@"clearNavBarRightItem" handler:^(id  _Nullable data, HTJBResponseCallback  _Nullable responseCallback) {
        [self clearNavigationItemWithParam:data position:HTNavigationItemPositionRight withCallback:responseCallback];
    }];
    [bridge registerHandler:@"setNavBarMoreItem" handler:^(id  _Nullable data, HTJBResponseCallback  _Nullable responseCallback) {
         [self setNavigationItemWithParam:data position:HTNavigationItemPositionMore withCallback:responseCallback];
    }];
    [bridge registerHandler:@"clearNavBarMoreItem" handler:^(id  _Nullable data, HTJBResponseCallback  _Nullable responseCallback) {
         [self clearNavigationItemWithParam:data position:HTNavigationItemPositionMore withCallback:responseCallback];
    }];
    [bridge registerHandler:@"setNavBarTitle" handler:^(id  _Nullable data, HTJBResponseCallback  _Nullable responseCallback) {
         [self setNavigationItemWithParam:data position:HTNavigationItemPositionCenter withCallback:responseCallback];
    }];
    [bridge registerHandler:@"clearNavBarTitle" handler:^(id  _Nullable data, HTJBResponseCallback  _Nullable responseCallback) {
        
    }];
    [bridge registerHandler:@"setNavBarHidden" handler:^(id  _Nullable data, HTJBResponseCallback  _Nullable responseCallback) {
         [self clearNavigationItemWithParam:data position:HTNavigationItemPositionCenter withCallback:responseCallback];
    }];
    return YES;
}

- (void)setNavigationItemWithParam:(NSDictionary *)param position:(HTNavigationItemPosition)position withCallback:(HTJBResponseCallback)callback
{
    id<HTNavigationProtocol> navigator = [self navigator];
    UIViewController *container = self->htInstance;
    
    NSMutableDictionary *mutableParam = [param mutableCopy];
    
    if (self->htInstance) {
        [mutableParam setObject:self->htInstance forKey:@"instanceId"];
    }
    
    [navigator setNavigationItemWithParam:mutableParam position:position completion:^(NSString *code, NSDictionary *responseData) {
        if (callback && code) {
            callback(code);
        }
    } withContainer:container];
}
- (void)clearNavigationItemWithParam:(NSDictionary *)param position:(HTNavigationItemPosition)position withCallback:(HTJBResponseCallback)callback
{
    id<HTNavigationProtocol> navigator = [self navigator];
    UIViewController *container = self->htInstance;
    [navigator clearNavigationItemWithParam:param position:position completion:^(NSString *code, NSDictionary *responseData) {
        if (callback && code) {
            callback(code);
        }
    } withContainer:container];
}

- (id<HTNavigationProtocol>)navigator
{
    id<HTNavigationProtocol> navigator = [HTHandlerFactory handlerForProtocol:@protocol(HTNavigationProtocol)];
    
    return navigator;
}



@synthesize htInstance;

@end


