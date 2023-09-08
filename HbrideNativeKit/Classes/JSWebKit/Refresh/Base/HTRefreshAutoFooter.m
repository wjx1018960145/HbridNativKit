//
//  HTRefreshAutoFooter.m
//  HybridForiOS
//
//  Created by wjx on 2020/4/10.
//  Copyright © 2020 WJX. All rights reserved.
//

#import "HTRefreshAutoFooter.h"
@interface HTRefreshAutoFooter()
/** 一个新的拖拽 */
@property (nonatomic) BOOL triggerByDrag;
@property (nonatomic) NSInteger leftTriggerTimes;
@end
@implementation HTRefreshAutoFooter

#pragma mark - 初始化
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    if (newSuperview) { // 新的父控件
        if (self.hidden == NO) {
            self.scrollView.ht_insetB += self.ht_h;
        }
        
        // 设置位置
        self.ht_y = _scrollView.ht_contentH;
    } else { // 被移除了
        if (self.hidden == NO) {
            self.scrollView.ht_insetB -= self.ht_h;
        }
    }
}

#pragma mark - 过期方法
- (void)setAppearencePercentTriggerAutoRefresh:(CGFloat)appearencePercentTriggerAutoRefresh
{
    self.triggerAutomaticallyRefreshPercent = appearencePercentTriggerAutoRefresh;
}

- (CGFloat)appearencePercentTriggerAutoRefresh
{
    return self.triggerAutomaticallyRefreshPercent;
}

#pragma mark - 实现父类的方法
- (void)prepare
{
    [super prepare];
    
    // 默认底部控件100%出现时才会自动刷新
    self.triggerAutomaticallyRefreshPercent = 1.0;
    
    // 设置为默认状态
    self.automaticallyRefresh = YES;
    
    self.autoTriggerTimes = 1;
}

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
    // 设置位置
    self.ht_y = self.scrollView.ht_contentH + self.ignoredScrollViewContentInsetBottom;
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
    if (self.state != HTRefreshStateIdle || !self.automaticallyRefresh || self.ht_y == 0) return;
    
    if (_scrollView.ht_insetT + _scrollView.ht_contentH > _scrollView.ht_h) { // 内容超过一个屏幕
        // 这里的_scrollView.mj_contentH替换掉self.mj_y更为合理
        if (_scrollView.ht_offsetY >= _scrollView.ht_contentH - _scrollView.ht_h + self.ht_h * self.triggerAutomaticallyRefreshPercent + _scrollView.ht_insetB - self.ht_h) {
            // 防止手松开时连续调用
            CGPoint old = [change[@"old"] CGPointValue];
            CGPoint new = [change[@"new"] CGPointValue];
            if (new.y <= old.y) return;
            
            if (_scrollView.isDragging) {
                self.triggerByDrag = YES;
            }
            // 当底部刷新控件完全出现时，才刷新
            [self beginRefreshing];
        }
    }
}

- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    
    if (self.state != HTRefreshStateIdle) return;
    
    UIGestureRecognizerState panState = _scrollView.panGestureRecognizer.state;
    
    switch (panState) {
        // 手松开
        case UIGestureRecognizerStateEnded: {
            if (_scrollView.ht_insetT + _scrollView.ht_contentH <= _scrollView.ht_h) {  // 不够一个屏幕
                if (_scrollView.ht_offsetY >= - _scrollView.ht_insetT) { // 向上拽
                    self.triggerByDrag = YES;
                    [self beginRefreshing];
                }
            } else { // 超出一个屏幕
                if (_scrollView.ht_offsetY >= _scrollView.ht_contentH + _scrollView.ht_insetB - _scrollView.ht_h) {
                    self.triggerByDrag = YES;
                    [self beginRefreshing];
                }
            }
        }
            break;
            
        case UIGestureRecognizerStateBegan: {
            [self resetTriggerTimes];
        }
            break;
            
        default:
            break;
    }
}

- (BOOL)unlimitedTrigger {
    return self.leftTriggerTimes == -1;
}

- (void)beginRefreshing
{
    if (self.triggerByDrag && self.leftTriggerTimes <= 0 && !self.unlimitedTrigger) {
        return;
    }
    
    [super beginRefreshing];
}

- (void)setState:(HTRefreshState)state
{
    HTRefreshCheckState
    
    if (state == HTRefreshStateRefreshing) {
        [self executeRefreshingCallback];
    } else if (state == HTRefreshStateNoMoreData || state == HTRefreshStateIdle) {
        if (self.triggerByDrag) {
            if (!self.unlimitedTrigger) {
                self.leftTriggerTimes -= 1;
            }
            self.triggerByDrag = NO;
        }
        
        if (HTRefreshStateRefreshing == oldState) {
            if (self.scrollView.pagingEnabled) {
                CGPoint offset = self.scrollView.contentOffset;
                offset.y -= self.scrollView.ht_insetB;
                [UIView animateWithDuration:HTRefreshSlowAnimationDuration animations:^{
                    self.scrollView.contentOffset = offset;
                    
                    if (self.endRefreshingAnimationBeginAction) {
                        self.endRefreshingAnimationBeginAction();
                    }
                } completion:^(BOOL finished) {
                    if (self.endRefreshingCompletionBlock) {
                        self.endRefreshingCompletionBlock();
                    }
                }];
                return;
            }
            
            if (self.endRefreshingCompletionBlock) {
                self.endRefreshingCompletionBlock();
            }
        }
    }
}

- (void)resetTriggerTimes {
    self.leftTriggerTimes = self.autoTriggerTimes;
}

- (void)setHidden:(BOOL)hidden
{
    BOOL lastHidden = self.isHidden;
    
    [super setHidden:hidden];
    
    if (!lastHidden && hidden) {
        self.state = HTRefreshStateIdle;
        
        self.scrollView.ht_insetB -= self.ht_h;
    } else if (lastHidden && !hidden) {
        self.scrollView.ht_insetB += self.ht_h;
        
        // 设置位置
        self.ht_y = _scrollView.ht_contentH;
    }
}

- (void)setAutoTriggerTimes:(NSInteger)autoTriggerTimes {
    _autoTriggerTimes = autoTriggerTimes;
    self.leftTriggerTimes = autoTriggerTimes;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
