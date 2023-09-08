//
//  HTBaseViewController.h
//  HybridForiOS
//
//  Created by wjx on 2020/3/9.
//  Copyright © 2020 WJX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTH5ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTBaseViewController : HTH5ViewController<UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSString *appHtml;
@property (nonatomic, strong) NSURL *baseURL;
//@property (nonatomic)

- (instancetype)initWithSourceURL:(NSURL *)sourceURL;


/**
 * @abstract refreshes the weex view in controller.
 */
- (void)refreshWeex;
@end

NS_ASSUME_NONNULL_END
