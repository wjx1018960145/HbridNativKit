//
//  HTWebAppearance.h
//  HybridForiOS
//
//  Created by wjx on 2020/3/3.
//  Copyright © 2020 WJX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface HTWebAppearance : NSObject
+ (instancetype)sharedAppearance;

// 导航栏返回按钮的图片
@property (nonatomic) UIImage *backItemImage;
// 关闭按钮的图片
@property (nonatomic) UIImage *closeItemImage;
// 网页访问进度条颜色
@property (nonatomic) UIColor *progressColor;
// 网页 MenuItem 的图标
@property (nonatomic) UIImage *menuItemImage;
//右侧返回根目录图标
@property (nonatomic) UIImage *rootCloseItemImage;
@end

NS_ASSUME_NONNULL_END
