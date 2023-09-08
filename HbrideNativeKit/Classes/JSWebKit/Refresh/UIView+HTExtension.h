//
//  UIView+HTExtension.h
//  HybridForiOS
//
//  Created by wjx on 2020/4/10.
//  Copyright © 2020 WJX. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (HTExtension)
@property (assign, nonatomic) CGFloat ht_x;
@property (assign, nonatomic) CGFloat ht_y;
@property (assign, nonatomic) CGFloat ht_w;
@property (assign, nonatomic) CGFloat ht_h;
@property (assign, nonatomic) CGSize ht_size;
@property (assign, nonatomic) CGPoint ht_origin;
@end

NS_ASSUME_NONNULL_END
