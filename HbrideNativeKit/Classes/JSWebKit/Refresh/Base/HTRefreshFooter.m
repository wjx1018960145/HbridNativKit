//
//  HTRefreshFooter.m
//  HybridForiOS
//
//  Created by wjx on 2020/4/10.
//  Copyright © 2020 WJX. All rights reserved.
//

#import "HTRefreshFooter.h"
#include "UIScrollView+HTRefresh.h"

@interface HTRefreshFooter()

@end
@implementation HTRefreshFooter

#pragma mark - 构造方法
+ (instancetype)footerWithRefreshingBlock:(HTRefreshComponentAction)refreshingBlock
{
    HTRefreshFooter *cmp = [[self alloc] init];
    cmp.refreshingBlock = refreshingBlock;
    return cmp;
}
+ (instancetype)footerWithRefreshingTarget:(id)target refreshingAction:(SEL)action
{
    HTRefreshFooter *cmp = [[self alloc] init];
    [cmp setRefreshingTarget:target refreshingAction:action];
    return cmp;
}

#pragma mark - 重写父类的方法
- (void)prepare
{
    [super prepare];
    
    // 设置自己的高度
    self.ht_h = HTRefreshFooterHeight;
    
    // 默认不会自动隐藏
//    self.automaticallyHidden = NO;
}

#pragma mark - 公共方法
- (void)endRefreshingWithNoMoreData
{
    HTRefreshDispatchAsyncOnMainQueue(self.state = HTRefreshStateNoMoreData;)
}

- (void)noticeNoMoreData
{
    [self endRefreshingWithNoMoreData];
}

- (void)resetNoMoreData
{
    HTRefreshDispatchAsyncOnMainQueue(self.state = HTRefreshStateIdle;)
}

- (void)setAutomaticallyHidden:(BOOL)automaticallyHidden
{
    _automaticallyHidden = automaticallyHidden;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
