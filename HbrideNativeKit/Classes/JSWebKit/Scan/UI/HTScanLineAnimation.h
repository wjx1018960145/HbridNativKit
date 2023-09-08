//
//  HTScanLineAnimation.h
//  HybridForiOS
//
//  Created by wjx on 2020/3/25.
//  Copyright © 2020 WJX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface HTScanLineAnimation : UIImageView



/**
 *  开始扫码线动画
 *
 *  @param animationRect 显示在parentView中得区域
 *  @param parentView    动画显示在UIView
 *  @param image     扫码线的图像
 */
- (void)startAnimatingWithRect:(CGRect)animationRect InView:(UIView*)parentView Image:(UIImage*)image;

/**
 *  停止动画
 */
- (void)stopAnimating;

@end

NS_ASSUME_NONNULL_END
