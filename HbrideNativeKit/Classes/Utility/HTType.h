//
//  HTType.h
//  HybridForiOS
//
//  Created by wjx on 2020/3/11.
//  Copyright © 2020 WJX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, HTLayoutDirection) {
    HTLayoutDirectionLTR,
    HTLayoutDirectionRTL,
    HTLayoutDirectionAuto,
};

typedef NS_ENUM(NSUInteger, HTComponentType) {
    HTComponentTypeCommon = 0,
    HTComponentTypeVirtual
};

typedef NS_ENUM(NSUInteger, HTScrollDirection) {
    HTScrollDirectionVertical,
    HTScrollDirectionHorizontal,
    HTScrollDirectionNone,
};

typedef NS_ENUM(NSUInteger, HTTextStyle) {
    HTTextStyleNormal = 0,
    HTTextStyleItalic
};

typedef NS_ENUM(NSInteger, HTTextDecoration) {
    HTTextDecorationNone = 0,
    HTTextDecorationUnderline,
    HTTextDecorationLineThrough
};

typedef NS_ENUM(NSInteger, HTImageQuality) {
    HTImageQualityOriginal = -1,
    HTImageQualityLow = 0,
    HTImageQualityNormal,
    HTImageQualityHigh,
    HTImageQualityNone,
};

typedef NS_ENUM(NSInteger, HTImageSharp) {
    HTImageSharpeningNone = 0,
    HTImageSharpening
};

typedef NS_ENUM(NSInteger, HTVisibility) {
    HTVisibilityShow = 0,
    HTVisibilityHidden
};

typedef NS_ENUM(NSInteger, HTBorderStyle) {
    HTBorderStyleNone = 0,
    HTBorderStyleDotted,
    HTBorderStyleDashed,
    HTBorderStyleSolid
};

typedef NS_ENUM(NSInteger, HTPositionType) {
    HTPositionTypeRelative = 0,
    HTPositionTypeAbsolute,
    HTPositionTypeSticky,
    HTPositionTypeFixed
};

typedef NS_ENUM(NSInteger, HTGradientType) {
    HTGradientTypeToTop = 0,
    HTGradientTypeToBottom,
    HTGradientTypeToLeft,
    HTGradientTypeToRight,
    HTGradientTypeToTopleft,
    HTGradientTypeToBottomright,
};

NS_ASSUME_NONNULL_END
