//
//  HTLog.h
//  HybridForiOS
//
//  Created by wjx on 2020/3/6.
//  Copyright © 2020 WJX. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define HTLogLevel HtLogLevel

typedef NS_ENUM(NSInteger, HTLogFlag) {
    HTLogFlagError      = 1 << 0,
    HTLogFlagWarning    = 1 << 1,
    HTLogFlagInfo       = 1 << 2,
    HTLogFlagLog        = 1 << 3,
    HTLogFlagDebug      = 1 << 4
};

/**
 *  Use Log levels to filter logs.
 */
typedef NS_ENUM(NSUInteger, HtLogLevel){
    /**
     *  No logs
     */
    HTLogLevelOff       = 0,
    
    /**
     *  Error only
     */
    HTLogLevelError     = HTLogFlagError,
    
    /**
     *  Error and warning
     */
    HTLogLevelWarning   = HTLogLevelError | HTLogFlagWarning,
    
    /**
     *  Error, warning and info
     */
    HTLogLevelInfo      = HTLogLevelWarning | HTLogFlagInfo,
    
    /**
     *  Log, warning info
     */
    HTLogLevelLog       = HTLogFlagLog | HTLogLevelInfo,
    
    /**
     *  Error, warning, info and debug logs
     */
    HTLogLevelDebug     = HTLogLevelLog | HTLogFlagDebug,
    
    /**
     *  All
     */
    HTLogLevelAll       = NSUIntegerMax
};

@protocol HTLogProtocol <NSObject>

@required

/**
 * External log level.
 */
- (HTLogLevel)logLevel;

- (void)log:(HTLogFlag)flag message:(NSString *)message;

@end

@interface HTLog : NSObject
+ (HTLogLevel)logLevel;

+ (void)setLogLevel:(HTLogLevel)level;

+ (NSString *)logLevelString;

+ (void)setLogLevelString:(NSString *)levelString;


+ (void)log:(HTLogFlag)flag file:(const char *)fileName line:(NSUInteger)line message:(NSString *)message;

+ (void)devLog:(HTLogFlag)flag file:(const char *)fileName line:(NSUInteger)line format:(NSString *)format, ... NS_FORMAT_FUNCTION(4,5);

+ (void)registerExternalLog:(id<HTLogProtocol>)externalLog;

+ (id<HTLogProtocol>)getCurrentExternalLog;

@end

#define HT_FILENAME (strrchr(__FILE__, '/') ? strrchr(__FILE__, '/') + 1 : __FILE__)

 
#define HT_LOG(flag, fmt, ...)          \
do {                                    \
    [HTLog devLog:flag                     \
             file:HT_FILENAME              \
             line:__LINE__                 \
           format:(fmt), ## __VA_ARGS__];  \
} while(0)

extern void _HTLogObjectsImpl(NSString *severity, NSArray *arguments);

#define HTLog(format,...)               HT_LOG(HTLogFlagLog, format, ##__VA_ARGS__)
#define HTLogDebug(format, ...)         HT_LOG(HTLogFlagDebug, format, ##__VA_ARGS__)
#define HTLogInfo(format, ...)          HT_LOG(HTLogFlagInfo, format, ##__VA_ARGS__)
#define HTLogWarning(format, ...)       HT_LOG(HTLogFlagWarning, format ,##__VA_ARGS__)
#define HTLogError(format, ...)         HT_LOG(HTLogFlagError, format, ##__VA_ARGS__)

NS_ASSUME_NONNULL_END

