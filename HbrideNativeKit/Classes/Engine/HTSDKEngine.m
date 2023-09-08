//
//  HTSDKEngine.m
//  HybridForiOS
//
//  Created by wjx on 2020/3/3.
//  Copyright © 2020 WJX. All rights reserved.
//

#import "HTSDKEngine.h"
#import "HTAssert.h"
#import "HTDefine.h"
#import "HTUtility.h"
#import "HTModuleFactory.h"
#import "HTSDKManager.h"
#import "HTHandlerFactory.h"
#import "HTH5ViewController.h"
#import "HTNavigationDefaultImpl.h"
#import "HTNavigationProtocol.h"
#import "HTResourceRequestHandlerDefaultImpl.h"
#import "HTResourceRequestHandler.h"
@implementation HTSDKEngine

+ (void)initSDKEnvironment {
    if (@available(iOS 13.0, *)) {
       }
       else {
           [HTUtility setDarkSchemeSupportEnable:NO];
       }
    [self _registerDefaultModules];
    [self _registerDefaultHandlers];
//    [[WebViewJavascriptBridgeBase bridgeBase] injectJavascriptFile];
    
}

+(void)_registerDefaultModules{
    
    [self registerModule:@"HT" className:@"DefaultMoudle" withClasss:@[@"HTNavigatorModule"]];
    [self registerModule:@"HT" className:@"DefaultMoudle" withClasss:@[@"HTWebSocketModule"]];
    [self registerModule:@"HT" className:@"DefaultMoudle" withClasss:@[@"HTStreamModule"]];
    [self registerModule:@"HT" className:@"DefaultMoudle" withClasss:@[@"HTStorageModule"]];
    [self registerModule:@"HT" className:@"DefaultMoudle" withClasss:@[@"HTPickerModule"]];
    [self registerModule:@"HT" className:@"DefaultMoudle" withClasss:@[@"HTCameraPhotoModule"]];
    [self registerModule:@"HT" className:@"DefaultMoudle" withClasss:@[@"HTDeviceInfoModule"]];
    [self registerModule:@"HT" className:@"DefaultMoudle" withClasss:@[@"HTDownloadModule"]];
     [self registerModule:@"HT" className:@"DefaultMoudle" withClasss:@[@"HTAlterViewModule"]];
    [self registerModule:@"HT" className:@"DefaultMoudle" withClasss:@[@"HTHUDProgressModule"]];
}

+ (void)_registerDefaultHandlers{
    [self registerHandler:[HTNavigationDefaultImpl new] withProtocol:@protocol(HTNavigationProtocol)];
    
    [self registerHandler:[HTResourceRequestHandlerDefaultImpl new] withProtocol:@protocol(HTResourceRequestHandler)];
    
}

+ (void)registerModule:(NSString *)name className:(NSString*)className withClasss:(NSArray*)clazzs {
    HTAssert(name && clazzs, @"Fail to register the module, please check if the parameters are correct ！");
    if (!name || !clazzs || !className) {
        return;
    }
    if([className isEqualToString:@""]){
        className = @"HTBaseViewController";
    }
    
//    NSString *name = @"ViewController";
//    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
//    UITabBarController *tabViewController = (UITabBarController *) window.rootViewController;
//    UIViewController *vcs;
//    for (UINavigationController *nav in tabViewController.childViewControllers) {
//        NSLog(@"%@",nav.childViewControllers);
//        for (UIViewController *vc in nav.childViewControllers) {
//            NSLog(@"%@",vc);
//            NSString *vcName = NSStringFromClass([vc class]);
//            if ([vcName isEqualToString:className]) {
//                Class cls = NSClassFromString(className);
//                  vcs = vc;
//            }
//        }
//    }
   
    
    
//     NSString *moduleName = [HTModuleFactory registerModule:name withClass:clazz];
//    NSDictionary *dict = [HTModuleFactory moduleMethodMapsWithName:moduleName];
//
//
    [[HTSDKManager bridgeMgr] initModulesName:className :[NSMutableDictionary dictionaryWithDictionary:@{className:clazzs}]];
    
//    [HTSDKManager bridgeMgr].pluginArray =[NSMutableArray arrayWithArray:clazzs];
    
//    [[HTSDKManager bridgeMgr] registerJavaScriptHandlerName:name viewController:vcs];
    
}
+ (void)registerComponent:(NSString *)name withClass:(Class)clazz {
    
}

+(void)registerModule:(NSString *)name withClass:(Class)clazz{
    HTAssert(name && clazz, @"Fail to register the module, please check if the parameters are correct ！");
       if (!clazz || !name) {
           return;
       }
    
    NSString *moduleName = [HTModuleFactory registerModule:name withClass:clazz];
       NSDictionary *dict = [HTModuleFactory moduleMethodMapsWithName:moduleName];
    
     [[HTSDKManager bridgeMgr] registerModules:moduleName dict:dict];
    
}

+ (void)registerHandler:(id)handler withProtocol:(Protocol *)protocol
{
    HTAssert(handler && protocol, @"Fail to register the handler, please check if the parameters are correct ！");
    
    [HTHandlerFactory registerHandler:handler withProtocol:protocol];
}

+ (NSString*)SDKEngineVersion
{
    return HT_SDK_VERSION;
}

@end
