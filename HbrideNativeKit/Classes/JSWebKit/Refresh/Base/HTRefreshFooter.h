//
//  HTRefreshFooter.h
//  HybridForiOS
//
//  Created by wjx on 2020/4/10.
//  Copyright © 2020 WJX. All rights reserved.
//

#import "HTRefreshComponent.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTRefreshFooter : HTRefreshComponent
/** 创建footer */
+ (instancetype)footerWithRefreshingBlock:(HTRefreshComponentAction)refreshingBlock;
/** 创建footer */
+ (instancetype)footerWithRefreshingTarget:(id)target refreshingAction:(SEL)action;

/** 提示没有更多的数据 */
- (void)endRefreshingWithNoMoreData;
- (void)noticeNoMoreData HTRefreshDeprecated("使用endRefreshingWithNoMoreData");

/** 重置没有更多的数据（消除没有更多数据的状态） */
- (void)resetNoMoreData;

/** 忽略多少scrollView的contentInset的bottom */
@property (assign, nonatomic) CGFloat ignoredScrollViewContentInsetBottom;

/** 自动根据有无数据来显示和隐藏（有数据就显示，没有数据隐藏。默认是NO） */
@property (assign, nonatomic, getter=isAutomaticallyHidden) BOOL automaticallyHidden HTRefreshDeprecated("已废弃此属性，开发者请自行控制footer的显示和隐藏");

@end

NS_ASSUME_NONNULL_END
