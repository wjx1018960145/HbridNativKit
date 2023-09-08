//
//  HTUtility.m
//  HybridForiOS
//
//  Created by wjx on 2020/3/3.
//  Copyright © 2020 WJX. All rights reserved.
//

#import "HTUtility.h"
#import "HTLog.h"
#import "HTAppConfiguration.h"
#import "HTDefine.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <sys/utsname.h>
#import <CommonCrypto/CommonCrypto.h>
static BOOL isDarkSchemeSupportEnabled = YES;
static const CGFloat HTDefaultScreenWidth = 750.0;
void WXPerformBlockOnMainThread(void (^ _Nonnull block)(void))
{
    if (!block) return;
    
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            block();
        });
    }
}

void WXPerformBlockSyncOnMainThread(void (^ _Nonnull block)(void))
{
    if (!block) return;
    
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            block();
        });
    }
}

void WXPerformBlockOnThread(void (^ _Nonnull block)(void), NSThread *thread)
{
    [HTUtility performBlock:block onThread:thread];
    
}

CGFloat HTScreenScale(void)
{
    static CGFloat _scale;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _scale = [UIScreen mainScreen].scale;
    });
    return _scale;
}

CGFloat HTPixelScale(CGFloat value, CGFloat scaleFactor)
{
    return HTCeilPixelValue(value * scaleFactor);
}

CGFloat HTRoundPixelValue(CGFloat value)
{
    CGFloat scale = HTScreenScale();
    return round(value * scale) / scale;
}

CGFloat HTCeilPixelValue(CGFloat value)
{
    CGFloat scale = HTScreenScale();
    return ceil(value * scale) / scale;
}

CGFloat HTFloorPixelValue(CGFloat value)
{
    CGFloat scale = HTScreenScale();
    return floor(value * scale) / scale;
}

@implementation HTUtility

+ (void)performBlock:(void (^)(void))block onThread:(NSThread *)thread
{
    if (!thread || !block) return;
    
    if ([NSThread currentThread] == thread) {
        block();
    } else {
        [self performSelector:@selector(_performBlock:)
                     onThread:thread
                   withObject:[block copy]
                waitUntilDone:NO];
    }
}

+ (void)_performBlock:(void (^)(void))block
{
    block();
}




+(BOOL)isSystemInDarkScheme{
    
        if (@available(iOS 13.0, *)) {
            __block BOOL result = NO;
            HTPerformBlockSyncOnMainThread(^{
    #ifdef __IPHONE_13_0

    #endif
            });
            return result;
        }
        return NO;
}

+ (id)JSONObject:(NSData*)data error:(NSError **)error
{
    if (!data) return nil;
    id jsonObj = nil;
    @try {
        jsonObj = [NSJSONSerialization JSONObjectWithData:data
                                                  options:NSJSONReadingAllowFragments | NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves
                                                    error:error];
    } @catch (NSException *exception) {
        if (error) {
            *error = [NSError errorWithDomain:HT_ERROR_DOMAIN code:-1 userInfo:@{NSLocalizedDescriptionKey: [exception description]}];
        }
    }
    return jsonObj;
}

