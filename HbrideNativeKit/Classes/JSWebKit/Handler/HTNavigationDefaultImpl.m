//
//  HTNavigationDefaultImpl.m
//  HybridForiOS
//
//  Created by wjx on 2020/3/9.
//  Copyright © 2020 WJX. All rights reserved.
//

#import "HTNavigationDefaultImpl.h"
#import "HTBaseViewController.h"
#import "HTImgLoaderProtocol.h"
#import "HTHandlerFactory.h"
#import "HTConvert.h"
#import "HTWebBridgeProtocol.h"
#import "NSDictionary+NilSafe.h"
@interface HTBarButton :UIButton

@property (nonatomic, strong) NSString *instanceId;
@property (nonatomic, strong) NSString *nodeRef;
@property (nonatomic)  HTNavigationItemPosition position;
@property (nonatomic, strong) NSString *closeSelf;
@property (nonatomic, strong) NSString *showTab;
@end

@implementation HTBarButton

@end


@implementation HTNavigationDefaultImpl

@synthesize htInstance;




- (id<HTImgLoaderProtocol>)imageLoader
{
    static id<HTImgLoaderProtocol> imageLoader;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageLoader = [HTHandlerFactory handlerForProtocol:@protocol(HTImgLoaderProtocol)];
    });
    return imageLoader;
}


-(void)setHtInstance:(UIViewController *)htInstance{
    self.htInstance = htInstance;
}

- (BOOL)registerBridge:(nonnull WKWebViewJavascriptBridge *)bridge {
    return YES;
}


- (void)clearNavigationItemWithParam:(nonnull NSDictionary *)param position:(HTNavigationItemPosition)position completion:(nullable HTNavigationResultBlock)block withContainer:(nonnull UIViewController *)container {
    switch (position) {
           case HTNavigationItemPositionLeft:
               [self clearNaviBarLeftItem:param completion:block withContainer:container];
               break;
           case HTNavigationItemPositionRight:
               [self clearNaviBarRightItem:param completion:block withContainer:container];
               break;
           case HTNavigationItemPositionMore:
               break;
           case HTNavigationItemPositionCenter:
               [self clearNaviBarTitle:param completion:block withContainer:container];
               break;
           default:
               break;
       }
}

- (nonnull id)navigationControllerOfContainer:(nonnull UIViewController *)container {
    return  container.navigationController;
}


- (void)popViewControllerWithParam:(nonnull NSDictionary *)param completion:(nullable HTNavigationResultBlock)block withContainer:(nonnull UIViewController *)container {
    BOOL animated = YES;
    id obj = [param objectForKey:@"animated"];
    if (obj) {
        animated = [HTConvert BOOL:obj];
        
    }
    
    [container.navigationController popViewControllerAnimated:animated];
    [self callback:block code:MSG_SUCCESS data:nil];
    
    
    
}

- (void)popToRootViewControllerWithParam:(NSDictionary *)param
                              completion:(HTNavigationResultBlock)block
                           withContainer:(UIViewController *)container
{
    BOOL animated = YES;
    NSString *obj = [[param objectForKey:@"animated"] lowercaseString];
    if (obj && [obj isEqualToString:@"false"]) {
        animated = NO;
    }
    
    [container.navigationController popToRootViewControllerAnimated:animated];
    [self callback:block code:MSG_SUCCESS data:nil];
}

