//
//  HTModuleFactory.h
//  HybridForiOS
//
//  Created by wjx on 2020/3/4.
//  Copyright © 2020 WJX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface HTModuleFactory : NSObject

// WebView 的ViewController
@property (nonatomic, weak) UIViewController *containerViewController;
/**
 * @abstract Returns the class of specific module
 *
 * @param name The module name
 *
 **/
+ (Class)classWithModuleName:(NSString *)name;

/**
 * @abstract Registers a module for a given name and the implemented class
 *
 * @param name The module name to register
 *
 * @param clazz The module class to register
 *
 **/
+ (NSString *)registerModule:(NSString *)name withClass:(Class)clazz;

/**
 * @abstract Returns the export methods in the specific module
 *
 * @param name The module name
 **/
+ (NSMutableDictionary *)moduleMethodMapsWithName:(NSString *)name;

/**
 * @abstract Returns the export Selector in the specific module
 *
 * @param name The Selector name
 **/
+ (NSMutableDictionary *)moduleSelectorMapsWithName:(NSString *)name;
/**
 * @abstract Returns the registered modules.
 */
+ (NSDictionary *) moduleConfigs;
@end

NS_ASSUME_NONNULL_END
