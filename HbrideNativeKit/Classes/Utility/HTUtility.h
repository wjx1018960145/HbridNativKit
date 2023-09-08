
//
//  HTUtility.h
//  HybridForiOS
//
//  Created by wjx on 2020/3/3.
//  Copyright © 2020 WJX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
/**
 * @abstract execute asynchronous action block on the main thread.
 *
 */
void WXPerformBlockOnMainThread( void (^ _Nonnull block)(void));

/**
 * @abstract execute synchronous action block on the main thread.
 *
 */
void WXPerformBlockSyncOnMainThread( void (^ _Nonnull block)(void));

/**
 * @abstract execute action block on the specific thread.
 *
 */
void WXPerformBlockOnThread(void (^ _Nonnull block)(void), NSThread *_Nonnull thread);

@interface HTUtility : NSObject

+ (void)performBlock:(void (^_Nonnull)(void))block onThread:(NSThread *_Nonnull)thread;
/**
 * @abstract Check if system is in dark mode.
 *
 * @return Boolean
 *
 */
+ (BOOL)isSystemInDarkScheme;
/**
*  @abstract Switch for dark mode support.
*
*/
+ (void)setDarkSchemeSupportEnable:(BOOL)value;
+ (BOOL)isDarkSchemeSupportEnabled;
+ (float)getStatusBarHeight;
+ (id _Nullable)convertContainerToImmutable:(id _Nullable)source;

/**
 * @abstract UserAgent Generation
 *
 * @return A ua string by splicing (deviceName、appVersion、sdkVersion、externalField、screenSize)
 *
 */
+ (NSString *_Nonnull)userAgent;

/**
 *
 *  Checks if a String is whitespace, empty ("") or nil
 *  @code
 *    [WXUtility isBlankString: nil]       = true
 *    [WXUtility isBlankString: ""]        = true
 *    [WXUtility isBlankString: " "]       = true
 *    [WXUtility isBlankString: "bob"]     = false
 *    [WXUtility isBlankString: "  bob  "] = false
 *  @endcode
 *  @param string the String to check, may be null
 *
 *  @return true if the String is null, empty or whitespace
 */
+ (BOOL)isBlankString:(NSString * _Nullable)string ;


+ (NSString * _Nullable)JSONString:(id _Nonnull)object;

#define HTEncodeJson(obj)  [HTUtility JSONString:obj]

/**
 * @abstract Returns a Foundation object from given JSON data. A Foundation object from the JSON data in data, or nil if an error occurs.
 *
 * @param data A data object containing JSON data.
 * @param error If an error occurs, upon return contains an NSError object that describes the problem.
 *
 * @return A Foundation object from the JSON data in data, or nil if an error occurs.
 *
 */
+ (id _Nullable)JSONObject:(NSData * _Nonnull)data error:(NSError * __nullable * __nullable)error;

#define HTJSONObjectFromData(data) [HTUtility JSONObject:data error:nil]
/**
 *  @abstract format to base64 dictionary
 *
 */
+ (NSDictionary *_Nonnull)dataToBase64Dict:(NSData *_Nullable)data;

/**
 *  @abstract format to data
 *
 */
+ (NSData *_Nonnull)base64DictToData:(NSDictionary *_Nullable)base64Dict;
/**
 *  @abstract Returns the contents of file.
 *
 */
+ (NSString *_Nullable)stringWithContentsOfFile:(NSString *_Nonnull)filePath;
/**
 *  @abstract Returns md5 string.
 *
 */
+ (NSString *_Nullable)md5:(NSString *_Nullable)string;

/**
 *  @abstract Returns Creates a Universally Unique Identifier (UUID) string.
 *
 */
+ (NSString *_Nullable)uuidString;
/**
 *  @abstract convert date string with formatter yyyy-MM-dd to date.
 *
 */
+ (NSDate *_Nullable)dateStringToDate:(NSString *_Nullable)dateString;

