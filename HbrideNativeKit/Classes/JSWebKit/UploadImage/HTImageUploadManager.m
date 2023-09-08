//
//  HTImageUploadManager.m
//  HybridForiOS
//
//  Created by wjx on 2020/4/22.
//  Copyright © 2020 WJX. All rights reserved.
//

#import "HTImageUploadManager.h"
#import "HTImageUploadTask.h"
@interface HTImageUploadManager()
@property (nonatomic,assign)NSInteger uploadMaxNum;

@property (nonatomic,strong)NSURL *url;
@property (nonatomic,strong)NSMutableURLRequest *request;
@property (nonatomic,copy)Success successBlock;//上传成功的回调block
@property (nonatomic,copy)Fail failBlock;//上传失败的回调block
@property (nonatomic,copy)Progress progressBlock;//上传进度的回调block
@end

@implementation HTImageUploadManager

static HTImageUploadManager * _instance;

+ (instancetype)shardUploadManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        [_instance registeNotification];
        
//        [_instance defaultsTask];
        
    });
    return _instance;
}
- (void)config:(NSMutableURLRequest * _Nonnull)request {
    if (!request.URL) {
           NSLog(@"request缺少URL");
       }
     
       self.url = request.URL;
       self.request = request;
    
}

- (HTImageUploadTask *_Nullable)createUploadTask:(NSString *_Nonnull)filePath params:(nonnull NSDictionary *)params success:(nonnull Success)success progress:(nonnull Progress)progress fail:(nonnull Fail)fail{
   
    
    HTImageUploadTask *task = [[HTImageUploadTask alloc] init];
    task.filePath = filePath;
    
       task.param = [NSMutableDictionary dictionaryWithDictionary:@{
           @"fileName":params[@"fileName"],@"token":params[@"token"],@"htsign":params[@"htsign"]
       }];
    self.successBlock = success;
    self.progressBlock = progress;
    self.failBlock  = fail;
    task.url = self.url;
//    task.param
    return task;
}


#pragma mark - notification

- (void)registeNotification{
    
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(taskExeIng:) name:HTImageUploadTaskExeing object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(taskExeEnd:) name:HTImageUploadTaskExeEnd object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(taskExeError:) name:HTImageUploadTaskExeError object:nil];
    
}

- (void)taskExeIng:(NSNotification *)notification{
    NSDictionary *dic = notification.userInfo;
    if (self.progressBlock) {
         self.progressBlock([dic[@"value"] floatValue]);
    }
   
}

- (void)taskExeEnd:(NSNotification *)notification
{
    if (self.successBlock) {
        self.successBlock(notification.userInfo);
    }
}

- (void)taskExeError:(NSNotification *)notification
{
    if (self.failBlock) {
        self.failBlock(notification.userInfo[@"error"]);
    }
}


@end
