//
//  HTWebView.m
//  HybridForiOS
//
//  Created by wjx on 2020/3/3.
//  Copyright © 2020 WJX. All rights reserved.
//

#import "HTWebView.h"
#import "HTWebViewConfig.h"

@implementation HTWebView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (WKNavigation *)loadRequest:(NSURLRequest *)request {
    NSURL *url = request.URL;
    if (![HTWebViewConfig sharedInstance].enableWhiteList) {
        return [self loadRequest:request additionHeader:self.additionHeader];
    }
    //白名单
    for (NSString *host in [HTWebViewConfig sharedInstance].whiteList) {
        if (![self urlMatch:url.absoluteString host:host]) {
            continue;
        }
        return [self loadRequest:request additionHeader:self.additionHeader];
    }
    return nil;
}

- (BOOL)urlMatch:(NSString *)urlString host:(NSString *)host {
    return [urlString containsString:host];
}

- (WKNavigation *)loadRequest:(NSURLRequest *)request additionHeader:(NSDictionary *)additionHeader {
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:request.URL];
    for (NSString *key in additionHeader.allKeys) {
        NSString *value = additionHeader[key];
        [urlRequest setValue:value forHTTPHeaderField:key];
    }
    return [super loadRequest:urlRequest];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
