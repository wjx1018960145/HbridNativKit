//
//  HTDataBaseManager.m
//  HybridForiOS
//
//  Created by wjx on 2020/3/20.
//  Copyright © 2020 WJX. All rights reserved.
//

#import "HTDataBaseManager.h"
#import "HTDownloadModel.h"

typedef NS_ENUM(NSInteger, HTDBGetDateOption) {
    HTDBGetDateOptionAllCacheData = 0,      // 所有缓存数据
    HTDBGetDateOptionAllDownloadingData,    // 所有正在下载的数据
    HTDBGetDateOptionAllDownloadedData,     // 所有下载完成的数据
    HTDBGetDateOptionAllUnDownloadedData,   // 所有未下载完成的数据
    HTDBGetDateOptionAllWaitingData,        // 所有等待下载的数据
    HTDBGetDateOptionModelWithUrl,          // 通过url获取单条数据
    HTDBGetDateOptionWaitingModel,          // 第一条等待的数据
    HTDBGetDateOptionLastDownloadingModel,  // 最后一条正在下载的数据
};

@interface HTDataBaseManager ()

@property (nonatomic, strong) HTDatabaseQueue *dbQueue;

@end

@implementation HTDataBaseManager

+ (instancetype)shareManager
{
    static HTDataBaseManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    
    return manager;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self creatVideoCachesTable];
    }
    
    return self;
}

// 创表
- (void)creatVideoCachesTable
{
    // 数据库文件路径
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"HTDownloadVideoCaches.sqlite"];
    
    // 创建队列对象，内部会自动创建一个数据库, 并且自动打开
    _dbQueue = [HTDatabaseQueue databaseQueueWithPath:path];

    [_dbQueue inDatabase:^(HTDatabase *db) {
        // 创表
        BOOL result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_videoCaches (id integer PRIMARY KEY AUTOINCREMENT, vid text, fileName text, url text, resumeData blob, totalFileSize integer, tmpFileSize integer, state integer, progress float, lastSpeedTime double, intervalFileSize integer, lastStateTime integer)"];
        if (result) {
//            HWLog(@"视频缓存数据表创建成功");
        }else {
//            (@"视频缓存数据表创建失败");
        }
    }];
}

// 插入数据
- (void)insertModel:(HTDownloadModel *)model
{
    [_dbQueue inDatabase:^(HTDatabase *db) {
        BOOL result = [db executeUpdate:@"INSERT INTO t_videoCaches (vid, fileName, url, resumeData, totalFileSize, tmpFileSize, state, progress, lastSpeedTime, intervalFileSize, lastStateTime) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", model.vid, model.fileName, model.url, model.resumeData, [NSNumber numberWithInteger:model.totalFileSize], [NSNumber numberWithInteger:model.tmpFileSize], [NSNumber numberWithInteger:model.state], [NSNumber numberWithFloat:model.progress], [NSNumber numberWithDouble:0], [NSNumber numberWithInteger:0], [NSNumber numberWithInteger:0]];
        if (result) {
//            HWLog(@"插入成功：%@", model.fileName);
        }else {
//            HWLog(@"插入失败：%@", model.fileName);
        }
    }];
}

// 获取单条数据
- (HTDownloadModel *)getModelWithUrl:(NSString *)url
{
    return [self getModelWithOption:HTDBGetDateOptionModelWithUrl url:url];
}

// 获取第一条等待的数据
- (HTDownloadModel *)getWaitingModel
{
    return [self getModelWithOption:HTDBGetDateOptionWaitingModel url:nil];
}

// 获取最后一条正在下载的数据
- (HTDownloadModel *)getLastDownloadingModel
{
    return [self getModelWithOption:HTDBGetDateOptionLastDownloadingModel url:nil];
}

// 获取所有数据
- (NSArray<HTDownloadModel *> *)getAllCacheData
{
    return [self getDateWithOption:HTDBGetDateOptionAllCacheData];
}

// 根据lastStateTime倒叙获取所有正在下载的数据
- (NSArray<HTDownloadModel *> *)getAllDownloadingData
{
    return [self getDateWithOption:HTDBGetDateOptionAllDownloadingData];
}

// 获取所有下载完成的数据
- (NSArray<HTDownloadModel *> *)getAllDownloadedData
{
    return [self getDateWithOption:HTDBGetDateOptionAllDownloadedData];
}

// 获取所有未下载完成的数据
- (NSArray<HTDownloadModel *> *)getAllUnDownloadedData
{
    return [self getDateWithOption:HTDBGetDateOptionAllUnDownloadedData];
}

// 获取所有等待下载的数据
- (NSArray<HTDownloadModel *> *)getAllWaitingData
{
   return [self getDateWithOption:HTDBGetDateOptionAllWaitingData];
}

// 获取单条数据
- (HTDownloadModel *)getModelWithOption:(HTDBGetDateOption)option url:(NSString *)url
{
    __block HTDownloadModel *model = nil;
    
    [_dbQueue inDatabase:^(HTDatabase *db) {
        HTResultSet *resultSet;
        switch (option) {
            case HTDBGetDateOptionModelWithUrl:
                resultSet = [db executeQuery:@"SELECT * FROM t_videoCaches WHERE url = ?", url];
                break;
                
            case HTDBGetDateOptionWaitingModel:
                resultSet = [db executeQuery:@"SELECT * FROM t_videoCaches WHERE state = ? order by lastStateTime asc limit 0,1", [NSNumber numberWithInteger:HTDownloadStateWaiting]];
                break;
                
            case HTDBGetDateOptionLastDownloadingModel:
                resultSet = [db executeQuery:@"SELECT * FROM t_videoCaches WHERE state = ? order by lastStateTime desc limit 0,1", [NSNumber numberWithInteger:HTDownloadStateDownloading]];
                break;
                
            default:
                break;
        }
        
        while ([resultSet next]) {
            model = [[HTDownloadModel alloc] initWithFMResultSet:resultSet];
        }
    }];
    
    return model;
}