/**
 *  @abstract convert time string with formatter HH:mm to date.
 *
 */
+ (NSDate *_Nullable)timeStringToDate:(NSString *_Nullable)timeString;

/**
 *  @abstract convert date to date string with formatter yyyy-MM-dd .
 *
 */
+ (NSString *_Nullable)dateToString:(NSDate *_Nullable)date;

/**
 *  @abstract convert date to time string with formatter HH:mm .
 *
 */
+ (NSString *_Nullable)timeToString:(NSDate *_Nullable)date;

/**
 *  @abstract Returns the system library directory path.
 *
 */
+ (NSString *_Nonnull)libraryDirectory;

#define WXLibraryPath  [WXUtility libraryDirectory]

/**
 *  @abstract Returns the global cache whose size is 5M.
 *
 */
+ (NSCache *_Nonnull)globalCache;

/**
 * @abstract Returns the main screen's size when the device is in portrait mode,.
 */
+ (CGSize)portraitScreenSize;

/**
 * @abstract Returns the default pixel scale factor
 * @discussion If orientation is equal to landscape, the value is caculated as follows: WXScreenSize().height / WXDefaultScreenWidth, otherwise, WXScreenSize().width / WXDefaultScreenWidth.
 */
+ (CGFloat)defaultPixelScaleFactor;
#if defined __cplusplus
extern "C" {
#endif
/**
 *  @abstract compare float a and b, if a equal b, return true,or reture false.
 *
 */
BOOL HTFloatEqual(CGFloat a, CGFloat b);
/**
 *  @abstract compare float a and b, user give the compare precision, if a equal b, return true,or reture false.
 *
 */
BOOL HTFloatEqualWithPrecision(CGFloat a, CGFloat b ,double precision);
/**
 *  @abstract compare float a and b, if a less than b, return true,or reture false.
 *
 */
BOOL HTFloatLessThan(CGFloat a, CGFloat b);
/**
 *  @abstract compare float a and b,user give the compare precision, if a less than b,return true,or reture false.
 *
 */
BOOL HTFloatLessThanWithPrecision(CGFloat a, CGFloat b,double precision);
/**
 *  @abstract compare float a and b, if a great than b, return true,or reture false.
 *
 */
BOOL HTFloatGreaterThan(CGFloat a, CGFloat b);
/**
 *  @abstract compare float a and b, user give the compare precision,if a great than b, return true,or reture false.
 *
 */
BOOL HTFloatGreaterThanWithPrecision(CGFloat a,CGFloat b,double precision);

/**
 * @abstract Returns the scale of the main screen.
 *
 */
CGFloat HTScreenScale(void);

/**
 * @abstract Returns a Round float coordinates to the main screen pixel.
 *
 */
CGFloat HTRoundPixelValue(CGFloat value);

/**
 * @abstract Returns a Floor float coordinates to the main screen pixel.
 *
 */
CGFloat HTFloorPixelValue(CGFloat value);

/**
 * @abstract Returns a Ceil float coordinates to the main screen pixel.
 *
 */
CGFloat HTCeilPixelValue(CGFloat value);
    
#if defined __cplusplus
};
#endif
/**
 *  @abstract Returns a resized pixel which is calculated according to the WXScreenResizeRadio.
 *
 */
CGFloat HTPixelScale(CGFloat value, CGFloat scaleFactor);

CGFloat HTScreenResizeRadio(void) DEPRECATED_MSG_ATTRIBUTE("Use [HTUtility defaultPixelScaleFactor] instead");
CGFloat HTPixelResize(CGFloat value) DEPRECATED_MSG_ATTRIBUTE("Use HTPixelScale Instead");
CGRect HTPixelFrameResize(CGRect value) DEPRECATED_MSG_ATTRIBUTE("Use HTPixelScale Instead");
CGPoint HTPixelPointResize(CGPoint value) DEPRECATED_MSG_ATTRIBUTE("Use HTPixelScale Instead");

@end

NS_ASSUME_NONNULL_END
