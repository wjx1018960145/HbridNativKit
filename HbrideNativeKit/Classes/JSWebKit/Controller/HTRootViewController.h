//
//  HTRootViewController.h
//  HybridForiOS
//
//  Created by wjx on 2020/3/10.
//  Copyright © 2020 WJX. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTRootViewController : UINavigationController
/**
 * @abstract initialize the RootViewController with bundle url.
 *
 * @param sourceURL The bundle url which can be render to a weex view.
 *
 * @return a object the class of WXRootViewController.
 *
 * @discussion initialize this controller in function 'application:didFinishLaunchingWithOptions', and make it as rootViewController of window. In the
 * weex application, all page content can be managed by the navigation, such as push or pop.
 */
- (id)initWithSourceURL:(NSURL *)sourceURL;

@end

NS_ASSUME_NONNULL_END
