//
//  HTAnimationModule.m
//  HybridForiOS
//
//  Created by wjx on 2020/3/13.
//  Copyright © 2020 WJX. All rights reserved.
//

#import "HTAnimationModule.h"

@implementation HTAnimationModule


@synthesize htInstance;

- (BOOL)registerBridge:(nonnull WKWebViewJavascriptBridge *)bridge {
    
    return YES;
}

@end
