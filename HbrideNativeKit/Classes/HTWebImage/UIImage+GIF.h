//
//  UIImage+GIF.h
//  HybridForiOS
//
//  Created by wjx on 2020/3/17.
//  Copyright © 2020 WJX. All rights reserved.
//



#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (GIF)
+ (UIImage *)ht_animatedGIFNamed:(NSString *)name;

+ (UIImage *)ht_animatedGIFWithData:(NSData *)data;

- (UIImage *)ht_animatedImageByScalingAndCroppingToSize:(CGSize)size;
@end

NS_ASSUME_NONNULL_END
