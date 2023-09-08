//
//  HTDefine.h
//  HybridForiOS
//
//  Created by wjx on 2020/3/3.
//  Copyright © 2020 WJX. All rights reserved.
//

#ifndef HTDefine_h
#define HTDefine_h

#define HT_SDK_VERSION @"0.0.01"

#define HT_BRIDGE_THREAD_NAME @"com.huteng.bridge"
#define HT_BACKUP_BRIDGE_THREAD_NAME @"com.huteng.backup.bridge"

#define HT_ERROR_DOMAIN @"HTErrorDomain"




#if defined(__cplusplus)
#define HT_EXTERN extern "C" __attribute__((visibility("default")))
#else
#define HT_EXTERN extern __attribute__((visibility("default")))
#endif

#define HT_CONCAT(a,b)  a ## b


#define HT_CONCAT_WRAPPER(a, b)    HT_CONCAT(a, b)

#define HT_EXPORT_METHOD_INTERNAL(method, token) \
+ (NSString *)HT_CONCAT_WRAPPER(token, __LINE__) { \
    return NSStringFromSelector(method); \
}


#define HT_EXPORT_METHOD(method) HT_EXPORT_METHOD_INTERNAL(method,ht_export_method_)



#define kScreen_Height [UIScreen mainScreen].bounds.size.height
#define kScreen_Width  [UIScreen mainScreen].bounds.size.width
#define kStatusBar_Height [[UIApplication sharedApplication] statusBarFrame].size.height

/**
 *  @abstract Compared with system version of current device
 *
 *  @return YES if greater than or equal to the system verison, otherwise, NO.
 *
 */
#define HT_SYS_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


/**
 *  @abstract Compared with system version of current device
 *
 *  @return YES if greater than the system verison, otherwise, NO.
 *
 */
#define HT_SYS_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
/**
 *  @abstract Compared with system version of current device
 *
 *  @return YES if less than the system verison, otherwise, NO.
 *
 */
#define HT_SYS_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

#define IS_IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
#define IS_IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)
#define IS_IOS9 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9)
#define IS_IOS10 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10)

//判断是否是ipad
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define ISiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)


//#define screenSize [UIScreen mainScreen].bounds.size
//#define screenWidth [UIScreen mainScreen].bounds.size.width
//#define screenHeight [UIScreen mainScreen].bounds.size.height

//上传路径配置
#define BASE_URL @"http://127.0.0.1:8080/File"
#define TAPI @""
#define DAPI @""
#define PAPI @"http://127.0.0.1:8080"




#define CURRENT_API PAPI

#endif /* HTDefine_h */



