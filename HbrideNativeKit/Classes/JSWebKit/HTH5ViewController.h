//
//  HTH5ViewController.h
//  HybridForiOS
//
//  Created by wjx on 2020/3/3.
//  Copyright © 2020 WJX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTBridgeManager.h"
#import "WKWebViewJavascriptBridge.h"
#import "HTWebView.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^viewLoadSuccess)(UIView *webview);
@interface HTH5ViewController : UIViewController

//@property (nonatomic, strong) HTBridgeManager *bridgeManager;
@property (nonatomic, strong) WKWebViewJavascriptBridge *jsBridge;
@property (nonatomic, strong) HTWebView *webView;
@property (nonatomic, strong) NSDictionary *addionalHeader;
@property (nonatomic, strong) id data;
@property (nonatomic, strong) NSString *title;
//@property (nonatomic, assign) BOOL showNav;
@property (nonatomic,strong) NSString *showNav;
/// 需要支持下来刷新 defalut is NO
@property (nonatomic, readwrite, copy) NSString *shouldPullDownToRefresh;
/// 需要支持上拉加载 defalut is NO
@property (nonatomic, readwrite, copy) NSString *shouldPullUpToLoadMore;

- (void)initNaviItem;
- (void)rootBack;
- (void)pushDelegate:(id)ids webView:(viewLoadSuccess)webView;

// 网页加载请求
- (void)loadRequest:(NSURLRequest *)request;

// 网页加载网页URL
- (void)loadURL:(NSURL *)url;

// 加载 Html 字符串
- (void)loadHTMLString:(NSString *)htmlString baseURL:(nullable NSURL *)baseURL;

- (void)renderWithHtmlString:(NSString*)htmlString url:(NSURL *)url options:(NSDictionary *)options data:(id)data;

/**
 *  The callback triggered when the instance finishes creating the body.
 *
 *  @return A block that takes a UIView argument, which is the root view
 **/
@property (nonatomic, copy) void (^onCreate)(UIView *);

/**
 *  The callback triggered when the root container's frame has changed.
 *
 *  @return A block that takes a UIView argument, which is the root view
 **/
@property (nonatomic, copy) void (^onLayoutChange)(UIView *);

/**
 *  The callback triggered when the instance finishes rendering.
 *
 *  @return A block that takes a UIView argument, which is the root view
 **/
@property (nonatomic, copy) void (^renderFinish)(UIView *);

/**
 *  The callback triggered when the instance finishes refreshing weex view.
 *
 *  @return A block that takes a UIView argument, which is the root view
 **/
@property (nonatomic, copy) void (^refreshFinish)(UIView *);

/**
 *  The callback triggered when the instance fails to render.
 *
 *  @return A block that takes a NSError argument, which is the error occured
 **/
@property (nonatomic, copy) void (^onFailed)(NSError *error);

/**
 *  The callback triggered when the instacne executes scrolling .
 *
 *  @return A block that takes a CGPoint argument, which is content offset of the scroller
 **/
@property (nonatomic, copy) void (^onScroll)(CGPoint contentOffset);

/**
 * the callback to be run repeatedly while the instance is rendering.
 *
 * @return A block that takes a CGRect argument, which is the rect rendered
 **/
@property (nonatomic, copy) void (^onRenderProgress)(CGRect renderRect);

/**
 *  the frame of current instance.
 **/
@property (nonatomic, assign) CGRect frame;

@end

NS_ASSUME_NONNULL_END