- (void)pushViewControllerWithParam:(nonnull NSDictionary *)param completion:(nullable HTNavigationResultBlock)block withContainer:(nonnull UIViewController *)container {
    
    if (0 == [param count] || !param[@"url"] || !container) {
        [self callback:block code:MSG_PARAM_ERR data:nil];
        return;
    }
    
    
  
    if ([[param objectForKey:@"showTab"] isEqualToString:@"YES"]) {
        [self changRootView:param];
        
    }else{
        
        BOOL animated = YES;
            id animatedArgument = [param objectForKey:@"animated"];
            if (animatedArgument && [animatedArgument respondsToSelector:@selector(boolValue)]) {
                animated = [animatedArgument boolValue];
            }
            NSString *mainBundPath = [[NSBundle mainBundle] bundlePath];
            NSString *basePath = [NSString stringWithFormat:@"%@/www/html",mainBundPath];
            NSURL *baseUrl = [NSURL fileURLWithPath:basePath isDirectory:YES];
            NSString *htmlPath = [NSString stringWithFormat:@"%@/%@.html", basePath,param[@"url"]];
            NSString *htmlString = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
            
        //    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:param[@"url"] ofType:@"html"];
        //    NSString *appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
        //
        //    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath?htmlPath:param[@"url"]];
            HTBaseViewController *webVC = [[HTBaseViewController alloc] init];
            webVC.appHtml = htmlString;
            webVC.baseURL = baseUrl;
            webVC.hidesBottomBarWhenPushed = YES;
            NSString *isshow = [NSString stringWithFormat:@"%@",param[@"showNavforh5"]] ;
            NSString *shouldPullUpToLoadMore = [NSString stringWithFormat:@"%@",param[@"shouldPullUpToLoadMore"]];
            NSString *shouldPullDownToRefresh = [NSString stringWithFormat:@"%@",param[@"shouldPullDownToRefresh"]];
            NSLog(@"%@",isshow);
            webVC.data = param;
            webVC.showNav =isshow;
            
            webVC.title = param[@"param"][@"title"]?param[@"param"][@"title"]:@"";
            webVC.shouldPullDownToRefresh = shouldPullDownToRefresh;
            webVC.shouldPullUpToLoadMore = shouldPullUpToLoadMore;
            
        //    [webVC.view addSubview:container.webView];
            [container.navigationController pushViewController:webVC animated:animated];
    }
    
//    [self callback:block code:MSG_SUCCESS data:nil];
}

- (void)changRootView:(NSDictionary*)dic{
    
}

- (void)clearNaviBarLeftItem:(NSDictionary *) param completion:(HTNavigationResultBlock)block
                withContainer:(UIViewController *)container
{
    container.navigationItem.leftBarButtonItem = nil;
    
    [self callback:block code:MSG_SUCCESS data:nil];
}

- (void)clearNaviBarRightItem:(NSDictionary *) param completion:(HTNavigationResultBlock)block
                withContainer:(UIViewController *)container
{
    container.navigationItem.rightBarButtonItem = nil;
    
    [self callback:block code:MSG_SUCCESS data:nil];
}

- (void)clearNaviBarTitle:(NSDictionary *)param completion:(HTNavigationResultBlock)block
            withContainer:(UIViewController *)container
{
    container.navigationItem.title = @"";
    
    [self callback:block code:MSG_SUCCESS data:nil];
}

- (void)setNavigationBackgroundColor:(nonnull UIColor *)backgroundColor withContainer:(nonnull UIViewController *)container {
    if (backgroundColor) {
        container.navigationController.navigationBar.barTintColor = backgroundColor;
    }
}

- (void)setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated withContainer:(nonnull UIViewController *)container {
    if (![container isKindOfClass:[HTBaseViewController class]]) {
           return;
       }
       
       container.navigationController.navigationBarHidden = hidden;
}

- (void)setNavigationItemWithParam:(nonnull NSDictionary *)param position:(HTNavigationItemPosition)position completion:(nullable HTNavigationResultBlock)block withContainer:(nonnull UIViewController *)container {
    switch (position) {
        case HTNavigationItemPositionLeft:
            [self setNaviBarLeftItem:param completion:block withContainer:container];
            break;
        case HTNavigationItemPositionRight:
            [self setNaviBarRightItem:param completion:block withContainer:container];
            break;
        case HTNavigationItemPositionMore:
            break;
        case HTNavigationItemPositionCenter:
            [self setNaviBarTitle:param completion:block withContainer:container];
            break;
        default:
            break;
    }
}

- (void)setNaviBarRightItem:(NSDictionary *)param completion:(HTNavigationResultBlock)block
              withContainer:(UIViewController *)container
{
    if (0 == [param count]) {
        [self callback:block code:MSG_PARAM_ERR data:nil];
        return;
    }
    
    UIView *view = [self barButton:param position:HTNavigationItemPositionRight withContainer:container];
    
    if (!view) {
        [self callback:block code:MSG_FAILED data:nil];
        return;
    }
    
    container.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    
    [self callback:block code:MSG_SUCCESS data:nil];
}

