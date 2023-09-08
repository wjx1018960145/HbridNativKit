//
//  UIImage+Resource.h
//  HybridForiOS
//
//  Created by wjx on 2020/3/2.
//  Copyright © 2020 WJX. All rights reserved.
//



#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Resource)
+ (UIImage *)imageFromBundle:(NSBundle *)bundle imageName:(NSString *)imageName;

@end

NS_ASSUME_NONNULL_END
