//
//  HTRefreshBackStateFooter.h
//  HybridForiOS
//
//  Created by wjx on 2020/4/10.
//  Copyright © 2020 WJX. All rights reserved.
//

#import "HTRefreshBackFooter.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTRefreshBackStateFooter : HTRefreshBackFooter
/** 文字距离圈圈、箭头的距离 */
@property (assign, nonatomic) CGFloat labelLeftInset;
/** 显示刷新状态的label */
@property (weak, nonatomic, readonly) UILabel *stateLabel;
/** 设置state状态下的文字 */
- (void)setTitle:(NSString *)title forState:(HTRefreshState)state;

/** 获取state状态下的title */
- (NSString *)titleForState:(HTRefreshState)state;

@end

NS_ASSUME_NONNULL_END