- (void)setNaviBarLeftItem:(NSDictionary *)param completion:(HTNavigationResultBlock)block
              withContainer:(UIViewController *)container
{
    if (0 == [param count]) {
        [self callback:block code:MSG_PARAM_ERR data:nil];
        return;
    }
    
    UIView *view = [self barButton:param position:HTNavigationItemPositionLeft withContainer:container];
    
    if (!view) {
        [self callback:block code:MSG_FAILED data:nil];
        return;
    }
    
    container.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    
    [self callback:block code:MSG_SUCCESS data:nil];
}

- (void)setNaviBarTitle:(NSDictionary *)param completion:(HTNavigationResultBlock)block
          withContainer:(UIViewController *)container
{
    if (0 == [param count]) {
        [self callback:block code:MSG_PARAM_ERR data:nil];
        return;
    }
    
    container.navigationItem.title = param[@"title"];
    
    [self callback:block code:MSG_SUCCESS data:nil];;
}

- (UIView *)barButton:(NSDictionary *)param position:(HTNavigationItemPosition)position
        withContainer:(UIViewController *)container
{
    if (param[@"title"]) {
        NSString *title = param[@"title"];

        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:18]};
        CGSize size = [title boundingRectWithSize:CGSizeMake(70.0f, 18.0f) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        
        HTBarButton *button = [HTBarButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(0, 0, size.width, size.height);
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor]  forState:UIControlStateHighlighted];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(onClickBarButton:) forControlEvents:UIControlEventTouchUpInside];
        
        button.instanceId = param[@"instanceId"];
        button.nodeRef = param[@"nodeRef"];
        button.position = position;
        
        NSString *color = param[@"titleColor"];
        if (color) {
            [button setTitleColor:[HTConvert UIColor:color] forState:UIControlStateNormal];
            [button setTitleColor:[HTConvert UIColor:color] forState:UIControlStateHighlighted];
        }
        
        return button;
    }
    else if (param[@"icon"]) {
        NSString *icon = param[@"icon"];
        
        if (icon) {
            HTBarButton *button = [HTBarButton buttonWithType:UIButtonTypeRoundedRect];
            button.frame = CGRectMake(0, 0, 25, 25);
            button.instanceId = param[@"instanceId"];
            button.nodeRef = param[@"nodeRef"];
            button.position = position;
            [button addTarget:self action:@selector(onClickBarButton:) forControlEvents:UIControlEventTouchUpInside];
            
            [[self imageLoader] downloadImageWithURL:icon imageFrame:CGRectMake(0, 0, 25, 25) userInfo:@{@"instanceId":@""} completed:^(UIImage *image, NSError *error, BOOL finished) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [button setBackgroundImage:image forState:UIControlStateNormal];
                    [button setBackgroundImage:image forState:UIControlStateHighlighted];
                });
            }];
            
            return button;
        }
    }
    
    return nil;
}

- (void)onClickBarButton:(id)sender
{
    HTBarButton *button = (HTBarButton *)sender;
    if (button.instanceId) {
        if (button.nodeRef)
        {
//            [[WXSDKManager bridgeMgr] fireEvent:button.instanceId ref:button.nodeRef type:@"click" params:nil domChanges:nil] ;
        }
        else
        {
            NSString *eventType;
            switch (button.position) {
                case HTNavigationItemPositionLeft:
                    eventType = @"clickleftitem";
                    break;
                case HTNavigationItemPositionRight:
                    eventType = @"clickrightitem";
                    break;
                case HTNavigationItemPositionMore:
                    eventType = @"clickmoreitem";
                    break;
                default:
                    break;
            }
            
//           [[WXSDKManager bridgeMgr] fireEvent:button.instanceId ref:WX_SDK_ROOT_REF type:eventType params:nil domChanges:nil];
        }
    }
}

- (void)callback:(HTNavigationResultBlock)block code:(NSString *)code data:(NSDictionary *)reposonData
{
    if (block) {
        block(code, reposonData);
    }
}
@end
