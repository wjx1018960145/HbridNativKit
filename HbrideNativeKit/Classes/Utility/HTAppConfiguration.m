//
//  HTAppConfiguration.m
//  HybridForiOS
//
//  Created by wjx on 2020/3/10.
//  Copyright © 2020 WJX. All rights reserved.
//

#import "HTAppConfiguration.h"


@interface HTAppConfiguration()
@property (nonatomic, strong) NSString * appGroup;
@property (nonatomic, strong) NSString * appName;
@property (nonatomic, strong) NSString * appVersion;
@property (nonatomic, strong) NSString * externalUA;
@property (nonatomic, strong) NSString * JSFrameworkVersion;
@property (nonatomic, assign) NSUInteger JSFrameworkLibSize;
@property (nonatomic, strong) NSArray  * customizeProtocolClasses;

@end

@implementation HTAppConfiguration

+ (instancetype)sharedConfiguration
{
    static id _sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

+ (NSString *)appGroup
{
    return [HTAppConfiguration sharedConfiguration].appGroup;
}

+ (void)setAppGroup:(NSString *)appGroup
{
    [HTAppConfiguration sharedConfiguration].appGroup = appGroup;
}

+ (NSString *)appName
{
    return [HTAppConfiguration sharedConfiguration].appName ?: [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
}

+ (void)setAppName:(NSString *)appName
{
    [HTAppConfiguration sharedConfiguration].appName = appName;
}

+ (NSString *)appVersion
{
    return [HTAppConfiguration sharedConfiguration].appVersion ?: [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

+ (void)setAppVersion:(NSString *)appVersion
{
    [HTAppConfiguration sharedConfiguration].appVersion = appVersion;
}

+ (NSString *)externalUserAgent
{
    return [HTAppConfiguration sharedConfiguration].externalUA;
}

+ (void)setExternalUserAgent:(NSString *)userAgent
{
    [HTAppConfiguration sharedConfiguration].externalUA = userAgent;
}

+ (NSString *)JSFrameworkVersion
{
    return [HTAppConfiguration sharedConfiguration].JSFrameworkVersion ?: @"";
}

+ (void)setJSFrameworkVersion:(NSString *)JSFrameworkVersion
{
    [HTAppConfiguration sharedConfiguration].JSFrameworkVersion = JSFrameworkVersion;
}

+ (NSUInteger)JSFrameworkLibSize
{
    return [HTAppConfiguration sharedConfiguration].JSFrameworkLibSize;
}

+ (void)setJSFrameworkLibSize:(NSUInteger)JSFrameworkLibSize
{
    [HTAppConfiguration sharedConfiguration].JSFrameworkLibSize = JSFrameworkLibSize;
}

+ (NSArray*)customizeProtocolClasses{
    return [HTAppConfiguration sharedConfiguration].customizeProtocolClasses;
}

+ (void)setCustomizeProtocolClasses:(NSArray *)customizeProtocolClasses{
    [HTAppConfiguration sharedConfiguration].customizeProtocolClasses = customizeProtocolClasses;
}


@end
