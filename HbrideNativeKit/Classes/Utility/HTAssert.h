//
//  HTAssert.h
//  HybridForiOS
//
//  Created by wjx on 2020/3/3.
//  Copyright © 2020 WJX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTDefine.h"

void HTAssertInternal(NSString *func, NSString *file, int lineNum, NSString *format, ...);

#if DEBUG
#define HTAssert(condition, ...) \
do{\
    if(!(condition)){\
        HTAssertInternal(@(__func__), @(__FILE__), __LINE__, __VA_ARGS__);\
    }\
}while(0)
#else
#define HTAssert(condition, ...)
#endif

/**
 *  @abstract macro for asserting that a parameter is required.
 */
#define HTAssertParam(name) HTAssert(name, \
@"the parameter '%s' is required", #name)

/**
 *  @abstract macro for asserting if the handler conforms to the protocol
 */
#define HTAssertProtocol(handler, protocol) HTAssert([handler conformsToProtocol:protocol], \
@"handler:%@ does not conform to protocol:%@", handler, protocol)

/**
 *  @abstract macro for asserting that the object is kind of special class.
 */
#define HTAssertClass(name,className) HTAssert([name isKindOfClass:[className class]], \
@"the variable '%s' is not a kind of '%s' class", #name,#className)

/**
 *  @abstract macro for asserting that we are running on the main thread.
 */
#define HTAssertMainThread() HTAssert([NSThread isMainThread], \
@"must be called on the main thread")





#define HTAssertNotReached() \
HTAssert(NO, @"should never be reached")
