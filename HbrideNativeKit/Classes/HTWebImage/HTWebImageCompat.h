//
//  HTWebImageCompat.h
//  HybridForiOS
//
//  Created by wjx on 2020/3/17.
//  Copyright © 2020 WJX. All rights reserved.
//

#import <TargetConditionals.h>

#ifdef __OBJC_GC__
#error HTWebImage does not support Objective-C Garbage Collection
#endif

#if __IPHONE_OS_VERSION_MIN_REQUIRED != 20000 && __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_5_0
#error HTWebImage doesn't support Deployment Target version < 5.0
#endif

#if !TARGET_OS_IPHONE
#import <AppKit/AppKit.h>
#ifndef UIImage
#define UIImage NSImage
#endif
#ifndef UIImageView
#define UIImageView NSImageView
#endif
#else

#import <UIKit/UIKit.h>

#endif

#ifndef NS_ENUM
#define NS_ENUM(_type, _name) enum _name : _type _name; enum _name : _type
#endif

#ifndef NS_OPTIONS
#define NS_OPTIONS(_type, _name) enum _name : _type _name; enum _name : _type
#endif

#if OS_OBJECT_USE_OBJC
    #undef HTDispatchQueueRelease
    #undef HTDispatchQueueSetterSementics
    #define HTDispatchQueueRelease(q)
    #define HTDispatchQueueSetterSementics strong
#else
#undef HTDispatchQueueRelease
#undef HTDispatchQueueSetterSementics
#define HTDispatchQueueRelease(q) (dispatch_release(q))
#define HTDispatchQueueSetterSementics assign
#endif

extern UIImage *HTScaledImageForKey(NSString *key, UIImage *image);

typedef void(^HTWebImageNoParamsBlock)(void);

extern NSString *const HTWebImageErrorDomain;

#define dispatch_main_sync_safe(block)\
    if ([NSThread isMainThread]) {\
        block();\
    } else {\
        dispatch_sync(dispatch_get_main_queue(), block);\
    }

#define dispatch_main_async_safe(block)\
    if ([NSThread isMainThread]) {\
        block();\
    } else {\
        dispatch_async(dispatch_get_main_queue(), block);\
    }

