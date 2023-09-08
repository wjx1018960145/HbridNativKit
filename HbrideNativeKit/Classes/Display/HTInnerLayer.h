//
//  HTInnerLayer.h
//  HybridForiOS
//
//  Created by wjx on 2020/3/12.
//  Copyright © 2020 WJX. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface HTInnerLayer : CAGradientLayer

@property CGFloat boxShadowRadius;
@property (nonatomic,strong) UIColor *boxShadowColor;
@property CGSize boxShadowOffset;
@property CGFloat boxShadowOpacity;
@end

NS_ASSUME_NONNULL_END
