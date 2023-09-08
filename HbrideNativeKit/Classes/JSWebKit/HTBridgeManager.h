//
//  HTBridgeManager.h
//  HybridForiOS
//
//  Created by wjx on 2020/3/3.
//  Copyright © 2020 WJX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTWebViewConfig.h"
#import "HTWebBridgeProtocol.h"
#import "WKWebViewJavascriptBridge.h"

NS_ASSUME_NONNULL_BEGIN

#ifdef __cplusplus
extern "C" {
#endif
    void HTPerformBlockOnBridgeThread(void (^block)(void));
    void HTPerformBlockSyncOnBridgeThread(void (^block) (void));
    void HTPerformBlockOnBackupBridgeThread(void (^block)(void));

    void HTPerformBlockOnBridgeThreadForInstance(void (^block)(void), NSString* instance);
    void HTPerformBlockSyncOnBridgeThreadForInstance(void (^block) (void), NSString* instance);
#ifdef __cplusplus
}
#endif

@interface HTBridgeManager : NSObject
+ (instancetype)sharedManager;
// WebView 的ViewController
@property (nonatomic, weak) UIViewController *containerViewController;

// 拓展的plugin（每次增加新交互不用频繁修改基础组件）
@property (nonatomic,strong) NSMutableDictionary *pluginDic;

// 注册基础 JavaScript 的处理
- (void)registerJavaScriptHandler:(WKWebViewJavascriptBridge *)bridge ids:(id)ids;
//- (void)registerJavaScriptHandlerName:(NSString*)handlerName handler:(NSDictionary*)dic;
- (void)registerJavaScriptHandlerName:(NSString*)handlerName viewController:(id)viewController;
- (void)initModulesName:(NSString*)moduleName :(NSMutableDictionary*)modules;
- (void)registerModules:(NSString*)moduleName dict:(NSDictionary*)dict;
+ (UIViewController *)currentViewController;
@end

NS_ASSUME_NONNULL_END
