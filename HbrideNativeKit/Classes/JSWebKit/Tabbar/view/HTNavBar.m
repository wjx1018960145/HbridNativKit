//
//  HTNavBar.m
//  HybridForiOS
//
//  Created by wjx on 2020/5/18.
//  Copyright © 2020 WJX. All rights reserved.
//

#import "HTNavBar.h"
#import "NSObject+PYThemeExtension.h"
@implementation HTNavBar

+ (void)setGlobalBackGroundImage:(UIImage *)globalImg {
    UINavigationBar *navBar = [UINavigationBar appearanceWhenContainedIn:NSClassFromString(@"WJXNavigationController"), nil];
    [navBar setBackgroundImage:globalImg forBarMetrics:UIBarMetricsDefault];
}

+ (void)setGlobalBarTintColor:(UIColor *)barColor {
   
    UINavigationBar *navBar = [UINavigationBar appearanceWhenContainedIn:NSClassFromString(@"WJXNavigationController"), nil];
    //[navBar py_addToThemeColorPool:@"barTintColor"];
     [navBar py_addToThemeColorPool:@"barTintColor"];

    //[navBar setBarTintColor:barColor];
}
+ (void)setGlobalTextColor: (UIColor *)globalTextColor andFontSize: (CGFloat)fontSize  {
    
    if (globalTextColor == nil) {
        return;
    }
    if (fontSize < 6 || fontSize > 40) {
        fontSize = 16;
    }
    
    UINavigationBar *navBar = [UINavigationBar appearanceWhenContainedIn:NSClassFromString(@"WJXNavigationController"), nil];
    // 设置导航栏颜色
    NSDictionary *titleDic = @{
                               NSForegroundColorAttributeName: globalTextColor,
                               NSFontAttributeName: [UIFont systemFontOfSize:fontSize]
                               };
    [navBar setTitleTextAttributes:titleDic];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.translucent = NO;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
