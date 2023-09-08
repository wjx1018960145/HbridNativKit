//
//  NetGlobeConst.h
//  HybridForiOS
//
//  Created by wjx on 2020/3/23.
//  Copyright © 2020 WJX. All rights reserved.
//

#import <UIKit/UIKit.h>

/************************* 下载 *************************/
UIKIT_EXTERN NSString * const HTDownloadProgressNotification;                   // 进度回调通知
UIKIT_EXTERN NSString * const HTDownloadStateChangeNotification;                // 状态改变通知
UIKIT_EXTERN NSString * const HTDownloadMaxConcurrentCountKey;                  // 最大同时下载数量key
UIKIT_EXTERN NSString * const HTDownloadMaxConcurrentCountChangeNotification;   // 最大同时下载数量改变通知
UIKIT_EXTERN NSString * const HTDownloadAllowsCellularAccessKey;                // 是否允许蜂窝网络下载key
UIKIT_EXTERN NSString * const HTDownloadAllowsCellularAccessChangeNotification; // 是否允许蜂窝网络下载改变通知

/************************* 网络 *************************/
UIKIT_EXTERN NSString * const HTNetworkingReachabilityDidChangeNotification;    // 网络改变改变通知

