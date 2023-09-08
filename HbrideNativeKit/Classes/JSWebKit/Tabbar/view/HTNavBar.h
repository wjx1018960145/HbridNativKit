//
//  HTNavBar.h
//  HybridForiOS
//
//  Created by wjx on 2020/5/18.
//  Copyright © 2020 WJX. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTNavBar : UINavigationBar
/**
 *  设置全局的导航栏背景图片
 *
 *  @param globalImg 全局导航栏背景图片
 */
+ (void)setGlobalBackGroundImage: (UIImage *)globalImg;
/**
 * 设置全局导航栏颜色
 *
 */
+ (void)setGlobalBarTintColor:(UIColor *)barColor;
/**
 *  设置全局导航栏标题颜色, 和文字大小
 *
 *  @param globalTextColor 全局导航栏标题颜色
 *  @param fontSize        全局导航栏文字大小
 */
+ (void)setGlobalTextColor: (UIColor *)globalTextColor andFontSize: (CGFloat)fontSize;
@end

NS_ASSUME_NONNULL_END
