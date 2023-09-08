//
//  HTTabBar.h
//  HybridForiOS
//
//  Created by wjx on 2020/5/18.
//  Copyright © 2020 WJX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTCenterButton.h"
@class HTButton;
@class HTTabBar;
NS_ASSUME_NONNULL_BEGIN
@protocol HTTabBarDelegate <NSObject>
@optional
/*! 中间按钮点击会通过这个代理通知你通知 */
- (void)tabbar:(HTTabBar *)tabbar clickForCenterButton:(HTCenterButton *)centerButton;
/*! 默认返回YES，允许所有的切换，不过你通过TabBarController来直接设置SelectIndex来切换的是不会收到通知的。 */
- (BOOL)tabBar:(HTTabBar *)tabBar willSelectIndex:(NSInteger)index;
/*! 通知已经选择的控制器下标。 */
- (void)tabBar:(HTTabBar *)tabBar didSelectIndex:(NSInteger)index;
@end

@interface HTTabBar : UIView
/** tabbar按钮显示信息 */
@property(copy, nonatomic) NSArray<UITabBarItem *> *items;
/** 其他按钮 */
@property (strong , nonatomic) NSMutableArray <HTButton*>*btnArr;
/** 中间按钮 */
@property (strong , nonatomic) HTCenterButton *centerBtn;
/** 委托 */
@property(weak , nonatomic) id<HTTabBarDelegate>delegate;
/** 中间按钮点击回调*/
@property (nonatomic, copy) void(^centerBtnClickBlock)();
@end

NS_ASSUME_NONNULL_END
