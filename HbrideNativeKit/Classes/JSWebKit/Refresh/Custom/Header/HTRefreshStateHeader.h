//
//  HTRefreshStateHeader.h
//  HybridForiOS
//
//  Created by wjx on 2020/4/10.
//  Copyright © 2020 WJX. All rights reserved.
//

#import "HTRefreshHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTRefreshStateHeader : HTRefreshHeader
#pragma mark - 刷新时间相关
/** 利用这个block来决定显示的更新时间文字 */
@property (copy, nonatomic, nullable) NSString *(^lastUpdatedTimeText)(NSDate * _Nullable lastUpdatedTime);
/** 显示上一次刷新时间的label */
@property (weak, nonatomic, readonly) UILabel *lastUpdatedTimeLabel;

#pragma mark - 状态相关
/** 文字距离圈圈、箭头的距离 */
@property (assign, nonatomic) CGFloat labelLeftInset;
/** 显示刷新状态的label */
@property (weak, nonatomic, readonly) UILabel *stateLabel;
/** 设置state状态下的文字 */
- (void)setTitle:(NSString *)title forState:(HTRefreshState)state;
@end

NS_ASSUME_NONNULL_END
