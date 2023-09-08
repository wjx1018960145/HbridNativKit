//
//  UIScrollView+HTExtension.h
//  HybridForiOS
//
//  Created by wjx on 2020/4/10.
//  Copyright © 2020 WJX. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (HTExtension)
@property (readonly, nonatomic) UIEdgeInsets ht_inset;

@property (assign, nonatomic) CGFloat ht_insetT;
@property (assign, nonatomic) CGFloat ht_insetB;
@property (assign, nonatomic) CGFloat ht_insetL;
@property (assign, nonatomic) CGFloat ht_insetR;

@property (assign, nonatomic) CGFloat ht_offsetX;
@property (assign, nonatomic) CGFloat ht_offsetY;

@property (assign, nonatomic) CGFloat ht_contentW;
@property (assign, nonatomic) CGFloat ht_contentH;
@end

NS_ASSUME_NONNULL_END
