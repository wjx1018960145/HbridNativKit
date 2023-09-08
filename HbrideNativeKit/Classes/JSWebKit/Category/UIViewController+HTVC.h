//
//  UIViewController+HTVC.h
//  HybridForiOS
//
//  Created by wjx on 2020/3/9.
//  Copyright © 2020 WJX. All rights reserved.
//




#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (HTVC)
+(UIViewController*)findBestViewController:(UIViewController*)vc;
@end

NS_ASSUME_NONNULL_END
