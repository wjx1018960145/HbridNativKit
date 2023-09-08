//
//  HTNetworkReachabilityManager.m
//  HybridForiOS
//
//  Created by wjx on 2020/3/23.
//  Copyright © 2020 WJX. All rights reserved.
//

#import "HTNetworkReachabilityManager.h"
#import "Reachability.h"
#import "SimplePinger.h"
#import "NetGlobeConst.h"
#import <UIKit/UIKit.h>
NSString *HTReachabilityChangedNotification = @"HTNetworkReachabilityChangedNotification";

@interface HTNetworkReachabilityManager()

@property (nonatomic,copy) NSString *host;

@property (nonatomic,strong) Reachability *hostReachability;

@property (nonatomic,strong) SimplePinger *pinger;
@end

@implementation HTNetworkReachabilityManager

#pragma mark - 初始化
+ (instancetype)shareManager{
    HTNetworkReachabilityManager *obsever = [[self alloc] init];
    obsever.host = @"www.baidu.com";
    return obsever;
}

+ (instancetype)observerWithHost:(NSString *)host{
    HTNetworkReachabilityManager *obsever = [[self alloc] init];
    obsever.host = host;
    return obsever;
}

- (instancetype)init{
    if (self = [super init]) {
        _networkStatus = -1;
        _failureTimes = 2;
        _interval = 1.0;
    }
    return self;
}

- (void)dealloc{
    [self.hostReachability stopNotifier];
    [self.pinger stopNotifier];
}
#pragma mark - function

- (void)startNotifier{
    [self.hostReachability startNotifier];
    [self.pinger startNotifier];
}

- (void)stopNotifier{
    [self.hostReachability stopNotifier];
    [self.pinger stopNotifier];
}

#pragma mark - delegate
- (void)networkStatusDidChanged{
    
    //获取两种方法得到的联网状态,并转为BOOL值
    BOOL status1 = [self.hostReachability currentReachabilityStatus];
    
    BOOL status2 =  self.pinger.reachable;
    
    //综合判断网络,判断原则:Reachability -> pinger
    if (status2) {//有网
        self.networkStatus = self.netWorkDetailStatus;
    }else{//无网
        self.networkStatus = HTNetworkStatusNone;
//        self.networkStatus = self.netWorkDetailStatus;
    }
}

#pragma mark - setter
- (void)setNetworkStatus:(HTNetworkStatus)networkStatus{
    if (_networkStatus != networkStatus) {
        _networkStatus = networkStatus;
        
        NSLog(@"网络状态-----%@",self.networkDict[@(networkStatus)]);
        
        //有代理
        if(self.delegate){//调用代理
            if ([self.delegate respondsToSelector:@selector(observer:host:networkStatusDidChanged:)]) {
                [self.delegate observer:self host:self.host networkStatusDidChanged:networkStatus];
            }
        }else{//发送全局通知
            NSDictionary *info = @{@"status" : @(networkStatus),
                                   @"host"   : self.host      };
//            [[NSNotificationCenter defaultCenter] postNotificationName:HTReachabilityChangedNotification object:nil userInfo:info];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:HTNetworkingReachabilityDidChangeNotification object:info];
                                         
        }
        
    }
    
}
#pragma mark - getter

- (Reachability *)hostReachability{
//     __weak typeof(self) weakSelf = self;
    if (_hostReachability == nil) {
        _hostReachability = [Reachability reachabilityWithHostName:self.host];
        
       
        [_hostReachability setNetworkStatusDidChanged:^{
            [self networkStatusDidChanged];
        }];
    }
    return _hostReachability;
}

