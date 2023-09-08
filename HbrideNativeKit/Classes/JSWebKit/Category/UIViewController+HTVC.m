//
//  UIViewController+HTVC.m
//  HybridForiOS
//
//  Created by wjx on 2020/3/9.
//  Copyright © 2020 WJX. All rights reserved.
//

#import "UIViewController+HTVC.h"




@implementation UIViewController (HTVC)

+(UIViewController*)findBestViewController:(UIViewController*)vc
{
    if (vc.presentedViewController) {
        return [UIViewController findBestViewController:vc.presentedViewController];
    } else if ([vc isKindOfClass:[UISplitViewController class]])
    {
        UISplitViewController* svc = (UISplitViewController*)vc;
        if (svc.viewControllers.count > 0) {
            return [UIViewController findBestViewController:svc.viewControllers.lastObject];
        } else {
            return vc;
        }
    } else if ([vc isKindOfClass:[UINavigationController class]])
    {
        UINavigationController* nvc = (UINavigationController*)vc;
        if (nvc.viewControllers.count > 0) {
            return [UIViewController findBestViewController:nvc.topViewController];
        } else {
            return vc;
        }
    } else if ([vc isKindOfClass:[UITabBarController class]])
    {
        UITabBarController* tvc = (UITabBarController*)vc;
        if (tvc.viewControllers.count) {
            return [UIViewController findBestViewController:tvc.selectedViewController];
        } else {
            return vc;
        }
    } else {
        return vc;
    }
}



@end
