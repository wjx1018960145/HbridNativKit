//
//  UIImage+WJXImage.h
//  merchantHNB
//
//  Created by wjx on 17/8/17.
//  Copyright © 2017年 WJX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (WJXImage)
+ (UIImage *)originImageWithName: (NSString *)name;

- (UIImage *)circleImage;
- (UIImage *)imageByScalingToSize:(CGSize)targetSize; 
@end
