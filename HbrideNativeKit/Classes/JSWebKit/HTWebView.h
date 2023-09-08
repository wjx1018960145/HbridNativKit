//
//  HTWebView.h
//  HybridForiOS
//
//  Created by wjx on 2020/3/3.
//  Copyright © 2020 WJX. All rights reserved.
//

#import <WebKit/WebKit.h>


NS_ASSUME_NONNULL_BEGIN
@interface HTWebView : WKWebView
//传递给web页面的请求header
@property (nonatomic, strong) NSDictionary *additionHeader;

@end

NS_ASSUME_NONNULL_END
