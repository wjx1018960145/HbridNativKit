//
//  HTCenterButton.h
//  HybridForiOS
//
//  Created by wjx on 2020/5/18.
//  Copyright © 2020 WJX. All rights reserved.
//

#import <UIKit/UIKit.h>
#define BULGEH 16   //button bulge of height
NS_ASSUME_NONNULL_BEGIN

@interface HTCenterButton : UIButton
@property(assign , nonatomic,getter=is_bulge) BOOL bulge;
@end

NS_ASSUME_NONNULL_END
