//
//  HTHUDProgressModule.m
//  HybridForiOS
//
//  Created by wjx on 2020/4/28.
//  Copyright © 2020 WJX. All rights reserved.
//

#import "HTHUDProgressModule.h"
#import "HTProgressHUD.h"
#import "UIViewExt.h"
#import "HTDefine.h"
static HTProgressHUD *HUD = nil;
typedef enum{
    YJProgressModeOnlyText,           //文字
    YJProgressModeLoading,              //加载菊花
    YJProgressModeCircleLoading,         //加载圆形
    YJProgressModeSuccess               //成功
    
}YJProgressMode;

typedef enum {
    WJXSuccess,
    WJXError,
    WJXAwait
}MsgStatrt;


@interface HTHUDProgressModule()
@property (nonatomic, strong) UIViewController *rootViewController;
//最新hud
@property (nonatomic,strong) HTProgressHUD  *hud;
@end



@implementation HTHUDProgressModule

@synthesize htInstance;

+ (instancetype)shareTools {
    static HTHUDProgressModule *tools = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tools = [[HTHUDProgressModule alloc]init];
    });
    return tools;
}
+(void)show:(NSString *)msg inView:(UIView *)view mode:(YJProgressMode *)myMode states:(MsgStatrt)states{
    //如果已有弹框，先消失
    if ([HTHUDProgressModule shareTools].hud != nil) {
        [[HTHUDProgressModule shareTools].hud hideAnimated:YES];
        [HTHUDProgressModule shareTools].hud = nil;
    }
    
    //4\4s屏幕避免键盘存在时遮挡
    if ([UIScreen mainScreen].bounds.size.height == 480) {
        [view endEditing:YES];
    }
    
    [HTHUDProgressModule shareTools].hud = [HTProgressHUD showHUDAddedTo:view animated:YES];
    //[HTDZJ_ShareTools shareTools].hud.dimBackground = YES;    //是否显示透明背景
    //[HTDZJ_ShareTools shareTools].hud.color = [UIColor blackColor];
    [[HTHUDProgressModule shareTools].hud setMargin:10];
    [[HTHUDProgressModule shareTools].hud setRemoveFromSuperViewOnHide:YES];
    [HTHUDProgressModule shareTools].hud.detailsLabel.text = msg;
    [HTHUDProgressModule shareTools].hud.detailsLabel.backgroundColor = [UIColor clearColor];
    [HTHUDProgressModule shareTools].hud.detailsLabel.font = [UIFont systemFontOfSize:16];
    
    switch ((NSInteger)states) {
        case WJXSuccess:
             [HTHUDProgressModule shareTools].hud.detailsLabel.textColor = [UIColor greenColor];
            break;
            case WJXError:
            [HTHUDProgressModule shareTools].hud.detailsLabel.textColor = [UIColor redColor];
            break;
            case WJXAwait:
            [HTHUDProgressModule shareTools].hud.detailsLabel.textColor = [UIColor yellowColor];
            break;
        default:
           // [HTDZJ_ShareTools shareTools].hud.detailsLabel.textColor = [UIColor blackColor];
            break;
    }
    
   // [HTDZJ_ShareTools shareTools].hud.detailsLabel.textColor = [UIColor blackColor];
    switch ((NSInteger)myMode) {
        case YJProgressModeOnlyText:
            [HTHUDProgressModule shareTools].hud.mode = HTProgressHUDModeText;
            break;
            
        case YJProgressModeLoading:
            [HTHUDProgressModule shareTools].hud.mode = HTProgressHUDModeIndeterminate;
            break;
            
        case YJProgressModeCircleLoading:
            [HTHUDProgressModule shareTools].hud.mode = HTProgressHUDModeDeterminate;
            break;
            
        case YJProgressModeSuccess:
            [HTHUDProgressModule shareTools].hud.mode = HTProgressHUDModeCustomView;
            [HTHUDProgressModule shareTools].hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success"]];
            break;
            
        default:
            break;
    }
    
}
+(void)HT_Hide{
    if ([HTHUDProgressModule shareTools].hud != nil) {
        [[HTHUDProgressModule shareTools].hud hideAnimated:YES afterDelay:1];
    }
}
#pragma mark - 获取window根视图
- (UIViewController *)rootViewController{
    if (!_rootViewController) {
        _rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    }
    return _rootViewController;
}

- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}
- (BOOL)registerBridge:(nonnull WKWebViewJavascriptBridge *)bridge {
    //// 显示转圈加载，调用dismiss、showMessage等方法隐藏，常用于已有视图上提交加载数据
     [bridge registerNoParamsHandler:@"showLoading" handler:^(HTJBResponseCallback  _Nullable responseCallback) {
            
            UIViewController * vc = [self topViewController];
        
            [HTProgressHUD showHUDAddedTo:vc.view animated:YES];
//         responseCallback(@{@"result":@"success",@"data":@"1"});
        }];
    //提示信息 两秒后消失
    [bridge registerHandler:@"showMessage" handler:^(id  _Nullable data, HTJBResponseCallback  _Nullable responseCallback) {
        
    }];
    [bridge registerNoParamsHandler:@"dismissLoading" handler:^(HTJBResponseCallback  _Nullable responseCallback) {
              
              
             
              
              UIViewController * vc = [self topViewController];
             
           
          [HTProgressHUD hideHUDForView:vc.view animated:YES];
             
      //        [[self class] show:text inView:vc.view mode:YJProgressModeOnlyText states:4];
      //        [[HTHUDProgressModule shareTools].hud hideAnimated:YES afterDelay:1];
              
          }];
    //
    
    
    
    return YES;
}
+ (UIImageView *)customImageView {
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jiazai02"]];
    image.size = CGSizeMake(40, 40);
    image.transform = CGAffineTransformRotate(image.transform, 0.01);
    CABasicAnimation *animation = [ CABasicAnimation
                                   animationWithKeyPath: @"transform" ];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    
    //围绕Z轴旋转，垂直与屏幕
    animation.toValue = [ NSValue valueWithCATransform3D:
                         
                         CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0) ];
    animation.duration = 0.5;
    //旋转效果累计，先转180度，接着再旋转180度，从而实现360旋转
    animation.cumulative = YES;
    animation.repeatCount = 10000;
    
    //在图片边缘添加一个像素的透明区域，去图片锯齿
    CGRect imageRrect = CGRectMake(0, 0,image.frame.size.width, image.frame.size.height);
    UIGraphicsBeginImageContext(imageRrect.size);
    [image.image drawInRect:CGRectMake(1,1,image.frame.size.width-2,image.frame.size.height-2)];
    image.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [image.layer addAnimation:animation forKey:nil];
    return image;

}
@end
