//
//  HTLength.h
//  HybridForiOS
//
//  Created by wjx on 2020/3/12.
//  Copyright © 2020 WJX. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    HTLengthTypeFixed,
    HTLengthTypePercent,
    HTLengthTypeAuto,
    HTLengthTypeNormal
} HTLengthType;

@interface HTLength : NSObject
+ (instancetype)lengthWithFloat:(float)value type:(HTLengthType)type;

+ (instancetype)lengthWithInt:(int)value type:(HTLengthType)type;

- (float)valueForMaximum:(float)maximumValue;

- (int)intValue;

- (float)floatValue;

- (BOOL)isEqualToLength:(HTLength *)length;

- (BOOL)isFixed;

- (BOOL)isPercent;

- (BOOL)isAuto;

- (BOOL)isNormal;
@end

NS_ASSUME_NONNULL_END
