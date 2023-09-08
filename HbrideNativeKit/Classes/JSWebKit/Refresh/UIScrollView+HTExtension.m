//
//  UIScrollView+HTExtension.m
//  HybridForiOS
//
//  Created by wjx on 2020/4/10.
//  Copyright © 2020 WJX. All rights reserved.
//

#import "UIScrollView+HTExtension.h"
#import <objc/runtime.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunguarded-availability-new"

@implementation UIScrollView (HTExtension)

static BOOL respondsToAdjustedContentInset_;

+ (void)initialize
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        respondsToAdjustedContentInset_ = [self instancesRespondToSelector:@selector(adjustedContentInset)];
    });
}

- (UIEdgeInsets)ht_inset
{
#ifdef __IPHONE_11_0
    if (respondsToAdjustedContentInset_) {
        return self.adjustedContentInset;
    }
#endif
    return self.contentInset;
}

- (void)setHt_insetT:(CGFloat)mj_insetT
{
    UIEdgeInsets inset = self.contentInset;
    inset.top = mj_insetT;
#ifdef __IPHONE_11_0
    if (respondsToAdjustedContentInset_) {
        inset.top -= (self.adjustedContentInset.top - self.contentInset.top);
    }
#endif
    self.contentInset = inset;
}

- (CGFloat)ht_insetT
{
    return self.ht_inset.top;
}

- (void)setHt_insetB:(CGFloat)mj_insetB
{
    UIEdgeInsets inset = self.contentInset;
    inset.bottom = mj_insetB;
#ifdef __IPHONE_11_0
    if (respondsToAdjustedContentInset_) {
        inset.bottom -= (self.adjustedContentInset.bottom - self.contentInset.bottom);
    }
#endif
    self.contentInset = inset;
}

- (CGFloat)ht_insetB
{
    return self.ht_inset.bottom;
}

- (void)setHt_insetL:(CGFloat)ht_insetL
{
    UIEdgeInsets inset = self.contentInset;
    inset.left = ht_insetL;
#ifdef __IPHONE_11_0
    if (respondsToAdjustedContentInset_) {
        inset.left -= (self.adjustedContentInset.left - self.contentInset.left);
    }
#endif
    self.contentInset = inset;
}

- (CGFloat)ht_insetL
{
    return self.ht_inset.left;
}

- (void)setHt_insetR:(CGFloat)ht_insetR
{
    UIEdgeInsets inset = self.contentInset;
    inset.right = ht_insetR;
#ifdef __IPHONE_11_0
    if (respondsToAdjustedContentInset_) {
        inset.right -= (self.adjustedContentInset.right - self.contentInset.right);
    }
#endif
    self.contentInset = inset;
}

- (CGFloat)ht_insetR
{
    return self.ht_inset.right;
}

- (void)setHt_offsetX:(CGFloat)ht_offsetX
{
    CGPoint offset = self.contentOffset;
    offset.x = ht_offsetX;
    self.contentOffset = offset;
}

- (CGFloat)ht_offsetX
{
    return self.contentOffset.x;
}

- (void)setHt_offsetY:(CGFloat)ht_offsetY
{
    CGPoint offset = self.contentOffset;
    offset.y = ht_offsetY;
    self.contentOffset = offset;
}

- (CGFloat)ht_offsetY
{
    return self.contentOffset.y;
}

- (void)setHt_contentW:(CGFloat)ht_contentW
{
    CGSize size = self.contentSize;
    size.width = ht_contentW;
    self.contentSize = size;
}

- (CGFloat)ht_contentW
{
    return self.contentSize.width;
}

- (void)setHt_contentH:(CGFloat)ht_contentH
{
    CGSize size = self.contentSize;
    size.height = ht_contentH;
    self.contentSize = size;
}

- (CGFloat)ht_contentH
{
    return self.contentSize.height;
}
@end
#pragma clang diagnostic pop
