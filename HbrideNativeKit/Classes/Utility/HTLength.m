//
//  HTLength.m
//  HybridForiOS
//
//  Created by wjx on 2020/3/12.
//  Copyright © 2020 WJX. All rights reserved.
//

#import "HTLength.h"
#import "HTAssert.h"
@implementation HTLength
{
    float _floatValue;
    int _intValue;
    HTLengthType _type;
    BOOL _isFloat;
}

+ (instancetype)lengthWithFloat:(float)value type:(HTLengthType)type
{
    HTLength *length = [HTLength new];
    length->_floatValue = value;
    length->_type = type;
    length->_isFloat = YES;
    return length;
}

+ (instancetype)lengthWithInt:(int)value type:(HTLengthType)type
{
    HTLength *length = [HTLength new];
    length->_intValue = value;
    length->_type = type;
    length->_isFloat = NO;
    return length;
}

- (float)valueForMaximum:(float)maximumValue
{
    
    switch (_type) {
        case HTLengthTypeFixed:
            return _isFloat ? _floatValue : _intValue;
        case HTLengthTypePercent:
            return maximumValue * (_isFloat ? _floatValue : _intValue) / 100.0;
        case HTLengthTypeAuto:
            return maximumValue;
        default:
            HTAssertNotReached();
            return 0;
    }
}

- (int)intValue
{
    HTAssert(!_isFloat, @"call `intValue` for non-int length");
    return _intValue;
}

- (float)floatValue
{
    HTAssert(_isFloat,  @"call `floatValue` for non-float length");
    return _floatValue;
}

- (BOOL)isEqualToLength:(HTLength *)length
{
    return length && _type == length->_type && _isFloat == length->_isFloat
    && _floatValue == length->_floatValue && _intValue == length->_intValue;
}

- (BOOL)isFixed
{
    return _type == HTLengthTypeFixed;
}

- (BOOL)isPercent
{
    return _type == HTLengthTypePercent;
}

- (BOOL)isAuto
{
    return _type == HTLengthTypeAuto;
}

- (BOOL)isNormal
{
    return _type == HTLengthTypeNormal;
}

@end
