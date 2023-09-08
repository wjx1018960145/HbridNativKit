//
//  HTScanVideoZoomView.h
//  HybridForiOS
//
//  Created by wjx on 2020/3/25.
//  Copyright © 2020 WJX. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTScanVideoZoomView : UIView

 /*@brief 控件值变化
 */
@property (nonatomic, copy,nullable) void (^block)(float value);

- (void)setMaximunValue:(CGFloat)value;
@end

NS_ASSUME_NONNULL_END
