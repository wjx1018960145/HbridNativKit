//
//  NSBundle+HTRefresh.m
//  HybridForiOS
//
//  Created by wjx on 2020/4/10.
//  Copyright © 2020 WJX. All rights reserved.
//

#import "NSBundle+HTRefresh.h"
#import "HTRefreshComponent.h"
#import "HTRefreshConfig.h"
@implementation NSBundle (HTRefresh)
+ (instancetype)ht_refreshBundle
{
    static NSBundle *refreshBundle = nil;
    if (refreshBundle == nil) {
        // 这里不使用mainBundle是为了适配pod 1.x和0.x
        NSString *bundlePath = [[NSBundle bundleForClass:[HTRefreshComponent class]].resourcePath
               stringByAppendingPathComponent:@"HTRefresh.bundle"];
               
        refreshBundle =[NSBundle bundleWithPath:bundlePath];
        //refreshBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[HTRefreshComponent class]] pathForResource:@"HTRefresh" ofType:@"bundle"]];
    }
    return refreshBundle;
}

+ (UIImage *)ht_arrowImage
{
    static UIImage *arrowImage = nil;
    if (arrowImage == nil) {
        arrowImage = [[UIImage imageWithContentsOfFile:[[self ht_refreshBundle] pathForResource:@"arrow@2x" ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    return arrowImage;
}

+ (NSString *)ht_localizedStringForKey:(NSString *)key
{
    return [self ht_localizedStringForKey:key value:nil];
}

+ (NSString *)ht_localizedStringForKey:(NSString *)key value:(NSString *)value
{
    static NSBundle *bundle = nil;
    if (bundle == nil) {
        NSString *language = HTRefreshConfig.defaultConfig.languageCode;
        // 如果配置中没有配置语言
        if (!language) {
            // （iOS获取的语言字符串比较不稳定）目前框架只处理en、zh-Hans、zh-Hant三种情况，其他按照系统默认处理
            language = [NSLocale preferredLanguages].firstObject;
        }
        
        if ([language hasPrefix:@"en"]) {
            language = @"en";
        } else if ([language hasPrefix:@"zh"]) {
            if ([language rangeOfString:@"Hans"].location != NSNotFound) {
                language = @"zh-Hans"; // 简体中文
            } else { // zh-Hant\zh-HK\zh-TW
                language = @"zh-Hant"; // 繁體中文
            }
        } else if ([language hasPrefix:@"ko"]) {
            language = @"ko";
        } else if ([language hasPrefix:@"ru"]) {
            language = @"ru";
        } else if ([language hasPrefix:@"uk"]) {
            language = @"uk";
        } else {
            language = @"en";
        }
        
        // 从MJRefresh.bundle中查找资源
        bundle = [NSBundle bundleWithPath:[[NSBundle ht_refreshBundle] pathForResource:language ofType:@"lproj"]];
    }
    value = [bundle localizedStringForKey:key value:value table:nil];
    return [[NSBundle mainBundle] localizedStringForKey:key value:value table:nil];
}
@end
