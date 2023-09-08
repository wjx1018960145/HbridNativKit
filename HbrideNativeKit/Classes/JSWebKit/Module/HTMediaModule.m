//
//  HTMediaModule.m
//  HybridForiOS
//
//  Created by wjx on 2020/3/25.
//  Copyright © 2020 WJX. All rights reserved.
//

#import "HTMediaModule.h"

@implementation HTMediaModule

@synthesize htInstance;

- (BOOL)registerBridge:(nonnull WKWebViewJavascriptBridge *)bridge {
    
    [bridge registerHandler:@"scan" handler:^(id  _Nullable data, HTJBResponseCallback  _Nullable responseCallback) {
        
        
    }];
    
    
    return YES;
}

@end