+ (NSString *)JSONString:(id)object
{
    if(!object) return nil;
    
    @try {
    
        NSError *error = nil;
        if ([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSDictionary class]]) {
            NSData *data = [NSJSONSerialization dataWithJSONObject:object
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
            if (error) {
                HTLogError(@"%@", [error description]);
                return nil;
            }
            
            return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        } else if ([object isKindOfClass:[NSString class]]) {
            NSArray *array = @[object];
            NSData *data = [NSJSONSerialization dataWithJSONObject:array
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
            if (error) {
                HTLogError(@"%@", [error description]);
                return nil;
            }
            
            NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if (string.length <= 4) {
                HTLogError(@"json convert length less than 4 chars.");
                return nil;
            }
            
            return [string substringWithRange:NSMakeRange(2, string.length - 4)];
        } else {
            HTLogError(@"object isn't avaliable class");
            return nil;
        }
        
    } @catch (NSException *exception) {
        return nil;
    }
}



#pragma mark - Dark scheme

+ (void)setDarkSchemeSupportEnable:(BOOL)value
{
    isDarkSchemeSupportEnabled = value;
}

+ (BOOL)isDarkSchemeSupportEnabled
{
    return isDarkSchemeSupportEnabled;
}

void HTPerformBlockSyncOnMainThread(void (^ _Nonnull block)(void))
{
    if (!block) return;
    
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            block();
        });
    }
}
+(float)getStatusBarHeight {
    
    float statusBarHeight = 0;
           if (@available(iOS 13.0, *)) {
               UIStatusBarManager *statusBarManager = [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager;
               statusBarHeight = statusBarManager.statusBarFrame.size.height;
           }
           else {
               statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
           }
    return statusBarHeight;
}

+ (NSString *)userAgent
{
    // Device UA
    NSString *deviceUA = [NSString stringWithFormat:@"%@(iOS/%@)", [self deviceName]?:@"UNKNOWN", [[UIDevice currentDevice] systemVersion]]?:@"0.0.0";
    
    // App UA
    NSString *appUA = [NSString stringWithFormat:@"%@(%@/%@)", [HTAppConfiguration appGroup]?:@"WeexGroup", [HTAppConfiguration appName]?:@"WeexApp", [HTAppConfiguration appVersion]?:@"0.0.0"];

    // Weex UA
    NSString *weexUA = [NSString stringWithFormat:@"Weex/%@", HT_SDK_VERSION];
    
    
    // external UA
    NSString *externalUA = [HTAppConfiguration externalUserAgent] ? [NSString stringWithFormat:@" %@", [HTAppConfiguration externalUserAgent]] : @"";
    
    // Screen Size
    CGFloat w = [[UIScreen mainScreen] bounds].size.width;
    CGFloat h = [[UIScreen mainScreen] bounds].size.height;
    CGFloat s = [[UIScreen mainScreen] scale];
    NSString * screenUA = [NSString stringWithFormat:@"%dx%d", (int)(s * w), (int)(s * h)];
    
    // New UA
    return [NSString stringWithFormat:@"%@ %@ %@%@ %@", deviceUA, appUA, weexUA, externalUA, screenUA];
}

+ (NSString *)stringWithContentsOfFile:(NSString *)filePath
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSString *contents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
        if (contents) {
            return contents;
        }
    }
    return nil;
}

+ (NSString *)md5:(NSString *)string
{
    const char *str = string.UTF8String;
    if (str == NULL) {
        return nil;
    }
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), result);
    
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+ (NSString *)uuidString
{
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStringRef= CFUUIDCreateString(NULL, uuidRef);
    NSString *uuid = [NSString stringWithString:(__bridge NSString *)uuidStringRef];
    CFRelease(uuidRef);
    CFRelease(uuidStringRef);
    
    return [uuid lowercaseString];
}

+ (NSDate *)dateStringToDate:(NSString *)dateString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date=[formatter dateFromString:dateString];
    return date;
}

+ (NSDate *)timeStringToDate:(NSString *)timeString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"HH:mm"];
    NSDate *date=[formatter dateFromString:timeString];
    return date;
}

+ (NSString *)dateToString:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *str = [dateFormatter stringFromDate:date];
    return str;
}

+ (NSString *)timeToString:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *str = [dateFormatter stringFromDate:date];
    return str;
}

+ (NSString *)libraryDirectory
{
    static NSString *libPath = nil;
    if (!libPath) {
        libPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject;
    }
    return libPath;
}

+ (NSCache *)globalCache
{
    static NSCache *cache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [NSCache new];
        cache.totalCostLimit = 5 * 1024 * 1024;
        
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidReceiveMemoryWarningNotification object:nil queue:nil usingBlock:^(__unused NSNotification *note) {
            [cache removeAllObjects];
        }];
    });
    return cache;
}

+ (NSString *)deviceName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *machine = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return machine;
}

+ (NSString *)registeredDeviceName
{
    NSString *machine = [[UIDevice currentDevice] model];
    NSString *systemVer = [[UIDevice currentDevice] systemVersion] ? : @"";
    NSString *model = [NSString stringWithFormat:@"%@:%@",machine,systemVer];
    return model;
}

+(id)convertContainerToImmutable:(id)source{
    if (source == nil) {
          return nil;
      }
      
      if ([source isKindOfClass:[NSArray class]]) {
          NSMutableArray* tmpArray = [[NSMutableArray alloc] init];
          for (id obj in source) {
              if (obj == nil) {
                  /* srouce may be a subclass of NSArray and the subclassed
                   array may return nil in its overridden objectAtIndex: method.
                   So obj could be nil!!!. */
                  continue;
              }
              [tmpArray addObject:[self convertContainerToImmutable:obj]];
          }
          id immutableArray = [NSArray arrayWithArray:tmpArray];
          return immutableArray ? immutableArray : tmpArray;
      }
      else if ([source isKindOfClass:[NSDictionary class]]) {
          NSMutableDictionary* tmpDictionary = [[NSMutableDictionary alloc] init];
          for (id key in [source keyEnumerator]) {
              tmpDictionary[key] = [self convertContainerToImmutable:[source objectForKey:key]];
          }
          id immutableDict = [NSDictionary dictionaryWithDictionary:tmpDictionary];
          return immutableDict ? immutableDict : tmpDictionary;
      }
      
      return source;
}


