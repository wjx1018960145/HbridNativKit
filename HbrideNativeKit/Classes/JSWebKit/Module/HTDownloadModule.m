//
//  HTDownloadModule.m
//  HybridForiOS
//
//  Created by wjx on 2020/3/23.
//  Copyright © 2020 WJX. All rights reserved.
//

#import "HTDownloadModule.h"
#import "HTDownloadModel.h"
#import "HTDataBaseManager.h"

@interface HTDownloadModule()

@property (nonatomic, strong)WKWebViewJavascriptBridge *bridge;

@end

@implementation HTDownloadModule

@synthesize htInstance;

- (BOOL)registerBridge:(nonnull WKWebViewJavascriptBridge *)bridge {
    
    [self addNotification];
    self.bridge = bridge;
    [bridge registerHandler:@"download" handler:^(id  _Nullable data, HTJBResponseCallback  _Nullable responseCallback) {
        // 添加通知
           
        // 模拟网络数据
        NSArray *testData = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"testData.plist" ofType:nil]];
        NSDictionary *dic =testData[0];
        HTDownloadModel *mode = [[HTDownloadModel alloc] init];
        mode.url =@"http://3g.163.com/links/4636";
        mode.fileName = dic[@"fileName"];
         [[HTDownloadManager shareManager] startDownloadTask:mode];
        
        // 转模型
//        self.dataSource = [HTDownloadModel mj_objectArrayWithKeyValuesArray:testData];
        
        
        responseCallback(@{});
    }];
    
    return YES;
}
- (void)addNotification
{
    // 进度通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadProgress:) name:HTDownloadProgressNotification object:nil];
    // 状态改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadStateChange:) name:HTDownloadStateChangeNotification object:nil];
}
#pragma mark - HWDownloadNotification
// 正在下载，进度回调
- (void)downLoadProgress:(NSNotification *)notification
{
    HTDownloadModel *downloadModel = notification.object;
    NSLog(@"%.2f",downloadModel.progress);
//    [self.bridge callHandler:@"downloadprogress" data:@{@"progress":[NSString stringWithFormat:@"%.2f",downloadModel.progress]}];
    
    
    

//    [self.dataSource enumerateObjectsUsingBlock:^(HWDownloadModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
//        if ([model.url isEqualToString:downloadModel.url]) {
//            // 主线程更新cell进度
//            dispatch_async(dispatch_get_main_queue(), ^{
////                HWHomeCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
////                [cell updateViewWithModel:downloadModel];
//            });
//
//            *stop = YES;
//        }
//    }];
}

// 状态改变
- (void)downLoadStateChange:(NSNotification *)notification
{
    HTDownloadModel *downloadModel = notification.object;
    if (downloadModel.state == HTDownloadStateFinish) {
        [self.bridge callHandler:@"downLoadState" data:@{@"state":[NSString stringWithFormat:@"%ld",(long)downloadModel.state]}];
    }
    
    
//    [self.dataSource enumerateObjectsUsingBlock:^(HWDownloadModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
//        if ([model.url isEqualToString:downloadModel.url]) {
//            // 更新数据源
//            self.dataSource[idx] = downloadModel;
//
//            // 主线程刷新cell
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
//            });
//
//            *stop = YES;
//        }
//    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
