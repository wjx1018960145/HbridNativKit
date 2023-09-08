//
//  HTHandlerFactory.h
//  HybridForiOS
//
//  Created by wjx on 2020/3/9.
//  Copyright © 2020 WJX. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTHandlerFactory : NSObject

/**
 * @abstract Register a handler for a given handler instance and specific protocol
 *
 * @param handler The handler instance to register
 *
 * @param protocol The protocol to confirm
 *
 */
+ (void)registerHandler:(id)handler withProtocol:(Protocol *)protocol;

/**
 * @abstract Returns the handler for a given protocol
 *
 **/
+ (id)handlerForProtocol:(Protocol *)protocol;

/**
 * @abstract Returns the registered handlers.
 */
+ (NSDictionary *)handlerConfigs;
@end

NS_ASSUME_NONNULL_END
