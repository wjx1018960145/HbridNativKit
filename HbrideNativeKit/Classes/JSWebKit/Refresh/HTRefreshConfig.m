//
//  HTRefreshConfig.m
//  HybridForiOS
//
//  Created by wjx on 2020/4/10.
//  Copyright © 2020 WJX. All rights reserved.
//

#import "HTRefreshConfig.h"

@implementation HTRefreshConfig

static HTRefreshConfig *ht_RefreshConfig = nil;

+ (instancetype)defaultConfig {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ht_RefreshConfig = [[self alloc] init];
    });
    return ht_RefreshConfig;
}
@end
