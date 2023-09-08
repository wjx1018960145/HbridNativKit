//
//  HTNavigationController.m
//  HybridForiOS
//
//  Created by wjx on 2020/5/18.
//  Copyright © 2020 WJX. All rights reserved.
//

#import "HTNavigationController.h"
#import "HTTabBar.h"
#import "HTNavBar.h"
@interface HTNavigationController ()<UIGestureRecognizerDelegate>

@end
@interface HTNavigationController ()

@end

@implementation HTNavigationController
{
    BOOL _isForbidden;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBackPanGestureIsForbiddden:NO];
     self.navigationBar.translucent = NO;
    [HTNavBar setGlobalBarTintColor:[UIColor colorWithRed:249.0/256 green:249.0/256.0 blue:249.0/256 alpha:1]];
    [HTNavBar setGlobalTextColor:[UIColor blackColor] andFontSize:18.0f];
    
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    //更新状态栏风格
    [self setNeedsStatusBarAppearanceUpdate];
    
    
    // Do any additional setup after loading the view.
}

//返回状态栏风格
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)setupBackPanGestureIsForbiddden:(BOOL)isForBidden {
    _isForbidden = isForBidden;
    //设置手势代理
    UIGestureRecognizer *gesture = self.interactivePopGestureRecognizer;
    // 自定义手势 手势加在谁身上, 手势执行谁的什么方法
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:gesture.delegate action:NSSelectorFromString(@"handleNavigationTransition:")];
    //为控制器的容器视图
    [gesture.view addGestureRecognizer:panGesture];
    
    gesture.delaysTouchesBegan = YES;
    panGesture.delegate = self;
    
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    //需要过滤根控制器   如果根控制器也要返回手势有效, 就会造成假死状态
    if (self.childViewControllers.count == 1) {
        return NO;
    }
    if (_isForbidden) {
        return NO;
    }
    
    return NO;
    
}
#pragma mark - 重写父类方法拦截push方法
//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    //判断是否为第一层控制器
//    if (self.childViewControllers.count > 0) { //如果push进来的不是第一个控制器
//        UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [backButton setImage:[UIImage imageNamed:@"title_button_back"] forState:UIControlStateNormal];
//        [backButton addTarget:self action:@selector(leftBarButtonItemClicked) forControlEvents:UIControlEventTouchUpInside];
//        [backButton sizeToFit];
//        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//
//        //当push的时候 隐藏tabbar
//       //viewController.hidesBottomBarWhenPushed = YES;
//    }
//    //先设置leftItem  再push进去 之后会调用viewdidLoad  用意在于vc可以覆盖上面设置的方法
//    [super pushViewController:viewController animated:animated];
//}

- (void)leftBarButtonItemClicked
{
    [self popViewControllerAnimated:YES];
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    if (self = [super initWithRootViewController:rootViewController]) {
        [self setValue:[HTNavBar new] forKey:@"navigationBar"];
    }
    return self;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
