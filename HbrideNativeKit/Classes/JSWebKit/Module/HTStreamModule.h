//
//  HTStreamModule.h
//  HybridForiOS
//
//  Created by wjx on 2020/3/10.
//  Copyright © 2020 WJX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTWebBridgeProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface HTStreamModule : NSObject<HTWebBridgeProtocol>
- (void)fetch:(NSDictionary *)options callback:(HTJBResponseCallback)callback progressCallback:(nullable HTJBProgessCallback)progressCallback;
//- (void)sendHttp:(NSDictionary*)param callback:(HTModuleKeepAliveCallback)callback DEPRECATED_MSG_ATTRIBUTE("Use fetch method instead.");
@end

NS_ASSUME_NONNULL_END
