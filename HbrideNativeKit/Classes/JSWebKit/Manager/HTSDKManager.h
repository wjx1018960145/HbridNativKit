//
//  HTSDKManager.h
//  HybridForiOS
//
//  Created by wjx on 2020/3/4.
//  Copyright © 2020 WJX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTBridgeManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface HTSDKManager : NSObject
/**
 *@abstract Returns sdk manager
 */
+ (HTSDKManager *)sharedInstance;
/**
 * @abstract Returns bridge manager
 **/
+ (HTBridgeManager *)bridgeMgr;

@end

NS_ASSUME_NONNULL_END
