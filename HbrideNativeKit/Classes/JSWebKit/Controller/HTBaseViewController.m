//
//  HTBaseViewController.m
//  HybridForiOS
//
//  Created by wjx on 2020/3/9.
//  Copyright © 2020 WJX. All rights reserved.
//

#import "HTBaseViewController.h"

#import "HTUtility.h"
#import "HTDefine.h"
#import "HTRefresh.h"

@interface HTBaseViewController ()
@property (nonatomic, strong) UIView *weexView;
@property (nonatomic, strong) NSURL *sourceURL;
@end

@implementation HTBaseViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    if([self.showNav isEqualToString: @"YES"]){
        [self initNaviItem];
    }
    
    
    
    __weak typeof(self) weakSelf = self;
    if ([self.shouldPullDownToRefresh isEqualToString:@"YES"]) {
        self.webView.scrollView.ht_header = [HTRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf headerRefresh];
            
        }];
    }
    
    if ([self.shouldPullUpToLoadMore isEqualToString:@"YES"]) {
        self.webView.scrollView.ht_footer = [HTRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weakSelf loadMoreData];
        }];
    }
    //    self.showNav = self.showNav;
    self.view.backgroundColor = [UIColor whiteColor];
    //    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = self.title;
    [self _renderWithURL:_sourceURL];
    self.webView.frame = CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height-64);
    [self.view addSubview:self.webView];
    [self pushDelegate:self webView:^(UIView * _Nonnull webview) {
        
    }];
    
    //    [self loadRequest:[NSURLRequest requestWithURL:self.baseURL]];
//    [self loadHTMLString:self.appHtml baseURL:self.baseURL];
    
    // Do any additional setup after loading the view.
}


#pragma mark - 下拉刷新
- (void)headerRefresh{
    __weak typeof(self) weakSelf = self;
    [self.jsBridge callHandler:@"refresh" data:@{@"refresh":@"YES"} responseCallback:^(id  _Nullable responseData) {
        [weakSelf.webView.scrollView.ht_header endRefreshing];
    }];
}

#pragma mark - 上拉加载
- (void)loadMoreData{
    __weak typeof(self) weakSelf = self;
    [self.jsBridge callHandler:@"loadMore" data:@{@"loadMore":@"YES"} responseCallback:^(id  _Nullable responseData) {
        [weakSelf.webView.scrollView.ht_footer endRefreshing];
    }];
}


- (instancetype)initWithSourceURL:(NSURL *)sourceURL
{
    if ((self = [super init])) {
        self.sourceURL = sourceURL;
        self.hidesBottomBarWhenPushed = YES;
        
        [self _addObservers];
    }
    return self;
}

- (void)_renderWithURL:(NSURL *)sourceURL
{
    
}

- (void)refreshWeex
{
    [self _renderWithURL:_sourceURL];
}
- (void)_addObservers{
    
}

- (void)dealloc {
    self.showNav = nil;
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
