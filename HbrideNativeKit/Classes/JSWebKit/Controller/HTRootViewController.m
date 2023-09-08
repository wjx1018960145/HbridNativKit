//
//  HTRootViewController.m
//  HybridForiOS
//
//  Created by wjx on 2020/3/10.
//  Copyright © 2020 WJX. All rights reserved.
//

#import "HTRootViewController.h"
#import "HTBaseViewController.h"
#import "HTDefine.h"
typedef void(^OperationBlock)(void);
@interface HTRootViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSMutableArray *operationArray;
@property (nonatomic, assign) BOOL operationInProcess;
@end

@implementation HTRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.interactivePopGestureRecognizer.delegate = self;
    // Do any additional setup after loading the view.
}

- (id)initWithSourceURL:(NSURL *)sourceURL
{
    HTBaseViewController *baseViewController = [[HTBaseViewController alloc]initWithSourceURL:sourceURL];
    
    
    return [super initWithRootViewController:baseViewController];
}
//reduced pop/push animation in iOS 7
- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    return [super popViewControllerAnimated:animated];
}

- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    return [super popToViewController:viewController animated:animated];
}

- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated
{
    return [super popToRootViewControllerAnimated:animated];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    return [super pushViewController:viewController animated:animated];
}

- (void)addOperationBlock:(OperationBlock)operation
{
    
    if (self.operationInProcess && [self.operationArray count]) {
        [self.operationArray addObject:[operation copy]];
    } else {
        _operationInProcess = YES;
        operation();
    }
}

#pragma mark- UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([self.viewControllers count] == 1) {
        return NO;
    }
    return YES;
}

- (NSMutableArray *)operationArray
{
    if (nil == _operationArray) {
        _operationArray = [[NSMutableArray alloc] init];
    }
    
    return _operationArray;
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
