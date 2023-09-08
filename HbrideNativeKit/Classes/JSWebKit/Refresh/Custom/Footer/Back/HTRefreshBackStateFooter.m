//
//  HTRefreshBackStateFooter.m
//  HybridForiOS
//
//  Created by wjx on 2020/4/10.
//  Copyright © 2020 WJX. All rights reserved.
//

#import "HTRefreshBackStateFooter.h"
@interface HTRefreshBackStateFooter()
{
    /** 显示刷新状态的label */
    __unsafe_unretained UILabel *_stateLabel;
}
/** 所有状态对应的文字 */
@property (strong, nonatomic) NSMutableDictionary *stateTitles;
@end
@implementation HTRefreshBackStateFooter
#pragma mark - 懒加载
- (NSMutableDictionary *)stateTitles
{
    if (!_stateTitles) {
        self.stateTitles = [NSMutableDictionary dictionary];
    }
    return _stateTitles;
}

- (UILabel *)stateLabel
{
    if (!_stateLabel) {
        [self addSubview:_stateLabel = [UILabel ht_label]];
    }
    return _stateLabel;
}

#pragma mark - 公共方法
- (void)setTitle:(NSString *)title forState:(HTRefreshState)state
{
    if (title == nil) return;
    self.stateTitles[@(state)] = title;
    self.stateLabel.text = self.stateTitles[@(self.state)];
}

- (NSString *)titleForState:(HTRefreshState)state {
  return self.stateTitles[@(state)];
}

#pragma mark - 重写父类的方法
- (void)prepare
{
    [super prepare];
    
    // 初始化间距
    self.labelLeftInset = HTRefreshLabelLeftInset;
    
    // 初始化文字
    [self setTitle:[NSBundle ht_localizedStringForKey:HTRefreshBackFooterIdleText] forState:HTRefreshStateIdle];
    [self setTitle:[NSBundle ht_localizedStringForKey:HTRefreshBackFooterPullingText] forState:HTRefreshStatePulling];
    [self setTitle:[NSBundle ht_localizedStringForKey:HTRefreshBackFooterRefreshingText] forState:HTRefreshStateRefreshing];
    [self setTitle:[NSBundle ht_localizedStringForKey:HTRefreshBackFooterNoMoreDataText] forState:HTRefreshStateNoMoreData];
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    if (self.stateLabel.constraints.count) return;
    
    // 状态标签
    self.stateLabel.frame = self.bounds;
}

- (void)setState:(HTRefreshState)state
{
    HTRefreshCheckState
    
    // 设置状态文字
    self.stateLabel.text = self.stateTitles[@(state)];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
