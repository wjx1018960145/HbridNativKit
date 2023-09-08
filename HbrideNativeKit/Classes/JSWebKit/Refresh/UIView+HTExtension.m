//
//  UIView+HTExtension.m
//  HybridForiOS
//
//  Created by wjx on 2020/4/10.
//  Copyright © 2020 WJX. All rights reserved.
//

#import "UIView+HTExtension.h"

@implementation UIView (HTExtension)

- (void)setHt_x:(CGFloat)ht_x
{
    CGRect frame = self.frame;
    frame.origin.x = ht_x;
    self.frame = frame;
}

- (CGFloat)ht_x
{
    return self.frame.origin.x;
}

- (void)setHt_y:(CGFloat)ht_y
{
    CGRect frame = self.frame;
    frame.origin.y = ht_y;
    self.frame = frame;
}

- (CGFloat)ht_y
{
    return self.frame.origin.y;
}

- (void)setHt_w:(CGFloat)ht_w
{
    CGRect frame = self.frame;
    frame.size.width = ht_w;
    self.frame = frame;
}

- (CGFloat)ht_w
{
    return self.frame.size.width;
}

- (void)setHt_h:(CGFloat)ht_h
{
    CGRect frame = self.frame;
    frame.size.height = ht_h;
    self.frame = frame;
}

- (CGFloat)ht_h
{
    return self.frame.size.height;
}

- (void)setHt_size:(CGSize)ht_size
{
    CGRect frame = self.frame;
    frame.size = ht_size;
    self.frame = frame;
}

- (CGSize)ht_size
{
    return self.frame.size;
}

- (void)setHt_origin:(CGPoint)ht_origin
{
    CGRect frame = self.frame;
    frame.origin = ht_origin;
    self.frame = frame;
}

- (CGPoint)ht_origin
{
    return self.frame.origin;
}
@end