- (SimplePinger *)pinger{
    if (_pinger == nil) {
        _pinger = [SimplePinger simplePingerWithHostName:self.host];
        _pinger.supportIPv4 = self.supportIPv4;
        _pinger.supportIPv6 = self.supportIPv6;
        _pinger.interval = self.interval;
        _pinger.failureTimes = self.failureTimes;
        
//        __weak typeof(self) weakSelf = self;
        [_pinger setNetworkStatusDidChanged:^{
            [self networkStatusDidChanged];
        }];
    }
    return _pinger;
}
#pragma mark - tools
- (HTNetworkStatus)netWorkDetailStatus{
     HTNetworkStatus status = HTNetworkStatusNone;
     id _statusBar = nil;
    if(@available(ios 13.0, *)){
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wundeclared-selector"
                UIStatusBarManager *statusBarManager = [UIApplication sharedApplication].keyWindow.windowScene.statusBarManager;
                if ([statusBarManager respondsToSelector:@selector(createLocalStatusBar)]) {
                    UIView *_localStatusBar = [statusBarManager performSelector:@selector(createLocalStatusBar)];
                    if ([_localStatusBar respondsToSelector:@selector(statusBar)]) {
                        _statusBar = [_localStatusBar performSelector:@selector(statusBar)];
                    }
                }
        #pragma clang diagnostic pop
                if (_statusBar) {
                    // _UIStatusBarDataCellularEntry
                    id currentData = [[_statusBar valueForKeyPath:@"_statusBar"] valueForKeyPath:@"currentData"];
                    id _wifiEntry = [currentData valueForKeyPath:@"wifiEntry"];
                    id _cellularEntry = [currentData valueForKeyPath:@"cellularEntry"];
                    if (_wifiEntry && [[_wifiEntry valueForKeyPath:@"isEnabled"] boolValue]) {
                        // If wifiEntry is enabled, is WiFi.
                        status = HTNetworkStatusWifi;
                    } else if (_cellularEntry && [[_cellularEntry valueForKeyPath:@"isEnabled"] boolValue]) {
                        NSNumber *type = [_cellularEntry valueForKeyPath:@"type"];
                        if (type) {
                            switch (type.integerValue) {
                                case 0:
                                               status = HTNetworkStatusNone;
                                               break;
                                           case 1://实际上是2G
                                               status = HTNetworkStatusUkonow;
                                               break;
                                           case 2:
                                               status = HTNetworkStatus3G;
                                               break;
                                           case 3:
                                               status = HTNetworkStatus4G;
                                               break;
                                           case 5:
                                               status = HTNetworkStatusWifi;
                                               break;
                                           default:
                                               status = HTNetworkStatusUkonow;
                                               break;
                            }
                        }
                    }
                }
    }else{
        UIApplication *app = [UIApplication sharedApplication];
        
        
        UIView *statusBar = [app valueForKeyPath:@"statusBar"];
        
        
        UIView *foregroundView = [statusBar valueForKeyPath:@"foregroundView"];
        
        UIView *networkView = nil;
        
        for (UIView *childView in foregroundView.subviews) {
            if ([childView isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
                networkView = childView;
            }
        }
        
        if (networkView) {
            int netType = [[networkView valueForKeyPath:@"dataNetworkType"]intValue];
            switch (netType) {
                case 0:
                    status = HTNetworkStatusNone;
                    break;
                case 1://实际上是2G
                    status = HTNetworkStatusUkonow;
                    break;
                case 2:
                    status = HTNetworkStatus3G;
                    break;
                case 3:
                    status = HTNetworkStatus4G;
                    break;
                case 5:
                    status = HTNetworkStatusWifi;
                    break;
                default:
                    status = HTNetworkStatusUkonow;
                    break;
              
            }
        }
            
//        return status;
    }
    
    
   return status;
    
    
    
}

- (NSDictionary *)networkDict{
    return @{
             @(HTNetworkStatusNone)   : @"无网络",
             @(HTNetworkStatusUkonow) : @"未知网络",
             @(HTNetworkStatus3G)     : @"3G网络",
             @(HTNetworkStatus4G)     : @"4G网络",
             @(HTNetworkStatusWifi)   : @"WIFI网络",
            };
}
@end
