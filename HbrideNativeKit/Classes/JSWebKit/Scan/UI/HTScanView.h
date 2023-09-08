//
//  HTScanView.h
//  HybridForiOS
//
//  Created by wjx on 2020/3/25.
//  Copyright © 2020 WJX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTScanLineAnimation.h"
#import "HTScanNetAnimation.h"
#import "HTScanViewStyle.h"
NS_ASSUME_NONNULL_BEGIN

@interface HTScanView : UIView

/**
 @brief  初始化
 @param frame 位置大小
 @param style 类型

 @return instancetype
 */
-(id)initWithFrame:(CGRect)frame style:(HTScanViewStyle*)style;

/**
 *  设备启动中文字提示
 */
- (void)startDeviceReadyingWithText:(NSString*)text;

/**
 *  设备启动完成
 */
- (void)stopDeviceReadying;

/**
 *  开始扫描动画
 */
- (void)startScanAnimation;

/**
 *  结束扫描动画
 */
- (void)stopScanAnimation;

//

/**
 @brief  根据矩形区域，获取Native扫码识别兴趣区域
 @param view  视频流显示UIView
 @param style 效果界面参数
 @return 识别区域
 */
+ (CGRect)getScanRectWithPreView:(UIView*)view style:(HTScanViewStyle*)style;



/**
 根据矩形区域，获取ZXing库扫码识别兴趣区域

 @param view 视频流显示视图
 @param style 效果界面参数
 @return 识别区域
 */
+ (CGRect)getZXingScanRectWithPreView:(UIView*)view style:(HTScanViewStyle*)style;


@end

NS_ASSUME_NONNULL_END
