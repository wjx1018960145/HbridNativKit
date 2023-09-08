//
//  HTConvert.h
//  HybridForiOS
//
//  Created by wjx on 2020/3/12.
//  Copyright © 2020 WJX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "HTType.h"
#import "HTLength.h"
#import "HTBoxShadow.h"
NS_ASSUME_NONNULL_BEGIN

@interface HTConvert : NSObject

+ (BOOL)BOOL:(id)value;

/**
 *  @abstract       convert value to CGFloat value
 *  @param value    value
 *  @return         CGFloat value
 */
+ (CGFloat)CGFloat:(id)value;

/**
 *  @abstract       convert value to CGFloat value, notice that it will return nan if input value is unsupported
 *  @param value    value
 *  @return         CGFloat value or nan(unsupported input)
 */
+ (CGFloat)flexCGFloat:(id)value;

+ (NSUInteger)NSUInteger:(id)value;
+ (NSInteger)NSInteger:(id)value;
+ (NSString *)NSString:(id)value;

/**
 *  750px Adaptive
 */
typedef CGFloat HTPixelType;
// @parameter scaleFactor: please use weexInstance's pixelScaleFactor property
+ (HTPixelType)HTPixelType:(id)value scaleFactor:(CGFloat)scaleFactor;
// WXPixelType that use flexCGFloat to convert
+ (HTPixelType)HTFlexPixelType:(id)value scaleFactor:(CGFloat)scaleFactor;


+ (UIViewContentMode)UIViewContentMode:(id)value;
+ (HTImageQuality)HTImageQuality:(id)value;
+ (HTImageSharp)HTImageSharp:(id)value;
+ (UIAccessibilityTraits)HTUIAccessibilityTraits:(id)value;

+ (UIColor *)UIColor:(id)value;
+ (CGColorRef)CGColor:(id)value;
+ (NSString *)HexWithColor:(UIColor *)color;
+ (HTBorderStyle)HTBorderStyle:(id)value;
typedef BOOL HTClipType;
+ (HTClipType)HTClipType:(id)value;
+ (HTPositionType)HTPositionType:(id)value;

+ (HTTextStyle)HTTextStyle:(id)value;
/**
 * @abstract UIFontWeightRegular ,UIFontWeightBold,etc are not support by the system which is less than 8.2. weex sdk set the float value.
 *
 * @param value support normal,blod,100,200,300,400,500,600,700,800,900
 *
 * @return A float value.
 *
 */
+ (CGFloat)HTTextWeight:(id)value;
+ (HTTextDecoration)HTTextDecoration:(id)value;
+ (NSTextAlignment)NSTextAlignment:(id)value;
+ (UIReturnKeyType)UIReturnKeyType:(id)value;

+ (HTScrollDirection)HTScrollDirection:(id)value;
+ (UITableViewRowAnimation)UITableViewRowAnimation:(id)value;

+ (UIViewAnimationOptions)UIViewAnimationTimingFunction:(id)value;
+ (CAMediaTimingFunction *)CAMediaTimingFunction:(id)value;

+ (HTVisibility)HTVisibility:(id)value;

+ (HTGradientType)gradientType:(id)value;

+ (HTLength *)HTLength:(id)value isFloat:(BOOL)isFloat scaleFactor:(CGFloat)scaleFactor;
+ (HTBoxShadow *)HTBoxShadow:(id)value scaleFactor:(CGFloat)scaleFactor;

@end

@interface HTConvert (Deprecated)

+ (HTPixelType)HTPixelType:(id)value DEPRECATED_MSG_ATTRIBUTE("Use [WXConvert WXPixelType:scaleFactor:] instead");

@end
NS_ASSUME_NONNULL_END
