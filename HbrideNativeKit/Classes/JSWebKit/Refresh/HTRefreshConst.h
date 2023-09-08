//
//  HTRefreshConst.h
//  HybridForiOS
//
//  Created by wjx on 2020/4/10.
//  Copyright © 2020 WJX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/message.h>

// 弱引用
#define HTWeakSelf __weak typeof(self) weakSelf = self;

// 日志输出
#ifdef DEBUG
#define HTRefreshLog(...) NSLog(__VA_ARGS__)
#else
#define HTRefreshLog(...)
#endif

// 过期提醒
#define HTRefreshDeprecated(DESCRIPTION) __attribute__((deprecated(DESCRIPTION)))

// 运行时objc_msgSend
#define HTRefreshMsgSend(...) ((void (*)(void *, SEL, UIView *))objc_msgSend)(__VA_ARGS__)
#define HTRefreshMsgTarget(target) (__bridge void *)(target)

// RGB颜色
#define HTRefreshColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

// 文字颜色
#define HTRefreshLabelTextColor HTRefreshColor(90, 90, 90)

// 字体大小
#define HTRefreshLabelFont [UIFont boldSystemFontOfSize:14]

// 常量
UIKIT_EXTERN const CGFloat HTRefreshLabelLeftInset;
UIKIT_EXTERN const CGFloat HTRefreshHeaderHeight;
UIKIT_EXTERN const CGFloat HTRefreshFooterHeight;
UIKIT_EXTERN const CGFloat HTRefreshFastAnimationDuration;
UIKIT_EXTERN const CGFloat HTRefreshSlowAnimationDuration;

UIKIT_EXTERN NSString *const HTRefreshKeyPathContentOffset;
UIKIT_EXTERN NSString *const HTRefreshKeyPathContentSize;
UIKIT_EXTERN NSString *const HTRefreshKeyPathContentInset;
UIKIT_EXTERN NSString *const HTRefreshKeyPathPanState;

UIKIT_EXTERN NSString *const HTRefreshHeaderLastUpdatedTimeKey;

UIKIT_EXTERN NSString *const HTRefreshHeaderIdleText;
UIKIT_EXTERN NSString *const HTRefreshHeaderPullingText;
UIKIT_EXTERN NSString *const HTRefreshHeaderRefreshingText;

UIKIT_EXTERN NSString *const HTRefreshAutoFooterIdleText;
UIKIT_EXTERN NSString *const HTRefreshAutoFooterRefreshingText;
UIKIT_EXTERN NSString *const HTRefreshAutoFooterNoMoreDataText;

UIKIT_EXTERN NSString *const HTRefreshBackFooterIdleText;
UIKIT_EXTERN NSString *const HTRefreshBackFooterPullingText;
UIKIT_EXTERN NSString *const HTRefreshBackFooterRefreshingText;
UIKIT_EXTERN NSString *const HTRefreshBackFooterNoMoreDataText;

UIKIT_EXTERN NSString *const HTRefreshHeaderLastTimeText;
UIKIT_EXTERN NSString *const HTRefreshHeaderDateTodayText;
UIKIT_EXTERN NSString *const HTRefreshHeaderNoneLastDateText;

// 状态检查
#define HTRefreshCheckState \
HTRefreshState oldState = self.state; \
if (state == oldState) return; \
[super setState:state];

// 异步主线程执行，不强持有Self
#define HTRefreshDispatchAsyncOnMainQueue(x) \
__weak typeof(self) weakSelf = self; \
dispatch_async(dispatch_get_main_queue(), ^{ \
typeof(weakSelf) self = weakSelf; \
{x} \
});
