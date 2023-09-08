//
//  HTDataBaseManager.h
//  HybridForiOS
//
//  Created by wjx on 2020/3/20.
//  Copyright © 2020 WJX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTDB.h"
#import "HTToolBox.h"
#import "NetGlobeConst.h"
@class HTDownloadModel;


typedef NS_OPTIONS(NSUInteger, HTDBUpdateOption) {
    HTDBUpdateOptionState         = 1 << 0,  // 更新状态
    HTDBUpdateOptionLastStateTime = 1 << 1,  // 更新状态最后改变的时间
    HTDBUpdateOptionResumeData    = 1 << 2,  // 更新下载的数据
    HTDBUpdateOptionProgressData  = 1 << 3,  // 更新进度数据（包含tmpFileSize、totalFileSize、progress、intervalFileSize、lastSpeedTime）
    HTDBUpdateOptionAllParam      = 1 << 4   // 更新全部数据
};

@interface HTDataBaseManager : NSObject

// 获取单例
+ (instancetype)shareManager;

// 插入数据
- (void)insertModel:(HTDownloadModel *)model;

// 获取数据
- (HTDownloadModel *)getModelWithUrl:(NSString *)url;    // 根据url获取数据
- (HTDownloadModel *)getWaitingModel;                    // 获取第一条等待的数据
- (HTDownloadModel *)getLastDownloadingModel;            // 获取最后一条正在下载的数据
- (NSArray<HTDownloadModel *> *)getAllCacheData;         // 获取所有数据
- (NSArray<HTDownloadModel *> *)getAllDownloadingData;   // 根据lastStateTime倒叙获取所有正在下载的数据
- (NSArray<HTDownloadModel *> *)getAllDownloadedData;    // 获取所有下载完成的数据
- (NSArray<HTDownloadModel *> *)getAllUnDownloadedData;  // 获取所有未下载完成的数据（包含正在下载、等待、暂停、错误）
- (NSArray<HTDownloadModel *> *)getAllWaitingData;       // 获取所有等待下载的数据

// 更新数据
- (void)updateWithModel:(HTDownloadModel *)model option:(HTDBUpdateOption)option;

// 删除数据
- (void)deleteModelWithUrl:(NSString *)url;

@end


