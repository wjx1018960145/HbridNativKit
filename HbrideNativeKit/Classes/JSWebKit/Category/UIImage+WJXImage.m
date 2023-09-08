//
//  UIImage+WJXImage.m
//  merchantHNB
//
//  Created by wjx on 17/8/17.
//  Copyright © 2017年 WJX. All rights reserved.
//

#import "UIImage+WJXImage.h"

@implementation UIImage (WJXImage)
+ (UIImage *)originImageWithName: (NSString *)name {
    
    return [[UIImage imageNamed:name] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
}

- (UIImage *)circleImage {
    
    CGSize size = self.size;
    CGFloat drawWH = size.width < size.height ? size.width : size.height;
    
    
    // 1. 开启图形上下文
    UIGraphicsBeginImageContext(CGSizeMake(drawWH, drawWH));
    // 2. 绘制一个圆形区域, 进行裁剪
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect clipRect = CGRectMake(0, 0, drawWH, drawWH);
    CGContextAddEllipseInRect(context, clipRect);
    CGContextClip(context);
    
    // 3. 绘制大图片
    CGRect drawRect = CGRectMake(0, 0, size.width, size.height);
    [self drawInRect:drawRect];
    
    // 4. 取出结果图片
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 5. 关闭上下文
    UIGraphicsEndImageContext();
    
    return resultImage;
    
}

- (UIImage *)imageByScalingToSize:(CGSize)targetSize
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor < heightFactor) {
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor > heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    // this is actually the interesting part:
    UIGraphicsBeginImageContext(targetSize);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    return newImage ;
}

@end
