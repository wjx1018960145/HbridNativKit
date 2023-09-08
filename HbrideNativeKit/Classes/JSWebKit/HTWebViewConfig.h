//
//  HTWebViewConfig.h
//  HybridForiOS
//
//  Created by wjx on 2020/3/3.
//  Copyright © 2020 WJX. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface HTWebViewConfig : NSObject
//单例
+ (instancetype)sharedInstance;
//是否启动白名单
@property (nonatomic, assign) BOOL enableWhiteList;
//白名单
@property (nonatomic, strong) NSMutableArray *whiteList;
@end


