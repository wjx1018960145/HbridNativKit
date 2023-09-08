//
//  HTSDKInstance.m
//  HybridForiOS
//
//  Created by wjx on 2020/3/3.
//  Copyright © 2020 WJX. All rights reserved.
//

#import "HTSDKInstance.h"
#import "HTUtility.h"
#import "HTWebAppearance.h"
#import "WKWebViewJavascriptBridge.h"
#import "HTWebView.h"
#import "HTDefine.h"

#define HT_RENDER_TYPE_PLATFORM       @"platform"

NSString * const HTInstanceProgress = @"estimatedProgress";
@interface HTSDKInstance()<WKUIDelegate,WKNavigationDelegate>
@property (nonatomic, strong) HTWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;
//@property (nonatomic, strong) WKWebViewJavascriptBridge *jsBridge;
@end

@implementation HTSDKInstance

- (instancetype)init
{
   
    return [self initWithRenderType:HT_RENDER_TYPE_PLATFORM];;
}

- (instancetype)initWithRenderType:(NSString *)renderType{
    self = [super init];
    if (self) {
        if ([HTUtility isDarkSchemeSupportEnabled]) {
             self.schemeName = [HTUtility isSystemInDarkScheme] ? @"dark" : @"light";
        }else{
            self.schemeName = @"light";
        }
        
       
        self.viewController = [UIViewController init];
       
    }
    return self;
}

- (UIViewController*)createH5ViewControllerWithNebulaApp:(NSDictionary*)params {
    if (!params[@"url"]) {
        NSLog(@"创建失败url不能为空");
        return nil;
    }
    if ([params[@"nav"] isEqualToString:@"YES"]) {
        [self initNaviItem];
    }
        
        self.viewController = [[UIViewController alloc] init];
        [self initNaviItem];
        [self createBaseView];
        [self createBaseView];
        
    return _viewController;
}

- (void)initNaviItem {
    
    UIImage *backImage = [HTWebAppearance sharedAppearance].backItemImage;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:backImage style:UIBarButtonItemStylePlain target:self action:@selector(naviBackButtonClicked)];

    UIImage *closeImage = [HTWebAppearance sharedAppearance].closeItemImage;
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithImage:closeImage style:UIBarButtonItemStylePlain target:self action:@selector(closeButtonClicked)];
    self.viewController.navigationItem.leftBarButtonItems = @[backItem,closeItem];
}

- (void)createBaseView {
    self.viewController.view.backgroundColor = [UIColor whiteColor];
    [self.viewController.view addSubview:self.webView];
    [self.webView addSubview:self.progressView];
    [self.webView addObserver:self forKeyPath:HTInstanceProgress options:NSKeyValueObservingOptionNew context:nil];
    self.jsBridge = [WKWebViewJavascriptBridge bridgeForWebView:_webView];
//    [self.jsBridge setWebViewDelegate:<#(id)#>];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if (object == self.webView && [keyPath isEqualToString:HTInstanceProgress]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        [self.progressView setProgress:newprogress animated:YES];
        if (newprogress >= 1) {
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
            } completion:^(BOOL finished) {
                self.progressView.hidden = YES;
            }];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - WKNavigationDelegate
//开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation  API_AVAILABLE(ios(8.0)){
    NSLog(@"开始加载网页");
    //开始加载网页时展示出progressView
    self.progressView.hidden = NO;
}

//加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation  API_AVAILABLE(ios(8.0)){
    NSLog(@"加载完成");
    //加载完成后隐藏progressView
    
    [self.jsBridge callHandler:@"refreshData" data:nil responseCallback:^(id responseData) {
        NSLog(@"Refresh Data Done");
    }];
    
}

//加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error  API_AVAILABLE(ios(8.0)){
    NSLog(@"加载失败");
    //加载失败隐藏progressView
    self.progressView.hidden = YES;
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *URL = navigationAction.request.URL;
    NSString *scheme = [URL scheme];
    
    if ([scheme isEqualToString:@"tel"]) {
        NSString *resourceSpecifier = [URL resourceSpecifier];
        NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", resourceSpecifier];
        /// 防止iOS 10及其之后，拨打电话系统弹出框延迟出现
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
        });
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark - get & set
- (HTWebView *)webView {
    if (!_webView) {
       
        _webView = [[HTWebView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-[HTUtility getStatusBarHeight]-44)];
        if (self.addionalHeader) {
            _webView.additionHeader = self.addionalHeader;
        }
    }
    return _webView;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, [HTUtility getStatusBarHeight]+44, CGRectGetWidth(self.viewController.view.frame), 2)];
        [_progressView setTintColor:[HTWebAppearance sharedAppearance].progressColor];
        _progressView.progress = 0.4;
        _progressView.backgroundColor = [UIColor whiteColor];
    }
    return _progressView;
}

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:HTInstanceProgress];
}

#pragma mark - click method
- (void)naviBackButtonClicked {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    } else {
        [self closeButtonClicked];
    }
}

- (void)closeButtonClicked {
    [self.viewController.view resignFirstResponder];
    if (self.viewController.navigationController
        && self.viewController.navigationController.viewControllers.count > 1) {
        [self.viewController.navigationController popViewControllerAnimated:YES];
    } else {
        [self.viewController dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
