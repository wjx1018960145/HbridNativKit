//
//  HTBridgeCallBack.h
//  HybridForiOS
//
//  Created by wjx on 2020/3/3.
//  Copyright © 2020 WJX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKWebViewJavascriptBridge.h"
NS_ASSUME_NONNULL_BEGIN

@interface HTBridgeCallBack : NSObject
// js回调
+ (void)wrapResponseCallBack:(HTJBResponseCallback)responseCallBack
                     message:(NSString*)message result:(BOOL)result responseObject:(id)responseObject;
@end

NS_ASSUME_NONNULL_END
