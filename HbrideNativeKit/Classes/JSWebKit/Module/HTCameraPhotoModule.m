//
//  HTCameraPhotoModule.m
//  HybridForiOS
//
//  Created by wjx on 2020/3/16.
//  Copyright © 2020 WJX. All rights reserved.
//

#import "HTCameraPhotoModule.h"
#import "ZZQAvatarPicker.h"
#import "HTUploadTask.h"
#import "HTFileManager.h"
#import "HTFileStreamSeparation.h"
#import "HTFileUploadManager.h"
#import "HTImageUploadManager.h"
#import "HTImageUploadTask.h"
#import "NSDictionary+NilSafe.h"
#define Kboundary @"----WebKitFormBoundaryjv0UfA04ED44AhWx"
#define KNewLine [@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]
@interface HTCameraPhotoModule()<NSURLSessionDataDelegate>
@property (nonatomic, copy) NSString *statusText;
@property (nonatomic, strong)HTUploadTask *uploadTask;
@property (nonatomic) HTJBResponseCallback responseCallback;
@property (nonatomic, strong) WKWebViewJavascriptBridge *bridge;
/** 注释 */
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *htsign;
@end



@implementation HTCameraPhotoModule

@synthesize htInstance;

- (BOOL)registerBridge:(nonnull WKWebViewJavascriptBridge *)bridge {
    
    [bridge registerHandler:@"openCameraPhoto" handler:^(id  _Nullable data, HTJBResponseCallback  _Nullable responseCallback) {
        self.responseCallback = responseCallback;
        self.bridge = bridge;
        if ([data[@"token"] isEqualToString:@""] || [data[@"token"] isKindOfClass:[NSNull class]]) {
            responseCallback(@{@"result":@"error",@"data":@"参数有误"});
            
        }
        if ([data[@"sign"] isEqualToString:@""] || [data[@"sign"] isKindOfClass:[NSNull class]]) {
            responseCallback(@{@"result":@"error",@"data":@"参数有误"});
            
        }
        
        self.token = data[@"token"];
        self.htsign = data[@"sign"];
        [ZZQAvatarPicker startSelectedblack:responseCallback compleiton:^(UIImage * _Nonnull image,NSURL *path) {
            
//        直接在本地代码里写好上传，然后把上传后的网络地址等数据返回给 H5。这样的好处是能做到后台上传，也能充分利用 iOS 平台的性能。
            [self uploadImage:path  image:image];
//            UIImage *originImage = [UIImage imageNamed:@"originImage.png"];
           
//     图片选择     把图片改成 Base64 编码的字符串，然后传递字符串到 H5 显示 缺点 图片过大对性能和内存都是很大消耗 可以考虑先压缩
        }];
    }];
    return YES;
}


- (void)uploadImage:(NSURL*)path image:(UIImage*)image{
    //处理上传文件
  
   NSString *fileFolder = [[HTFileManager cachesDir] stringByAppendingString:@"/image"];
          if (![HTFileManager isExistsAtPath:fileFolder]) {
              [HTFileManager createDirectoryAtPath:fileFolder];
          }
    NSString *originalPath = [path.absoluteString stringByReplacingOccurrencesOfString:@"file://" withString:@""];
          NSString *videoName = [NSString stringWithFormat:@"%@.png", [HTFileStreamSeparation fileKeyMD5WithPath:originalPath]];
          NSString *sandboxPath = [fileFolder stringByAppendingPathComponent:videoName];
          [HTFileManager moveItemAtPath:originalPath toPath:sandboxPath overwrite:YES error:nil];
//    [self uploadData:sandboxPath];
    HTImageUploadTask *task = [[HTImageUploadManager shardUploadManager] createUploadTask:sandboxPath params:@{@"fileName":videoName,@"token":self.token,@"htsign":self.htsign} success:^(NSDictionary * _Nonnull value) {
        
        NSString *imageSource = [NSString stringWithFormat:@"data:image/jpg;base64,%@",[ UIImageJPEGRepresentation(image,1.0f) base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed]];
        
        self.responseCallback(@{@"result":@"success",@"id":value[@"result"],@"data":imageSource});
    } progress:^(float value) {
        
         [self.bridge callHandler:@"progress" data:@{@"progress":[NSString stringWithFormat:@"%.1f%%",value]}];
    } fail:^(NSError * _Nonnull error) {
        self.responseCallback(@{@"result":@"error",@"data":@"网络断开"});
    }];
    [task taskResume];
//   [[HTFileUploadManager shardUploadManager] createUploadTask:sandboxPath];
//      [task taskResume];
    
}



-(void)dealloc
{
    
}

@end
