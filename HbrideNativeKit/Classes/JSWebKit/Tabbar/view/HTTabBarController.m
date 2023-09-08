//
//  HTTabBarController.m
//  HybridForiOS
//
//  Created by wjx on 2020/5/18.
//  Copyright © 2020 WJX. All rights reserved.
//

#import "HTTabBarController.h"
#import "HTNavigationController.h"
#import "UIImage+WJXImage.h"
#import "HTTabBar.h"
#import "HTTabBarConfig.h"
#if  __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_10_0
#import "UITabBarItem+BadgeColor.h"
#endif
#define ISiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
@interface HTTabBarController ()<HTTabBarDelegate>
/** center button of place ( -1:none center button >=0:contain center button) */
@property(assign , nonatomic) NSInteger centerPlace;
/** Whether center button to bulge */
@property(assign , nonatomic,getter=is_bulge) BOOL bulge;
/** items */
@property (nonatomic,strong) NSMutableArray <UITabBarItem *>*items;
@end

@implementation HTTabBarController

{int tabBarItemTag;BOOL firstInit;}


+ (instancetype)shareInstance
{
    static HTTabBarController *tabBarC;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tabBarC = [[HTTabBarController alloc] init];
    });
    return tabBarC;
}
+ (instancetype)tabBarControllerWitnAddChildVCBlock:(void (^)(HTTabBarController *))addVCBlock
{
    HTTabBarController *tabBarVC = [[HTTabBarController alloc] init];
    if (addVCBlock) {
        addVCBlock(tabBarVC);
    }
    return tabBarVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.centerPlace = -1;
    
    //Observer Device Orientation
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OrientationDidChange) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}

/**
 *  Initialize selected
 */
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (!firstInit)
    {
        firstInit = YES;
        NSInteger index = [HTTabBarConfig shared].selectIndex;
        if (index < 0) {
            self.selectedIndex = (self.centerPlace != -1 && self.items[self.centerPlace].tag != -1)
            ? self.centerPlace
            : 0;
        }else if (index >= self.viewControllers.count){
            self.selectedIndex = self.viewControllers.count-1;
        }
        else{
            self.selectedIndex = index;
        }
    }
}

/**
 *  Add other button for child’s controller
 */
- (void)addChildController:(id)Controller title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName{
    //UIViewController *vc = [self findViewControllerWithobject:Controller];
    HTNavigationController *nav = [[HTNavigationController alloc] initWithRootViewController:Controller];

    
    
    nav.tabBarItem.title = title;
    nav.tabBarItem.image = [UIImage imageNamed:imageName];
    nav.tabBarItem.selectedImage = [UIImage imageNamed:selectedImageName];
    //nav.tabBarItem.badgeValue = @"1";
    nav.tabBarItem.tag = tabBarItemTag++;
    [self.items addObject:nav.tabBarItem];
    [self addChildViewController:nav];
}

/**
 *  Add center button
 */
- (void)addCenterController:(id)Controller bulge:(BOOL)bulge title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName{
    _bulge = bulge;
    if (Controller) {
        [self addChildController:Controller title:title imageName:imageName selectedImageName:selectedImageName];
        self.centerPlace = tabBarItemTag-1;
    }else{
        UITabBarItem *item = [[UITabBarItem alloc]initWithTitle:title
                                                          image:[UIImage imageNamed:imageName]
                                                  selectedImage:[UIImage imageNamed:selectedImageName]];
        item.tag = -1;
        [self.items addObject:item];
        self.centerPlace = tabBarItemTag;
    }
}

/**
 *  Device Orientation func
 */
- (void)OrientationDidChange{
    self.tabbar.frame = [self tabbarFrame];
}

- (CGRect)tabbarFrame{
    if(ISiPhoneX){
        return CGRectMake(0, [UIScreen mainScreen].bounds.size.height-83,
                          [UIScreen mainScreen].bounds.size.width, 49);
    }
    return CGRectMake(0, [UIScreen mainScreen].bounds.size.height-49,
                      [UIScreen mainScreen].bounds.size.width, 49);
}

/**
 *  getter
 */
- (HTTabBar *)tabbar{
    if (self.items.count && !_tabbar) {
        _tabbar = [[HTTabBar alloc]initWithFrame:[self tabbarFrame]];
        [_tabbar setValue:self forKey:@"controller"];
        [_tabbar setValue:[NSNumber numberWithBool:self.bulge] forKey:@"bulge"];
        [_tabbar setValue:[NSNumber numberWithInteger:self.centerPlace] forKey:@"centerPlace"];
        _tabbar.items = self.items;
        
        //remove tabBar
        for (UIView *loop in self.tabBar.subviews) {
            [loop removeFromSuperview];
        }
        self.tabBar.hidden = YES;
        
        
        [self.tabBar removeFromSuperview];
        [_tabbar setCenterBtnClickBlock:^{
//            HTLog(@"block回调");
        }];
    }
    return _tabbar;
}
- (NSMutableArray <UITabBarItem *>*)items{
    if(!_items){
        _items = [NSMutableArray array];
    }
    return _items;
}

- (void)InitializeTabbar{
    [_tabbar setValue:[NSNumber numberWithBool:self.bulge] forKey:@"bulge"];
    [_tabbar setValue:[NSNumber numberWithInteger:self.centerPlace] forKey:@"centerPlace"];
    _tabbar.items = self.items;
}


/**
 *  Update current select controller
 */
- (void)setSelectedIndex:(NSUInteger)selectedIndex{
    if (selectedIndex >= self.viewControllers.count){
        @throw [NSException exceptionWithName:@"selectedTabbarError"
                                       reason:@"No controller can be used,Because of index beyond the viewControllers,Please check the configuration of tabbar."
                                     userInfo:nil];
    }
    [super setSelectedIndex:selectedIndex];
    UIViewController *viewController = [self findViewControllerWithobject:self.viewControllers[selectedIndex]];
    [self.tabbar removeFromSuperview];
    [viewController.view addSubview:self.tabbar];
    viewController.extendedLayoutIncludesOpaqueBars = YES;
    [self.tabbar setValue:[NSNumber numberWithInteger:selectedIndex] forKeyPath:@"selectButtoIndex"];
}



/**
 *  Catch viewController
 */
- (UIViewController *)findViewControllerWithobject:(id)object{
    while ([object isKindOfClass:[UITabBarController class]] || [object isKindOfClass:[UINavigationController class]]){
        object = ((UITabBarController *)object).viewControllers.firstObject;
    }
    return object;
}

/**
 *  hidden tabbar and do animated
 */
- (void)setCYTabBarHidden:(BOOL)hidden animated:(BOOL)animated{
    NSTimeInterval time = animated ? 0.3 : 0.0;
    if (self.tabbar.isHidden) {
        self.tabbar.hidden = NO;
        [UIView animateWithDuration:time animations:^{
            self.tabbar.transform = CGAffineTransformIdentity;
        }];
    }else{
        CGFloat h = self.tabbar.frame.size.height;
        [UIView animateWithDuration:time-0.1 animations:^{
            self.tabbar.transform = CGAffineTransformMakeTranslation(0,h);
        }completion:^(BOOL finished) {
            self.tabbar.hidden = YES;
        }];
    }
}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
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
