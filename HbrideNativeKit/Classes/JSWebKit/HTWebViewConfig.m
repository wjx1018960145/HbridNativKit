//
//  HTWebViewConfig.m
//  HybridForiOS
//
//  Created by wjx on 2020/3/3.
//  Copyright © 2020 WJX. All rights reserved.
//

#import "HTWebViewConfig.h"

@implementation HTWebViewConfig

+ (instancetype)sharedInstance {
    static HTWebViewConfig *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[HTWebViewConfig alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.enableWhiteList = NO;
        self.whiteList = [NSMutableArray array];
    }
    return self;
}
@end