// 获取数据集合
- (NSArray<HTDownloadModel *> *)getDateWithOption:(HTDBGetDateOption)option
{
    __block NSArray<HTDownloadModel *> *array = nil;
    
    [_dbQueue inDatabase:^(HTDatabase *db) {
        HTResultSet *resultSet;
        switch (option) {
            case HTDBGetDateOptionAllCacheData:
                resultSet = [db executeQuery:@"SELECT * FROM t_videoCaches"];
                break;
                
            case HTDBGetDateOptionAllDownloadingData:
                resultSet = [db executeQuery:@"SELECT * FROM t_videoCaches WHERE state = ? order by lastStateTime desc", [NSNumber numberWithInteger:HTDownloadStateDownloading]];
                break;
                
            case HTDBGetDateOptionAllDownloadedData:
                resultSet = [db executeQuery:@"SELECT * FROM t_videoCaches WHERE state = ?", [NSNumber numberWithInteger:HTDownloadStateFinish]];
                break;
                
            case HTDBGetDateOptionAllUnDownloadedData:
                resultSet = [db executeQuery:@"SELECT * FROM t_videoCaches WHERE state != ?", [NSNumber numberWithInteger:HTDownloadStateFinish]];
                break;
                
            case HTDBGetDateOptionAllWaitingData:
                resultSet = [db executeQuery:@"SELECT * FROM t_videoCaches WHERE state = ?", [NSNumber numberWithInteger:HTDownloadStateWaiting]];
                break;
                
            default:
                break;
        }
        
        NSMutableArray *tmpArr = [NSMutableArray array];
        while ([resultSet next]) {
            [tmpArr addObject:[[HTDownloadModel alloc] initWithFMResultSet:resultSet]];
        }
        array = tmpArr;
    }];
    
    return array;
}

// 更新数据
- (void)updateWithModel:(HTDownloadModel *)model option:(HTDBUpdateOption)option
{
    [_dbQueue inDatabase:^(HTDatabase *db) {
        if (option & HTDBUpdateOptionState) {
            [self postStateChangeNotificationWithFMDatabase:db model:model];
            [db executeUpdate:@"UPDATE t_videoCaches SET state = ? WHERE url = ?", [NSNumber numberWithInteger:model.state], model.url];
        }
        if (option & HTDBUpdateOptionLastStateTime) {
            [db executeUpdate:@"UPDATE t_videoCaches SET lastStateTime = ? WHERE url = ?", [NSNumber numberWithInteger:[HTToolBox getTimeStampWithDate:[NSDate date]]], model.url];
        }
        if (option & HTDBUpdateOptionResumeData) {
            [db executeUpdate:@"UPDATE t_videoCaches SET resumeData = ? WHERE url = ?", model.resumeData, model.url];
        }
        if (option & HTDBUpdateOptionProgressData) {
            [db executeUpdate:@"UPDATE t_videoCaches SET tmpFileSize = ?, totalFileSize = ?, progress = ?, lastSpeedTime = ?, intervalFileSize = ? WHERE url = ?", [NSNumber numberWithInteger:model.tmpFileSize], [NSNumber numberWithFloat:model.totalFileSize], [NSNumber numberWithFloat:model.progress], [NSNumber numberWithDouble:model.lastSpeedTime], [NSNumber numberWithInteger:model.intervalFileSize], model.url];
        }
        if (option & HTDBUpdateOptionAllParam) {
            [self postStateChangeNotificationWithFMDatabase:db model:model];
            [db executeUpdate:@"UPDATE t_videoCaches SET resumeData = ?, totalFileSize = ?, tmpFileSize = ?, progress = ?, state = ?, lastSpeedTime = ?, intervalFileSize = ?, lastStateTime = ? WHERE url = ?", model.resumeData, [NSNumber numberWithInteger:model.totalFileSize], [NSNumber numberWithInteger:model.tmpFileSize], [NSNumber numberWithFloat:model.progress], [NSNumber numberWithInteger:model.state], [NSNumber numberWithDouble:model.lastSpeedTime], [NSNumber numberWithInteger:model.intervalFileSize], [NSNumber numberWithInteger:[HTToolBox getTimeStampWithDate:[NSDate date]]], model.url];
        }
    }];
}

// 状态变更通知
- (void)postStateChangeNotificationWithFMDatabase:(HTDatabase *)db model:(HTDownloadModel *)model
{
    // 原状态
    NSInteger oldState = [db intForQuery:@"SELECT state FROM t_videoCaches WHERE url = ?", model.url];
    if (oldState != model.state && oldState != HTDownloadStateFinish) {
        // 状态变更通知
        [[NSNotificationCenter defaultCenter] postNotificationName:HTDownloadStateChangeNotification object:model];
        
    }
}

// 删除数据
- (void)deleteModelWithUrl:(NSString *)url
{
    [_dbQueue inDatabase:^(HTDatabase *db) {
        BOOL result = [db executeUpdate:@"DELETE FROM t_videoCaches WHERE url = ?", url];
        if (result) {
//            HWLog(@"删除成功：%@", url);
        }else {
//            HWLog(@"删除失败：%@", url);
        }
    }];
}

@end
