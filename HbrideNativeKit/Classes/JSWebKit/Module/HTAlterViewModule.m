//
//  HTAlterViewModule.m
//  HybridForiOS
//
//  Created by wjx on 2020/4/26.
//  Copyright © 2020 WJX. All rights reserved.
//

#import "HTAlterViewModule.h"
#import "HTAlterView.h"
@implementation HTAlterViewModule

@synthesize htInstance;

- (BOOL)registerBridge:(WKWebViewJavascriptBridge *)bridge{
    
    [bridge registerHandler:@"alter" handler:^(id  _Nullable data, HTJBResponseCallback  _Nullable responseCallback) {
        
        NSArray *allkey = [(NSDictionary*)data allKeys];
        
        if (allkey.count<4||allkey.count>4) {
            
            responseCallback(@{@"code":@"errr",@"data":@"参数有误"});
        }
        NSString *title ;
        NSString *content ;
        NSString *cancel;
        NSString *sure ;
        
        for (NSString *key in allkey) {
            if ([key isEqualToString:@"title"]) {
                if ([data[@"title"] isEqualToString:@""]) {
                    responseCallback(@{@"code":@"errr",@"data":@"参数title不能为空"});
                }
                title = data[@"title"];
            }else if ([key isEqualToString:@"content"]){
                if ([data[@"content"] isEqualToString:@""]) {
                    responseCallback(@{@"code":@"errr",@"data":@"参数content不能为空"});
                }
                content = data[@"content"];
            }else if ([key isEqualToString:@"cancel"]){
                if ([data[@"cancel"] isEqualToString:@""]) {
                    cancel = @"cancel";// responseCallback(@{@"code":@"errr",@"data":@"参数cancel不能为空"});
                }else {
                    cancel = data[@"cancel"];
                }
                
            }else if ([key isEqualToString:@"sure"]){
                if ([data[@"sure"] isEqualToString:@""]) {
                    sure = @"sure";// responseCallback(@{@"code":@"errr",@"data":@"参数cancel不能为空"});
                }else {
                    sure = data[@"sure"];
                }
                
            }
            
        }
        
         HTAlterView *lll=[[HTAlterView alloc] alterViewWithTitle:title content:content cancel:cancel sure:sure cancelBtClcik:^{
                //取消按钮点击事件
                
                responseCallback(@{@"index":@(0)});
                
            } sureBtClcik:^{
                //确定按钮点击事件
                responseCallback(@{@"index":@(1)});
            }];
             [lll show];
        
    }];
    
    
    
  return YES;
}

@end

