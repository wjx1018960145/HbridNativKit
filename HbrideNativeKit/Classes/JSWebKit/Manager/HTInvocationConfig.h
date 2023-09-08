//
//  HTInvocationConfig.h
//  HybridForiOS
//
//  Created by wjx on 2020/3/4.
//  Copyright © 2020 WJX. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTInvocationConfig : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *clazz;
/**
 *  The methods map
 **/
@property (nonatomic, strong) NSMutableDictionary *asyncMethods;
@property (nonatomic, strong) NSMutableDictionary *syncMethods;

- (instancetype)initWithName:(NSString *)name class:(NSString *)clazz;
- (void)registerMethods;

@end

NS_ASSUME_NONNULL_END
