//
//  ZZQAvatarPicker.h
//  ZZQAvatarPicker
//
//  Created by 郑志强 on 2018/10/31.
//  Copyright © 2018 郑志强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WebViewJavascriptBridgeBase.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZZQAvatarPicker : NSObject

+ (void)startSelectedblack:(HTJBResponseCallback)responseCallback compleiton:(void(^)(UIImage *image,NSURL*filePath))compleiton;

@end

NS_ASSUME_NONNULL_END
