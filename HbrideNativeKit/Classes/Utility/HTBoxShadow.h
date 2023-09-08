//
//  HTBoxShadow.h
//  HybridForiOS
//
//  Created by wjx on 2020/3/12.
//  Copyright © 2020 WJX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTInnerLayer.h"
NS_ASSUME_NONNULL_BEGIN

@interface HTBoxShadow : NSObject

@property(nonatomic,strong,nullable) UIColor *shadowColor;
@property CGSize shadowOffset;
@property CGFloat shadowRadius;
@property BOOL isInset;
@property (nonatomic, strong, nullable)HTInnerLayer *innerLayer;
@property CGFloat shadowOpacity;

/**
 *  @abstract get boxshadow from string and adapter phone screen
 *
 *  @param string the boxshadow string
 *
 *  @param scaleFactor the boxshadow set last time
 *
 *  @return A WXBoxShadow object
 */
+(HTBoxShadow *_Nullable)getBoxShadowFromString:(NSString *_Nullable)string scaleFactor:(CGFloat)scaleFactor;
@end

NS_ASSUME_NONNULL_END
