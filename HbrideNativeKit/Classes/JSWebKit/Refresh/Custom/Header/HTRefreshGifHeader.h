//
//  HTRefreshGifHeader.h
//  HybridForiOS
//
//  Created by wjx on 2020/4/10.
//  Copyright © 2020 WJX. All rights reserved.
//

#import "HTRefreshStateHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTRefreshGifHeader : HTRefreshStateHeader
@property (weak, nonatomic, readonly) UIImageView *gifView;

/** 设置state状态下的动画图片images 动画持续时间duration*/
- (void)setImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(HTRefreshState)state;
- (void)setImages:(NSArray *)images forState:(HTRefreshState)state;
@end

NS_ASSUME_NONNULL_END
