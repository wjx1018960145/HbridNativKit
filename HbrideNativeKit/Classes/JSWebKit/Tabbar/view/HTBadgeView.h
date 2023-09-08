//
//  HTBadgeView.h
//  HybridForiOS
//
//  Created by wjx on 2020/5/18.
//  Copyright © 2020 WJX. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTBadgeView : UIButton
/** remind number */
@property (copy , nonatomic) NSString *badgeValue;
/** remind color */
@property (copy , nonatomic) UIColor *badgeColor;
@end

NS_ASSUME_NONNULL_END