+ (id)copyJSONObject:(id)object
{
    if ([object isKindOfClass:[NSArray class]]) {
        NSArray *array = (NSArray *)object;
        NSMutableArray *copyObjs = [NSMutableArray array];
        
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            id copyObj = [self copyJSONObject:obj];
            [copyObjs insertObject:copyObj atIndex:idx];
        }];
        
        return copyObjs;
    } else if ([object isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary *)object;
        NSMutableDictionary *copyObjs = [NSMutableDictionary dictionary];
        
        [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            id copyObj = [self copyJSONObject:obj];
            [copyObjs setObject:copyObj forKey:key];
        }];
        
        return copyObjs;
    } else {
        return [object copy];
    }
}

+ (BOOL)isBlankString:(NSString *)string {
    
    if (string == nil || string == NULL || [string isKindOfClass:[NSNull class]]) {
        return true;
    }
    if (![string isKindOfClass:[NSString class]]) {
        return true;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        return true;
    }
    
    return false;
}
+ (NSDictionary *_Nonnull)dataToBase64Dict:(NSData *_Nullable)data
{
    NSMutableDictionary *dataDict = [NSMutableDictionary new];
    if(data){
        NSString *base64Encoded = [data base64EncodedStringWithOptions:0];
        [dataDict setObject:@"binary" forKey:@"@type"];
        [dataDict setObject:base64Encoded forKey:@"base64"];
    }
    
    return dataDict;
}

+ (NSData *_Nonnull)base64DictToData:(NSDictionary *_Nullable)base64Dict
{
    if([@"binary" isEqualToString:base64Dict[@"@type"]]){
        NSString *base64 = base64Dict[@"base64"];
        NSData *sendData = [[NSData alloc] initWithBase64EncodedString:base64 options:0];
        return sendData;
    }
    return nil;
}

+ (CGSize)portraitScreenSize
{
    if ([[UIDevice currentDevice].model isEqualToString:@"iPad"]) {
        return [UIScreen mainScreen].bounds.size;
    }
    static CGSize portraitScreenSize;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        portraitScreenSize = CGSizeMake(MIN(screenSize.width, screenSize.height),
                                        MAX(screenSize.width, screenSize.height));
    });
    
    return portraitScreenSize;
}

+ (CGFloat)defaultPixelScaleFactor
{
    if ([[UIDevice currentDevice].model isEqualToString:@"iPad"]) {
        return [self portraitScreenSize].width / HTDefaultScreenWidth;
    }
    static CGFloat defaultScaleFactor;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultScaleFactor = [self portraitScreenSize].width / HTDefaultScreenWidth;
    });
    
    return defaultScaleFactor;
}

BOOL HTFloatEqual(CGFloat a, CGFloat b) {
    return HTFloatEqualWithPrecision(a, b,FLT_EPSILON);
}
BOOL HTFloatEqualWithPrecision(CGFloat a, CGFloat b ,double precision){
    return fabs(a - b) <= precision;
}
BOOL HTFloatLessThan(CGFloat a, CGFloat b) {
    return HTFloatLessThanWithPrecision(a, b, FLT_EPSILON);
}
BOOL HTFloatLessThanWithPrecision(CGFloat a, CGFloat b ,double precision){
    return a-b < - precision;
}

BOOL HTFloatGreaterThan(CGFloat a, CGFloat b) {
    return HTFloatGreaterThanWithPrecision(a, b, FLT_EPSILON);
}
BOOL HTFloatGreaterThanWithPrecision(CGFloat a, CGFloat b ,double precision){
    return a-b > precision;
}

@end

//Deprecated
CGFloat HTScreenResizeRadio(void)
{
    return [HTUtility defaultPixelScaleFactor];
}

CGFloat HTPixelResize(CGFloat value)
{
    return HTCeilPixelValue(value * HTScreenResizeRadio());
}

CGRect HTPixelFrameResize(CGRect value)
{
    CGRect new = CGRectMake(value.origin.x * HTScreenResizeRadio(),
                            value.origin.y * HTScreenResizeRadio(),
                            value.size.width * HTScreenResizeRadio(),
                            value.size.height * HTScreenResizeRadio());
    return new;
}

CGPoint HTPixelPointResize(CGPoint value)
{
    CGPoint new = CGPointMake(value.x * HTScreenResizeRadio(),
                              value.y * HTScreenResizeRadio());
    return new;
}

