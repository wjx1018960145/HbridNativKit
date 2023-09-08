//
//  HTH5ViewController.m
//  HybridForiOS
//
//  Created by wjx on 2020/3/3.
//  Copyright © 2020 WJX. All rights reserved.
//

#import "HTH5ViewController.h"
#import "HTWebView.h"
#import "HTBridgeManager.h"
#import "HTWebAppearance.h"
#import "HTSDKManager.h"
#import "HTUtility.h"
#import "HTLog.h"
#import "HTDefine.h"
#import "HTRefresh.h"
#import "NSURLProtocol+WebKitSupport.h"
#import "NSURLRequest+HTImageHttps.h"
#import <CommonCrypto/CommonDigest.h>
static NSString* lastPageInfoLock = @"";
static NSDictionary* lastPageInfo = nil;

NSString * const HTWebViewKeyEstimateProgress = @"estimatedProgress";

@interface HTH5ViewController ()<WKUIDelegate,WKNavigationDelegate>
//@property (nonatomic, strong) HTWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation HTH5ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    NSLog(@"%@",[HTBridgeManager currentViewController]);
    [[HTSDKManager bridgeMgr] registerJavaScriptHandler:self.jsBridge ids:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [NSURLProtocol wk_unregisterScheme:@"file"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
     [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:@"https"];
//    [NSURLProtocol wk_registerScheme:@"file"];
    NSSet* types = [NSSet setWithArray:@[WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache]];
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:types modifiedSince:[NSDate dateWithTimeIntervalSince1970:0] completionHandler:^{}];
       [self createBaseView];
       [self registerJsBridge];
    
    

    
    // Do any additional setup after loading the view.
   
    //注册scheme
   
}

#pragma mark - wkwebview信任https接口
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        NSURLCredential *card = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential, card);
    }
}

- (void)createBaseView {
      
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
    [self.webView addSubview:self.progressView];
    
   
    
}

- (void)registerJsBridge {
    self.jsBridge = [WKWebViewJavascriptBridge bridgeForWebView:self.webView];
//    [self.jsBridge setWebViewDelegate:self];
    [[HTSDKManager bridgeMgr] registerJavaScriptHandler:self.jsBridge ids:self];
    
   
}

- (void)pushDelegate:(id)ids webView:(nonnull viewLoadSuccess)webView{
     [self.webView addObserver:ids forKeyPath:HTWebViewKeyEstimateProgress options:NSKeyValueObservingOptionNew context:nil];
    [self.jsBridge setWebViewDelegate:ids];
    
    [[HTSDKManager bridgeMgr] registerJavaScriptHandlerName:NSStringFromClass([ids class]) viewController:ids];
}

