//
//  HTWebAppearance.m
//  HybridForiOS
//
//  Created by wjx on 2020/3/3.
//  Copyright © 2020 WJX. All rights reserved.
//

#import "HTWebAppearance.h"
#import "UIImage+Resource.h"
#import "NSBundle+Resource.h"
@implementation HTWebAppearance
//单例
+(instancetype)sharedAppearance {
    static HTWebAppearance *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[HTWebAppearance alloc] init];
    });
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.progressColor = [UIColor grayColor];
        self.closeItemImage = [UIImage imageFromBundle:[NSBundle bundleName:@"JSWebKit/Resourses"] imageName:@"webKitClose"];
        self.backItemImage = [UIImage imageFromBundle:[NSBundle bundleName:@"JSWebKit/Resourses"] imageName:@"webKitNaviBack"];
         self.rootCloseItemImage = [UIImage imageFromBundle:[NSBundle bundleName:@"JSWebKit/Resourses"] imageName:@"rootback"];
    }
    return self;
}

@end
