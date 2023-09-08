//
//  NSURLProtocol+WebKitSupport.h
//  HybridForiOS
//
//  Created by wjx on 2020/3/18.
//  Copyright © 2020 WJX. All rights reserved.
//




#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURLProtocol (WebKitSupport)
+ (void)wk_registerScheme:(NSString*)scheme;

+ (void)wk_unregisterScheme:(NSString*)scheme;
@end

NS_ASSUME_NONNULL_END
