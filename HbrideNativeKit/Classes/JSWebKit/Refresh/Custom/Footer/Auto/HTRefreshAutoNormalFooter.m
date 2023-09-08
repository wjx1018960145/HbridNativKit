//
//  HTRefreshAutoNormalFooter.m
//  HybridForiOS
//
//  Created by wjx on 2020/4/10.
//  Copyright © 2020 WJX. All rights reserved.
//

#import "HTRefreshAutoNormalFooter.h"
@interface HTRefreshAutoNormalFooter()
@property (weak, nonatomic) UIActivityIndicatorView *loadingView;
@end
@implementation HTRefreshAutoNormalFooter
#pragma mark - 懒加载子控件
- (UIActivityIndicatorView *)loadingView
{
    if (!_loadingView) {
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:_activityIndicatorViewStyle];
        loadingView.hidesWhenStopped = YES;
        [self addSubview:_loadingView = loadingView];
    }
    return _loadingView;
}

- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)activityIndicatorViewStyle
{
    _activityIndicatorViewStyle = activityIndicatorViewStyle;
    
    [self.loadingView removeFromSuperview];
    self.loadingView = nil;
    [self setNeedsLayout];
}
#pragma mark - 重写父类的方法
- (void)prepare
{
    [super prepare];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > 130000
    if (@available(iOS 13.0, *)) {
        _activityIndicatorViewStyle = UIActivityIndicatorViewStyleMedium;
        return;
    }
#endif
        
    _activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    if (self.loadingView.constraints.count) return;
    
    // 圈圈
    CGFloat loadingCenterX = self.ht_w * 0.5;
    if (!self.isRefreshingTitleHidden) {
        loadingCenterX -= self.stateLabel.ht_textWidth * 0.5 + self.labelLeftInset;
    }
    CGFloat loadingCenterY = self.ht_h * 0.5;
    self.loadingView.center = CGPointMake(loadingCenterX, loadingCenterY);
}

- (void)setState:(HTRefreshState)state
{
    HTRefreshCheckState
    
    // 根据状态做事情
    if (state == HTRefreshStateNoMoreData || state == HTRefreshStateIdle) {
        [self.loadingView stopAnimating];
    } else if (state == HTRefreshStateRefreshing) {
        [self.loadingView startAnimating];
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
