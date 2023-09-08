//
//  HTNetworkReachabilityManager.h
//  HybridForiOS
//
//  Created by wjx on 2020/3/23.
//  Copyright © 2020 WJX. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, HTNetworkStatus) {
    HTNetworkStatusNone,
    HTNetworkStatus3G,
    HTNetworkStatus4G,
    HTNetworkStatusWifi,
    HTNetworkStatusUkonow
};

NS_ASSUME_NONNULL_BEGIN

@protocol HTNetworkStatusDelegate <NSObject>

- (void)observer:(id)obsever host:(NSString *)host networkStatusDidChanged:(HTNetworkStatus)ststus;

@end
@interface HTNetworkReachabilityManager : NSObject
/**
 *  当前网络状态
 */
@property (nonatomic,assign) HTNetworkStatus networkStatus;

/**
 * delegate,如果设定,只走代理,不发全局通知.否则只发全局通知
 */
@property (nonatomic,weak) id <HTNetworkStatusDelegate> delegate;

/**
 *  是否支持IPv4,默认全部支持
 */
@property (nonatomic,assign) BOOL supportIPv4;

/**
 *  是否支持IPv6
 */
@property (nonatomic,assign) BOOL supportIPv6;

/**
 *  有很小概率ping失败(实际没有断网),设定多少次ping失败认为是断网,默认2次
 */
@property (nonatomic,assign) NSUInteger failureTimes;

/**
 *  ping 的频率,默认1s
 */
@property (nonatomic,assign) NSTimeInterval interval;

/**
 *  默认www.baidu.com
 */
+ (instancetype)shareManager;

/**
 *  自定义地址
 */
+ (instancetype)observerWithHost:(NSString *)host;

/**
 *  开始监控
 */
- (void)startNotifier;

/**
 *  停止监控
 */
- (void)stopNotifier;
@end

NS_ASSUME_NONNULL_END
