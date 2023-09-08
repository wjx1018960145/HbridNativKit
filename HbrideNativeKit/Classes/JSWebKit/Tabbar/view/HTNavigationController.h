//
//  HTNavigationController.h
//  HybridForiOS
//
//  Created by wjx on 2020/5/18.
//  Copyright © 2020 WJX. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTNavigationController : UINavigationController
/**
 全屏返回手势
 
 @param isForBidden 是否禁止
 */
- (void)setupBackPanGestureIsForbiddden:(BOOL)isForBidden;
@end

NS_ASSUME_NONNULL_END
