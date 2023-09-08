//
//  HTDownloadManager.h
//  HybridForiOS
//
//  Created by wjx on 2020/3/20.
//  Copyright © 2020 WJX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTDataBaseManager.h"
#import "HTToolBox.h"
//#import "AppDelegate.h"
#import "HTNetworkReachabilityManager.h"
#import "HTProgressHUD.h"
@class HTDownloadModel;
NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger, HTDownloadState) {
    HTDownloadStateDefault = 0,  // 默认
    HTDownloadStateDownloading,  // 正在下载
    HTDownloadStateWaiting,      // 等待
    HTDownloadStatePaused,       // 暂停
    HTDownloadStateFinish,       // 完成
    HTDownloadStateError,        // 错误
};
@interface HTDownloadManager : NSObject

// 初始化下载单例，若之前程序杀死时有正在下的任务，会自动恢复下载
+ (instancetype)shareManager;

// 开始下载
- (void)startDownloadTask:(HTDownloadModel *)model;

// 暂停下载
- (void)pauseDownloadTask:(HTDownloadModel *)model;

// 删除下载任务及本地缓存
- (void)deleteTaskAndCache:(HTDownloadModel *)model;

@end

NS_ASSUME_NONNULL_END
