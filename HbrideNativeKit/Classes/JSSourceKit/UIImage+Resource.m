//
//  UIImage+Resource.m
//  HybridForiOS
//
//  Created by wjx on 2020/3/2.
//  Copyright © 2020 WJX. All rights reserved.
//

#import "UIImage+Resource.h"

@implementation UIImage (Resource)

+ (UIImage *)imageFromBundle:(NSBundle *)bundle imageName:(NSString *)name {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    return [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
#elif __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
    return [UIImage imageWithContentsOfFile:[bundle pathForResource:name ofType:@"png"]];
#else
    if ([UIImage respondsToSelector:@selector(imageNamed:inBundle:compatibleWithTraitCollection:)]) {
        if (@available(iOS 8.0, *)) {
            return [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
        } else {
            // Fallback on earlier versions
            return  nil;
        }
    } else {
        return [UIImage imageWithContentsOfFile:[bundle pathForResource:name ofType:@"png"]];
    }
#endif
}
@end