- (void)initNaviItem {
    
    UIImage *backImage = [HTWebAppearance sharedAppearance].backItemImage;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:backImage style:UIBarButtonItemStylePlain target:self action:@selector(naviBackButtonClicked)];

    UIImage *closeImage = [HTWebAppearance sharedAppearance].closeItemImage;
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithImage:closeImage style:UIBarButtonItemStylePlain target:self action:@selector(closeButtonClicked)];
    self.navigationItem.leftBarButtonItems = @[backItem,closeItem];
    UIImage *rootbackImage = [HTWebAppearance sharedAppearance].rootCloseItemImage;
       UIBarButtonItem *rootBackItem = [[UIBarButtonItem alloc] initWithImage:rootbackImage style:UIBarButtonItemStylePlain target:self action:@selector(rootBack)];
       self.navigationItem.rightBarButtonItems = @[rootBackItem];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if (object == self.webView && [keyPath isEqualToString:HTWebViewKeyEstimateProgress]) {
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

// 网页加载请求
- (void)loadRequest:(NSURLRequest *)request {
    
     [self.webView loadRequest:request];
    if(self.onCreate){
        self.onCreate(self.webView);
    }
    
}

// 网页加载网页URL
- (void)loadURL:(NSURL *)url {
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    if(self.onCreate){
           self.onCreate(self.webView);
       }
}

// 加载 Html 字符串
- (void)loadHTMLString:(NSString *)htmlString baseURL:(nullable NSURL *)baseURL {
    [self.webView loadHTMLString:htmlString baseURL:baseURL];
    
    if(self.onCreate){
           self.onCreate(self.webView);
       }
    
//     NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<img\\ssrc[^>]*/>" options:NSRegularExpressionAllowCommentsAndWhitespace error:nil];
//      NSArray *result = [regex matchesInString:htmlString options:NSMatchingReportCompletion range:NSMakeRange(0, htmlString.length)];
//
//      NSMutableDictionary *urlDicts = [[NSMutableDictionary alloc] init];
//    //  NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"tmp"];
//        NSString *docPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"badge"];
//    BOOL bo = [[NSFileManager defaultManager] createDirectoryAtPath:docPath withIntermediateDirectories:YES attributes:nil error:nil];
//
//
//
//    for (NSTextCheckingResult *item in result) {
//        NSString *imgHtml = [htmlString substringWithRange:[item rangeAtIndex:0]];
//
//        NSArray *tmpArray = nil;
//        if ([imgHtml rangeOfString:@"src=\""].location != NSNotFound) {
//          tmpArray = [imgHtml componentsSeparatedByString:@"src=\""];
//        } else if ([imgHtml rangeOfString:@"src="].location != NSNotFound) {
//          tmpArray = [imgHtml componentsSeparatedByString:@"src="];
//        }
//
//        if (tmpArray.count >= 2) {
//          NSString *src = tmpArray[1];
//
//          NSUInteger loc = [src rangeOfString:@"\""].location;
//          if (loc != NSNotFound) {
//            src = [src substringToIndex:loc];
//
//            NSLog(@"正确解析出来的SRC为：%@", src);
//            if (src.length > 0) {
//              NSString *localPath = [docPath stringByAppendingPathComponent:[self md5:src]];
//    //            BOOL bo = [[NSFileManager defaultManager] createDirectoryAtPath:localPath withIntermediateDirectories:YES attributes:nil error:nil];
//              // 先将链接取个本地名字，且获取完整路径
//              [urlDicts setObject:localPath forKey:src];
//            }
//          }
//        }
//      }
    
    
}

- (NSString *)md5:(NSString *)sourceContent {
  if (self == nil || [sourceContent length] == 0) {
    return nil;
  }
  
  unsigned char digest[CC_MD5_DIGEST_LENGTH], i;
  CC_MD5([sourceContent UTF8String], (int)[sourceContent lengthOfBytesUsingEncoding:NSUTF8StringEncoding], digest);
  NSMutableString *ms = [NSMutableString string];
  
  for (i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
    [ms appendFormat:@"%02x", (int)(digest[i])];
  }
  
  return [ms copy];
}

- (void)renderWithHtmlString:(NSString*)htmlString url:(NSURL *)url options:(NSDictionary *)options data:(id)data {
    if (!url) {
        HTLogError(@"Url must be passed if you use renderWithURL");
        return;
    }
    HTLogInfo(@"pageid: %@ renderWithURL: %@", @"", url.absoluteString);
    
    @synchronized (lastPageInfoLock) {
           lastPageInfo = @{@"pageId": [@"" copy], @"url": [url absoluteString] ?: @""};
       }
    
    [self.webView loadHTMLString:htmlString baseURL:url];
    
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
    [self.view resignFirstResponder];
    if (self.navigationController
        && self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)rootBack {
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - WKNavigationDelegate
//开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation  API_AVAILABLE(ios(8.0)){
    NSLog(@"开始加载网页");
    //开始加载网页时展示出progressView
    if(self.renderFinish){
        self.renderFinish(self.webView);
    }
    self.progressView.hidden = NO;
}

//加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation  API_AVAILABLE(ios(8.0)){
    NSLog(@"加载完成");
    //加载完成后隐藏progressView
    [self.jsBridge callHandler:@"init" data:self.data responseCallback:^(id responseData) {
        NSLog(@"Refresh Data Done%@",responseData);
    }];
}

//加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error  API_AVAILABLE(ios(8.0)){
    NSLog(@"加载失败");
    //加载失败隐藏progressView
    if (self.onFailed) {
         self.onFailed(error);
    }
   
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
        
//        if (se) {
//            <#statements#>
//        }
//        if (self.shouldPullDownToRefresh ise) {
//            //如果你导入的MJRefresh库是最新的库，就用下面的方法创建下拉刷新和上拉加载事件
           
        
//
//        }
    }
    return _webView;
}


- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 1, CGRectGetWidth(self.view.frame), 2)];
        [_progressView setTintColor:[HTWebAppearance sharedAppearance].progressColor];
        _progressView.progress = 0.4;
        _progressView.backgroundColor = [UIColor whiteColor];
    }
    return _progressView;
}

- (void)dealloc {
//    [self.webView removeObserver:self forKeyPath:HTWebViewKeyEstimateProgress];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
