//
//  HTNavigationProtocol.h
//  HybridForiOS
//
//  Created by wjx on 2020/3/9.
//  Copyright © 2020 WJX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HTWebBridgeProtocol.h"
NS_ASSUME_NONNULL_BEGIN
/**
 * This enum is used to define the position of navbar item.
 */
typedef NS_ENUM(NSInteger, HTNavigationItemPosition) {
    HTNavigationItemPositionCenter = 0x00,
    HTNavigationItemPositionRight,
    HTNavigationItemPositionLeft,
    HTNavigationItemPositionMore
};

/**
 * @abstract The callback after executing navigator operations. The code has some status such as 'WX_SUCCESS'、'WX_FAILED' etc. The responseData
 * contains some useful info you can handle.
 */
typedef void (^HTNavigationResultBlock)(NSString *code, NSDictionary * responseData);

@protocol HTNavigationProtocol <HTWebBridgeProtocol>

/**
 * @abstract Returns the navigation controller.
 *
 * @param container The target controller.
 */
- (id)navigationControllerOfContainer:(UIViewController *)container;

/**
 * @abstract Sets the navigation bar hidden.
 *
 * @param hidden If YES, the navigation bar is hidden.
 *
 * @param animated Specify YES to animate the transition or NO if you do not want the transition to be animated.
 *
 * @param container The navigation controller.
 *
 */
- (void)setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated
                 withContainer:(UIViewController *)container;

/**
 * @abstract Sets the background color of navigation bar.
 *
 * @param backgroundColor The background color of navigation bar.
 *
 * @param container The target controller.
 *
 */
- (void)setNavigationBackgroundColor:(UIColor *)backgroundColor
                       withContainer:(UIViewController *)container;

/**
 * @abstract Sets the item in navigation bar.
 *
 * @param param The data which is passed to the implementation of the protocol.
 *
 * @param position The value indicates the position of item.
 *
 * @param block A block called once the action is completed.
 *
 * @param container The target controller.
 *
 */
- (void)setNavigationItemWithParam:(NSDictionary *)param
                          position:(HTNavigationItemPosition)position
                        completion:(nullable HTNavigationResultBlock)block
                     withContainer:(UIViewController *)container;

/**
 * @abstract Clears the item in navigation bar.
 *
 * @param param The data which is passed to the implementation of the protocol.
 *
 * @param position The value indicates the position of item.
 *
 * @param block A block called once the action is completed.
 *
 * @param container The target controller.
 *
 */
- (void)clearNavigationItemWithParam:(NSDictionary *)param
                            position:(HTNavigationItemPosition)position
                          completion:(nullable HTNavigationResultBlock)block
                       withContainer:(UIViewController *)container;

/**
 * @abstract Pushes a view controller onto the receiver’s stack.
 *
 * @param param The data which is passed to the implementation of the protocol.
 *
 * @param block A block called once the action is completed.
 *
 * @param container The target controller.
 *
 */
- (void)pushViewControllerWithParam:(NSDictionary *)param
                         completion:(nullable HTNavigationResultBlock)block
                      withContainer:(UIViewController *)container;

/**
 * @abstract Pops the top view controller from the navigation stack.
 *
 * @param param The data which is passed to the implementation of the protocol.
 *
 * @param block A block called once the action is completed.
 *
 * @param container The target controller.
 *
 */
- (void)popViewControllerWithParam:(NSDictionary *)param
                        completion:(nullable HTNavigationResultBlock)block
                     withContainer:(UIViewController *)container;

@end

NS_ASSUME_NONNULL_END
