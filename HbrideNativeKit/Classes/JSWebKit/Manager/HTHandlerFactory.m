//
//  HTHandlerFactory.m
//  HybridForiOS
//
//  Created by wjx on 2020/3/9.
//  Copyright © 2020 WJX. All rights reserved.
//

#import "HTHandlerFactory.h"
#import "HTThreadSafeMutableDictionary.h"
#import "HTAssert.h"
@interface HTHandlerFactory()
@property (nonatomic, strong) HTThreadSafeMutableDictionary *handlers;

@end


@implementation HTHandlerFactory
+(instancetype)sharedInstance{
    static HTHandlerFactory *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
         _sharedInstance.handlers = [[HTThreadSafeMutableDictionary alloc] init];
    });
    return _sharedInstance;
}
+ (void)registerHandler:(id)handler withProtocol:(Protocol *)protocol
{
    HTAssert(handler && protocol, @"Handler or protocol for registering can not be nil.");
//    WXAssertProtocol(handler, protocol);
        
    [[HTHandlerFactory sharedInstance].handlers setObject:handler forKey:NSStringFromProtocol(protocol)];
}
+ (id)handlerForProtocol:(Protocol *)protocol
{
    HTAssert(protocol, @"Can not find handler for a nil protocol");
    
    id handler = [[HTHandlerFactory sharedInstance].handlers objectForKey:NSStringFromProtocol(protocol)];
    return handler;
}

+ (NSDictionary *)handlerConfigs {
    return [HTHandlerFactory sharedInstance].handlers;
}
@end
