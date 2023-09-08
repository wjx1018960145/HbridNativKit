//
//  UIImage+ForceDecode.h
//  HybridForiOS
//
//  Created by wjx on 2020/3/17.
//  Copyright © 2020 WJX. All rights reserved.
//




#import <UIKit/UIKit.h>
#import "HTWebImageCompat.h"
NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ForceDecode)
+ (UIImage *)decodedImageWithImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
