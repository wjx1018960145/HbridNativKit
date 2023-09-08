//
//  HTSDKInstance.h
//  HybridForiOS
//
//  Created by wjx on 2020/3/3.
//  Copyright © 2020 WJX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKWebViewJavascriptBridge.h"
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN





@interface HTSDKInstance : UIViewController
/**
 * Init instance and render it using iOS native views.
 * It is the same as initWithRenderType:@"platform"
 **/
- (instancetype)init;

/// 创建一个H5容器
/// @param params 包含连接地址 导航栏设置 等参数
- (UIViewController*)createH5ViewControllerWithNebulaApp:(NSDictionary*)params;
/**
 * Init instance with custom render type.
 **/
- (instancetype)initWithRenderType:(NSString*)renderType;
/**
 * The viewControler which the weex bundle is rendered in.
 **/
@property (nonatomic, strong) UIViewController *viewController;

/**
 * The Native root container used to bear the view rendered by weex file.
 * The root view is controlled by WXSDKInstance, so you can only get it, but not change it.
 **/
@property (nonatomic, strong) UIView *rootView;

/**
 * The parent instance.
 **/
//@property (nonatomic, strong) HTBridgeManager *bridgeManager;
@property (nonatomic, strong) WKWebViewJavascriptBridge *jsBridge;
@property (nonatomic, weak) HTSDKInstance *parentInstance;
@property (nonatomic, strong) NSString *schemeName;
@property (nonatomic, strong) NSDictionary *addionalHeader;

@end

NS_ASSUME_NONNULL_END
