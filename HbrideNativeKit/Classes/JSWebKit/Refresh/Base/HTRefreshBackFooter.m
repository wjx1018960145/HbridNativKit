//
//  HTRefreshBackFooter.m
//  HybridForiOS
//
//  Created by wjx on 2020/4/10.
//  Copyright © 2020 WJX. All rights reserved.
//

#import "HTRefreshBackFooter.h"
@interface HTRefreshBackFooter()
@property (assign, nonatomic) NSInteger lastRefreshCount;
@property (assign, nonatomic) CGFloat lastBottomDelta;
@end
@implementation HTRefreshBackFooter

#pragma mark - 初始化
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    [self scrollViewContentSizeDidChange:nil];
}

#pragma mark - 实现父类的方法
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
    // 如果正在刷新，直接返回
    if (self.state == HTRefreshStateRefreshing) return;
    
    _scrollViewOriginalInset = self.scrollView.ht_inset;
    
    // 当前的contentOffset
    CGFloat currentOffsetY = self.scrollView.ht_offsetY;
    // 尾部控件刚好出现的offsetY
    CGFloat happenOffsetY = [self happenOffsetY];
    // 如果是向下滚动到看不见尾部控件，直接返回
    if (currentOffsetY <= happenOffsetY) return;
    
    CGFloat pullingPercent = (currentOffsetY - happenOffsetY) / self.ht_h;
    
    // 如果已全部加载，仅设置pullingPercent，然后返回
    if (self.state == HTRefreshStateNoMoreData) {
        self.pullingPercent = pullingPercent;
        return;
    }
    
    if (self.scrollView.isDragging) {
        self.pullingPercent = pullingPercent;
        // 普通 和 即将刷新 的临界点
        CGFloat normal2pullingOffsetY = happenOffsetY + self.ht_h;
        
        if (self.state == HTRefreshStateIdle && currentOffsetY > normal2pullingOffsetY) {
            // 转为即将刷新状态
            self.state = HTRefreshStatePulling;
        } else if (self.state == HTRefreshStatePulling && currentOffsetY <= normal2pullingOffsetY) {
            // 转为普通状态
            self.state = HTRefreshStateIdle;
        }
    } else if (self.state == HTRefreshStatePulling) {// 即将刷新 && 手松开
        // 开始刷新
        [self beginRefreshing];
    } else if (pullingPercent < 1) {
        self.pullingPercent = pullingPercent;
    }
}

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
    // 内容的高度
    CGFloat contentHeight = self.scrollView.ht_contentH + self.ignoredScrollViewContentInsetBottom;
    // 表格的高度
    CGFloat scrollHeight = self.scrollView.ht_h - self.scrollViewOriginalInset.top - self.scrollViewOriginalInset.bottom + self.ignoredScrollViewContentInsetBottom;
    // 设置位置和尺寸
    self.ht_y = MAX(contentHeight, scrollHeight);
}

- (void)setState:(HTRefreshState)state
{
    HTRefreshCheckState
    
    // 根据状态来设置属性
    if (state == HTRefreshStateNoMoreData || state == HTRefreshStateIdle) {
        // 刷新完毕
        if (HTRefreshStateRefreshing == oldState) {
            [UIView animateWithDuration:HTRefreshSlowAnimationDuration animations:^{
                if (self.endRefreshingAnimationBeginAction) {
                    self.endRefreshingAnimationBeginAction();
                }
                
                self.scrollView.ht_insetB -= self.lastBottomDelta;
                // 自动调整透明度
                if (self.isAutomaticallyChangeAlpha) self.alpha = 0.0;
            } completion:^(BOOL finished) {
                self.pullingPercent = 0.0;
                
                if (self.endRefreshingCompletionBlock) {
                    self.endRefreshingCompletionBlock();
                }
            }];
        }
        
        CGFloat deltaH = [self heightForContentBreakView];
        // 刚刷新完毕
        if (HTRefreshStateRefreshing == oldState && deltaH > 0 && self.scrollView.ht_totalDataCount != self.lastRefreshCount) {
            self.scrollView.ht_offsetY = self.scrollView.ht_offsetY;
        }
    } else if (state == HTRefreshStateRefreshing) {
        // 记录刷新前的数量
        self.lastRefreshCount = self.scrollView.ht_totalDataCount;
        
        [UIView animateWithDuration:HTRefreshFastAnimationDuration animations:^{
            CGFloat bottom = self.ht_h + self.scrollViewOriginalInset.bottom;
            CGFloat deltaH = [self heightForContentBreakView];
            if (deltaH < 0) { // 如果内容高度小于view的高度
                bottom -= deltaH;
            }
            self.lastBottomDelta = bottom - self.scrollView.ht_insetB;
            self.scrollView.ht_insetB = bottom;
            self.scrollView.ht_offsetY = [self happenOffsetY] + self.ht_h;
        } completion:^(BOOL finished) {
            [self executeRefreshingCallback];
        }];
    }
}
#pragma mark - 私有方法
#pragma mark 获得scrollView的内容 超出 view 的高度
- (CGFloat)heightForContentBreakView
{
    CGFloat h = self.scrollView.frame.size.height - self.scrollViewOriginalInset.bottom - self.scrollViewOriginalInset.top;
    return self.scrollView.contentSize.height - h;
}

#pragma mark 刚好看到上拉刷新控件时的contentOffset.y
- (CGFloat)happenOffsetY
{
    CGFloat deltaH = [self heightForContentBreakView];
    if (deltaH > 0) {
        return deltaH - self.scrollViewOriginalInset.top;
    } else {
        return - self.scrollViewOriginalInset.top;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
