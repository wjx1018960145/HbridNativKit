//
//  HTModuleProtocol.h
//  HybridForiOS
//
//  Created by wjx on 2020/3/3.
//  Copyright © 2020 WJX. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "HTSDKInstance.h"
#import "HTDefine.h"

#define MSG_SUCCESS     @"HT_SUCCESS"
#define MSG_NO_HANDLER  @"HT_NO_HANDLER"
#define MSG_NO_PERMIT   @"HT_NO_PERMISSION"
#define MSG_FAILED      @"HT_FAILED"
#define MSG_PARAM_ERR   @"HT_PARAM_ERR"
#define MSG_EXP         @"HT_EXCEPTION"

@protocol HTModuleProtocol <NSObject>
/**
* @abstract the module callback , result can be string or dictionary.
* @discussion callback data to js, the id of callback function will be removed to save memory.
*/
typedef void (^HTModuleCallback)(id _Nullable result);

//DEPRECATED_MSG_ATTRIBUTE("use WXModuleKeepAliveCallback, you can specify keep the callback or not, if keeped, it can be called multi times, or it will be removed after called.")

/**
 * @abstract the module callback , result can be string or dictionary.
 * @discussion callback data to js, you can specify the keepAlive parameter to keep callback function id keepalive or not. If the keepAlive is true, it won't be removed until instance destroyed, so you can call it repetitious.
 */
typedef void (^HTModuleKeepAliveCallback)(id _Nullable result, BOOL keepAlive);


#define HT_EXPORT_MODULE(module)

@optional

- (dispatch_queue_t _Nullable )targetExecuteQueue;
- (NSThread *_Nonnull)targetExecuteThread;
@property (nonatomic, weak) HTSDKInstance * _Nullable htInstance;

@end


