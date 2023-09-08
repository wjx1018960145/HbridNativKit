//
//  HTAppConfiguration.h
//  HybridForiOS
//
//  Created by wjx on 2020/3/10.
//  Copyright © 2020 WJX. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTAppConfiguration : NSObject
/**
 * @abstract Group or organization of your app, default value is nil.
 */
+ (NSString *)appGroup;
+ (void)setAppGroup:(NSString *) appGroup;

/**
 * @abstract Name of your app, default is value for CFBundleDisplayName in main bundle.
 */
+ (NSString *)appName;
+ (void)setAppName:(NSString *)appName;

/**
 * @abstract Version of your app, default is value for CFBundleShortVersionString in main bundle.
 */
+ (NSString *)appVersion;
+ (void)setAppVersion:(NSString *)appVersion;

/**
 * @abstract External user agent of your app, all requests sent by weex will set the user agent on header,  default value is nil.
 */
+ (NSString *)externalUserAgent;
+ (void)setExternalUserAgent:(NSString *)userAgent;

/**
 * @abstract JSFrameworkVersion
 */
+ (NSString *)JSFrameworkVersion;
+ (void)setJSFrameworkVersion:(NSString *)JSFrameworkVersion;

/**
 + * @abstract JSFrameworkLibSize
 + */
+ (NSUInteger)JSFrameworkLibSize;
+ (void)setJSFrameworkLibSize:(NSUInteger)JSFrameworkLibSize;

/*
 *  @abstract customizeProtocolClasses
 */
+ (NSArray*)customizeProtocolClasses;
+ (void)setCustomizeProtocolClasses:(NSArray*)customizeProtocolClasses;

@end

NS_ASSUME_NONNULL_END
