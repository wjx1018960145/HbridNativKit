//
//  HTSDKEngine.h
//  HybridForiOS
//
//  Created by wjx on 2020/3/3.
//  Copyright © 2020 WJX. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTSDKEngine : NSObject

/**
*  @abstract Register default modules/components/handlers, they will be registered only once.
**/
+ (void)registerDefaults;



+ (void)registerModule:(NSString *)name withClass:(Class)clazz;

/**
 *  @abstract Register a module for a given name
 *
 *  @param name The module name to register
 *
 *  @param clazzs  The module class to register
 *
 **/
+ (void)registerModule:(NSString *)name className:(NSString*)className withClasss:(NSArray*)clazzs;

/**
 * @abstract Registers a component for a given name
 *
 * @param name The component name to register
 *
 * @param clazz The WXComponent subclass to register
 *
 **/
+ (void)registerComponent:(NSString *)name withClass:(Class)clazz;
/**
 * @abstract Registers a extendCallNative Class for a given name
 *
 * @param name The extendCallNative name to register
 *
 * @param clazz The extendCallNative subclass to register
 *
 **/
+ (void)registerExtendCallNative:(NSString *)name withClass:(Class)clazz;

/**
 * @abstract Registers a component for a given name and specific properties
 *
 * @param name The component name to register
 *
 * @param clazz The WXComponent subclass to register
 *
 * @param properties properties to apply to the component
 *
 */
+ (void)registerComponent:(NSString *)name withClass:(Class)clazz withProperties:(NSDictionary * _Nullable)properties;

/**
 * @abstract Registers a component for a given name, options and js code
 *
 * @param name The service name to register
 *
 * @param options The service options to register
 *
 * @param serviceScript service js code to invoke
 *
 */
+ (void)registerService:(NSString *)name withScript:(NSString *)serviceScript withOptions:(NSDictionary * _Nullable)options;

/**
 * @abstract Registers a handler for a given handler instance and specific protocol
 *
 * @param handler The handler instance to register
 *
 * @param protocol The protocol to confirm
 *
 */
+ (void)registerHandler:(id)handler withProtocol:(Protocol *)protocol;

/**
 * @abstract Returns the version of SDK
 *
 **/
+ (NSString*)SDKEngineVersion;
/**
 * @abstract Initializes the global sdk environment
 *
 * @discussion Injects main.js in app bundle as default JSFramework script.
 *
 **/
+ (void)initSDKEnvironment;

@end

NS_ASSUME_NONNULL_END
