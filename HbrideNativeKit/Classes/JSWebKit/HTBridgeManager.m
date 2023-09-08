//
//  HTBridgeManager.m
//  HybridForiOS
//
//  Created by wjx on 2020/3/3.
//  Copyright © 2020 WJX. All rights reserved.
//

#import "HTBridgeManager.h"
#import "HTBridgeCallBack.h"
#import "HTH5ViewController.h"
#import "WebViewJavascriptBridgeBase.h"
#import "HTUtility.h"
#import "HTLog.h"
#import "HTDefine.h"
#import "HTHandlerFactory.h"
#import "HTNavigationProtocol.h"
#import "UIViewController+HTVC.h"
static NSThread *HTBridgeThread;
static NSThread *HTBackupBridgeThread;

@interface HTBridgeManager()
@property (nonatomic, assign) BOOL stopRunning;
//@property (nonatomic, strong) WKWebViewJavascriptBridge *bridgeCtx;
@end

@implementation HTBridgeManager

+(instancetype)sharedManager{
    static id _sharedInstance = nil;
       static dispatch_once_t oncePredicate;
       dispatch_once(&oncePredicate, ^{
           _sharedInstance = [[self alloc] init];
       });
       return _sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.pluginDic = [NSMutableDictionary dictionary];
//        self.bridgeCtx = [[WKWebViewJavascriptBridge alloc] init];
    }
    return self;
}

//注册自定义module
- (void)registerJavaScriptHandlerName:(NSString*)handlerName viewController:(id)viewController {
//    [(HTH5ViewController*)viewController jsBridge];
    NSArray *arr = self.pluginDic[handlerName];
    for (id<HTWebBridgeProtocol>plugin  in arr) {
        [plugin registerBridge:[(HTH5ViewController*)viewController jsBridge]];
    }
    
}

//注册全局默认module
- (void)registerJavaScriptHandler:(WKWebViewJavascriptBridge *)bridge ids:(id)ids{
    //扩展插件（每次增加新交互不用频繁修改基础组件）
    NSArray *defaultArr = self.pluginDic[@"DefaultMoudle"];
    for (id<HTWebBridgeProtocol>plugin  in defaultArr) {
//        [plugin setHtInstance:ids];
        plugin.htInstance = ids;
        [plugin registerBridge: bridge];
    }
    
     NSArray *baseArr = self.pluginDic[@"HTBaseViewController"];
        for (id<HTWebBridgeProtocol>plugin  in baseArr) {
    //        [plugin setHtInstance:ids];
            plugin.htInstance = ids;
            [plugin registerBridge: bridge];
        }
    
}



- (void)initModulesName:(NSString *)moduleName :(NSMutableDictionary *)modules{
    if ([self.pluginDic valueForKey:moduleName]) {
        NSMutableArray *arrs = [self.pluginDic valueForKey:moduleName];
        for (NSString *className in modules[moduleName]) {
                 Class cls = NSClassFromString(className);
        //        Class class = [[cls alloc] init];
                
                [arrs addObject:[[cls alloc]init]];
            }
    }else{
        NSMutableArray *newarr = [@[] mutableCopy];
        for (NSString *className in modules[moduleName]) {
                        Class cls = NSClassFromString(className);
               //        Class class = [[cls alloc] init];
                       [newarr addObject:[[cls alloc]init]];
                   }
        [self.pluginDic setValue:newarr forKey:moduleName];
    }
}

- (id<HTNavigationProtocol>)navigator

{
    
    id<HTNavigationProtocol> navigator = [HTHandlerFactory handlerForProtocol:@protocol(HTNavigationProtocol)];
    
    return navigator;
}

+(UIViewController *)currentViewController
{
    UIViewController* viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [UIViewController findBestViewController:viewController];
    
}


- (void)registerModules:(NSString*)moduleName dict:(NSDictionary*)dict {
    if (!moduleName) return;
    
     dict = [HTUtility convertContainerToImmutable:dict];
     HTLogInfo(@"Register modules: %@", moduleName);
//    __weak typeof(self) weakSelf = self;
    
    
//    [self.bridgeCtx registerModules:dict];
    
    
    
    
    
    
//       HTPerformBlockOnBridgeThread(^(){
////           [weakSelf.bridgeCtx registerModules:modules];
//       });
//       HTPerformBlockOnBackupBridgeThread(^(){
////           [weakSelf.backupBridgeCtx registerModules:modules];
//       });
    
}
void HTPerformBlockOnBridgeThread(void (^block)(void))
{
    [HTBridgeManager _performBlockOnBridgeThread:block];
}

void HTPerformBlockOnBridgeThreadForInstance(void (^block)(void), NSString* instance) {
    [HTBridgeManager _performBlockOnBridgeThread:block instance:instance];
}

+ (void)_performBlockOnBridgeThread:(void (^)(void))block
{
    if ([NSThread currentThread] == [self jsThread]) {
        block();
    } else {
        [self performSelector:@selector(_performBlockOnBridgeThread:)
                         onThread:[self jsThread]
                       withObject:[block copy]
                    waitUntilDone:NO];
    }
}

+ (void)_performBlockOnBridgeThread:(void (^)(void))block instance:(NSString*)instanceId
{

}
    

+ (NSThread *)jsThread
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        HTBridgeThread = [[NSThread alloc] initWithTarget:[[self class]sharedManager] selector:@selector(_runLoopThread) object:nil];
        [HTBridgeThread setName:HT_BRIDGE_THREAD_NAME];
        [HTBridgeThread setQualityOfService:[[NSThread mainThread] qualityOfService]];
        [HTBridgeThread start];
    });

    return HTBridgeThread;
}

- (void)_runLoopThread
{
    [[NSRunLoop currentRunLoop] addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
    
    while (!_stopRunning) {
        @autoreleasepool {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
    }
}
+ (NSThread *)backupJsThread
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        HTBackupBridgeThread = [[NSThread alloc] initWithTarget:[[self class]sharedManager] selector:@selector(_runLoopThread) object:nil];
        [HTBackupBridgeThread setName:HT_BACKUP_BRIDGE_THREAD_NAME];
        [HTBackupBridgeThread setQualityOfService:[[NSThread mainThread] qualityOfService]];
        [HTBackupBridgeThread start];
    });

    return HTBackupBridgeThread;
}
@end
