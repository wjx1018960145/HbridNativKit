//
//  HTStorageModule.m
//  HybridForiOS
//
//  Created by wjx on 2020/3/13.
//  Copyright © 2020 WJX. All rights reserved.
//

#import "HTStorageModule.h"
#import <CommonCrypto/CommonCrypto.h>
#import "HTUtility.h"
#import "HTThreadSafeMutableDictionary.h"
#import "HTThreadSafeMutableArray.h"
#import "HTSDKManager.h"
#import "RSA.h"
#import "NSDictionary+NilSafe.h"
static NSString * const HTStorageDirectory            = @"htstorage";
static NSString * const HTStorageFileName             = @"htstorage.plist";
static NSString * const HTStorageInfoFileName         = @"htstorage.info.plist";
static NSString * const HTStorageIndexFileName        = @"htstorage.index.plist";
static NSUInteger const HTStorageLineLimit            = 1024;
static NSUInteger const HTStorageTotalLimit           = 5 * 1024 * 1024;
static NSString * const HTStorageThreadName           = @"com.chinasofti.huateng.storage";
static NSString * const HTStorageNullValue            = @"#{eulaVlluNegarotSXW}";
@implementation HTStorageModule

@synthesize htInstance;
#pragma mark - Export

- (dispatch_queue_t)targetExecuteQueue {
    return [HTStorageModule storageQueue];
}

- (BOOL)executeRemoveItem:(NSString *)key {
    if ([HTStorageNullValue isEqualToString:self.memory[key]]) {
        [self.memory removeObjectForKey:key];
        NSDictionary *dict = [self.memory copy];
        [self write:dict toFilePath:[HTStorageModule filePath]];
        dispatch_async([HTStorageModule storageQueue], ^{
            NSString *filePath = [HTStorageModule filePathForKey:key];
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
            [[HTUtility globalCache] removeObjectForKey:key];
        });
    } else if (self.memory[key]) {
        [self.memory removeObjectForKey:key];
        NSDictionary *dict = [self.memory copy];
        [self write:dict toFilePath:[HTStorageModule filePath]];
    } else {
        return NO;
    }
    [self removeInfoForKey:key];
    [self removeIndexForKey:key];
    return YES;
}

#pragma mark - Utils
- (void)setObject:(NSString *)obj forKey:(NSString *)key persistent:(BOOL)persistent callback:(HTJBResponseCallback)callback {
    NSString *filePath = [HTStorageModule filePathForKey:key];
    if (obj.length <= HTStorageLineLimit) {
        if ([HTStorageNullValue isEqualToString:self.memory[key]]) {
            [[HTUtility globalCache] removeObjectForKey:key];
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        }
        self.memory[key] = obj;
        NSDictionary *dict = [self.memory copy];
        [self write:dict toFilePath:[HTStorageModule filePath]];
        [self setInfo:@{@"persistent":@(persistent),@"size":@(obj.length)} ForKey:key];
        [self updateIndexForKey:key];
        [self checkStorageLimit];
        if (callback) {
            callback(@{@"result":@"success"});
        }
        return;
    }
    
    [[HTUtility globalCache] setObject:obj forKey:key cost:obj.length];
    
    if (![HTStorageNullValue isEqualToString:self.memory[key]]) {
        self.memory[key] = HTStorageNullValue;
        NSDictionary *dict = [self.memory copy];
        [self write:dict toFilePath:[HTStorageModule filePath]];
    }
    
    dispatch_async([HTStorageModule storageQueue], ^{
        [obj writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    });
    
    [self setInfo:@{@"persistent":@(persistent),@"size":@(obj.length)} ForKey:key];
    [self updateIndexForKey:key];
    
    [self checkStorageLimit];
  
}

- (void)checkStorageLimit {
    NSInteger size = [self totalSize] - HTStorageTotalLimit;
    if (size > 0) {
        [self removeItemsBySize:size];
    }
}

- (void)removeItemsBySize:(NSInteger)size {
    NSArray *indexs = [[self indexs] copy];
    if (size < 0 || indexs.count == 0) {
        return;
    }
    
    NSMutableArray *removedKeys = [NSMutableArray array];
    for (NSInteger i = 0; i < indexs.count; i++) {
        NSString *key = indexs[i];
        NSDictionary *info = [self getInfoForKey:key];
        
        // persistent data, can't be removed
        if ([info[@"persistent"] boolValue]) {
            continue;
        }
        
        [removedKeys addObject:key];
        size -= [info[@"size"] integerValue];
        
        if (size < 0) {
            break;
        }
    }
    
    // actually remove data
    for (NSString *key in removedKeys) {
        [self executeRemoveItem:key];
    }
}

- (void)write:(NSDictionary *)dict toFilePath:(NSString *)filePath{
    [dict writeToFile:filePath atomically:YES];
}

+ (NSString *)filePathForKey:(NSString *)key
{
    NSString *safeFileName = [HTUtility md5:key];
    
    return [[HTStorageModule directory] stringByAppendingPathComponent:safeFileName];
}

+ (void)setupDirectory{
    BOOL isDirectory = NO;
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:[HTStorageModule directory] isDirectory:&isDirectory];
    if (!isDirectory && !fileExists) {
        [[NSFileManager defaultManager] createDirectoryAtPath:[HTStorageModule directory]
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:NULL];
    }
}

+ (NSString *)directory {
    static NSString *storageDirectory = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        storageDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        storageDirectory = [storageDirectory stringByAppendingPathComponent:HTStorageDirectory];
    });
    return storageDirectory;
}

+ (NSString *)filePath {
    static NSString *storageFilePath = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        storageFilePath = [[HTStorageModule directory] stringByAppendingPathComponent:HTStorageFileName];
    });
    return storageFilePath;
}

+ (NSString *)infoFilePath {
    static NSString *infoFilePath = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        infoFilePath = [[HTStorageModule directory] stringByAppendingPathComponent:HTStorageInfoFileName];
    });
    return infoFilePath;
}

+ (NSString *)indexFilePath {
    static NSString *indexFilePath = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        indexFilePath = [[HTStorageModule directory] stringByAppendingPathComponent:HTStorageIndexFileName];
    });
    return indexFilePath;
}


+ (dispatch_queue_t)storageQueue {
    static dispatch_queue_t storageQueue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        storageQueue = dispatch_queue_create("com.chinasofti.huateng.storage", DISPATCH_QUEUE_SERIAL);
    });
    return storageQueue;
}
+ (HTThreadSafeMutableDictionary<NSString *, NSString *> *)memory {
    static HTThreadSafeMutableDictionary<NSString *,NSString *> *memory;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [HTStorageModule setupDirectory];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:[HTStorageModule filePath]]) {
            NSDictionary *contents = [NSDictionary dictionaryWithContentsOfFile:[HTStorageModule filePath]];
            if (contents) {
                memory = [[HTThreadSafeMutableDictionary alloc] initWithDictionary:contents];
            }
        }
        if (!memory) {
            memory = [HTThreadSafeMutableDictionary new];
        }
//        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidReceiveMemoryWarningNotification object:nil queue:nil usingBlock:^(__unused NSNotification *note) {
//            [memory removeAllObjects];
//        }];
    });
    return memory;
}

+ (HTThreadSafeMutableDictionary<NSString *, NSDictionary *> *)info {
    static HTThreadSafeMutableDictionary<NSString *,NSDictionary *> *info;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [HTStorageModule setupDirectory];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:[HTStorageModule infoFilePath]]) {
            NSDictionary *contents = [NSDictionary dictionaryWithContentsOfFile:[HTStorageModule infoFilePath]];
            if (contents) {
                info = [[HTThreadSafeMutableDictionary alloc] initWithDictionary:contents];
            }
        }
        if (!info) {
            info = [HTThreadSafeMutableDictionary new];
        }
    });
    return info;
}

+ (HTThreadSafeMutableArray *)indexs {
    static HTThreadSafeMutableArray *indexs;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [HTStorageModule setupDirectory];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:[HTStorageModule indexFilePath]]) {
            NSArray *contents = [NSArray arrayWithContentsOfFile:[HTStorageModule indexFilePath]];
            if (contents) {
                indexs = [[HTThreadSafeMutableArray alloc] initWithArray:contents];
            }
        }
        if (!indexs) {
            indexs = [HTThreadSafeMutableArray new];
        }
    });
    return indexs;
}

- (HTThreadSafeMutableDictionary<NSString *, NSString *> *)memory {
    return [HTStorageModule memory];
}

- (HTThreadSafeMutableDictionary<NSString *, NSDictionary *> *)info {
    return [HTStorageModule info];
}

- (HTThreadSafeMutableArray *)indexs {
    return [HTStorageModule indexs];
}

- (BOOL)checkInput:(id)input{
    return !([input isKindOfClass:[NSString class]] || [input isKindOfClass:[NSNumber class]]);
}

#pragma mark
#pragma mark - Storage Info method
- (NSDictionary *)getInfoForKey:(NSString *)key {
    NSDictionary *info = [[self info] objectForKey:key];
    if (!info) {
        return nil;
    }
    return info;
}

- (void)setInfo:(NSDictionary *)info ForKey:(NSString *)key {
    NSAssert(info, @"info must not be nil"); //!OCLint
    
    // save info for key
    NSMutableDictionary *newInfo = [NSMutableDictionary dictionaryWithDictionary:info];
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    [newInfo setObject:@(interval) forKey:@"ts"];
    
    [[self info] setObject:[newInfo copy] forKey:key];
    NSDictionary *dict = [[self info] copy];
    [self write:dict toFilePath:[HTStorageModule infoFilePath]];
}

- (void)removeInfoForKey:(NSString *)key {
    [[self info] removeObjectForKey:key];
    NSDictionary *dict = [[self info] copy];
    [self write:dict toFilePath:[HTStorageModule infoFilePath]];
}

- (void)updateTimestampForKey:(NSString *)key {
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    NSDictionary *info = [[self info] objectForKey:key];
    if (!info) {
        info = @{@"persistent":@(NO),@"size":@(0),@"ts":@(interval)};
    } else {
        NSMutableDictionary *newInfo = [NSMutableDictionary dictionaryWithDictionary:info];
        [newInfo setObject:@(interval) forKey:@"ts"];
        info = [newInfo copy];
    }
    
    [[self info] setObject:info forKey:key];
    NSDictionary *dict = [[self info] copy];
    [self write:dict toFilePath:[HTStorageModule infoFilePath]];
}

- (NSInteger)totalSize {
    NSInteger totalSize = 0;
    for (NSDictionary *info in [self info].allValues) {
        totalSize += (info[@"size"] ? [info[@"size"] integerValue] : 0);
    }
    return totalSize;
}

#pragma mark
#pragma mark - Storage Index method
- (void)updateIndexForKey:(NSString *)key {
    [[self indexs] removeObject:key];
    [[self indexs] addObject:key];
    [self write:[[self indexs] copy] toFilePath:[HTStorageModule indexFilePath]];
}

- (void)removeIndexForKey:(NSString *)key {
    [[self indexs] removeObject:key];
    [self write:[[self indexs] copy] toFilePath:[HTStorageModule indexFilePath]];
}

- (BOOL)registerBridge:(nonnull WKWebViewJavascriptBridge *)bridge {
    
    [bridge registerHandler:@"length" handler:^(id  _Nullable data, HTJBResponseCallback  _Nullable responseCallback) {
        if (responseCallback) {
        responseCallback(@{@"result":@"success",@"data":@([[HTStorageModule memory] count])});
        }
    }];
    [bridge registerHandler:@"getItem" handler:^(id  _Nullable data, HTJBResponseCallback  _Nullable responseCallback) {
        if ([self checkInput:data]) {
               if (responseCallback) {
                   responseCallback(@{@"result":@"failed",@"data":@"key must a string or number!"}); // forgive my english
               }
               return;
           }
           
           if ([data isKindOfClass:[NSNumber class]]) {
               data = [((NSNumber *)data) stringValue]; // oh no!
           }
           
           if ([HTUtility isBlankString:data]) {
               if (responseCallback) {
                   responseCallback(@{@"result":@"failed",@"data":@"invalid_param"});
               }
               return ;
           }
           
           NSString *value = [self.memory objectForKey:data];
           if ([HTStorageNullValue isEqualToString:value]) {
               value = [[HTUtility globalCache] objectForKey:data];
               if (!value) {
                   NSString *filePath = [HTStorageModule filePathForKey:data];
                   NSString *contents = [HTUtility stringWithContentsOfFile:filePath];
                   
                   if (contents) {
                       [[HTUtility globalCache] setObject:contents forKey:data cost:contents.length];
                       value = contents;
                   }
               }
           }
           if (!value) {
               [self executeRemoveItem:data];
               if (responseCallback) {
                   responseCallback(@{@"result":@"failed",@"data":@"undefined"});
               }
               return;
           }
           [self updateTimestampForKey:data];
           [self updateIndexForKey:data];
           if (responseCallback) {
               responseCallback(@{@"result":@"success",@"data":value});
           }
    }];
    [bridge registerHandler:@"setItem" handler:^(id  _Nullable data, HTJBResponseCallback  _Nullable responseCallback) {
        NSArray *allKey = [data allKeys];
        if (allKey.count==0) {
            responseCallback(@{@"result":@"failed",@"data":@"data is null"});
                   
        }
        for (int i = 0; i<allKey.count; i++) {
            id key = allKey[i];
            id value =[data objectForKey:allKey[i]];
         
           if ([self checkInput:key]) {
               if (responseCallback) {
                   responseCallback(@{@"result":@"failed",@"data":@"key must a string or number!"});
               }
               return;
           }
           if ([self checkInput:value]) {
               if (responseCallback) {
                   responseCallback(@{@"result":@"failed",@"data":@"value must a string or number!"});
               }
               return;
           }
           
           if ([key isKindOfClass:[NSNumber class]]) {
               key = [((NSNumber *)key) stringValue];
           }
           
           if ([value isKindOfClass:[NSNumber class]]) {
               value = [((NSNumber *)value) stringValue];
           }
           
           if ([HTUtility isBlankString:key]) {
               if (responseCallback) {
                   responseCallback(@{@"result":@"failed",@"data":@"invalid_param"});
               }
               return ;
           }
           
           [self setObject:value forKey:key persistent:NO callback:responseCallback];
            
        }
        
        if (responseCallback) {
              responseCallback(@{@"result":@"success"});
          }
       
        
        
        
    }];
    [bridge registerHandler:@"setItemPersistent" handler:^(id  _Nullable data, HTJBResponseCallback  _Nullable responseCallback) {
        NSArray *allKey = [data allKeys];
        
        if (allKey.count==0) {
            responseCallback(@{@"result":@"failed",@"data":@"data is null"});
            
        }
        
        for (int i = 0; i<allKey.count; i++) {
            id key = allKey[i];
            id value = [data objectForKey:allKey[i]];
            if ([self checkInput:key]) {
                  if (responseCallback) {
                      responseCallback(@{@"result":@"failed",@"data":@"key must a string or number!"});
                  }
                  return;
              }
              if ([self checkInput:value]) {
                  if (responseCallback) {
                      responseCallback(@{@"result":@"failed",@"data":@"value must a string or number!"});
                  }
                  return;
              }
              
              if ([key isKindOfClass:[NSNumber class]]) {
                  key = [((NSNumber *)key) stringValue];
              }
              
              if ([value isKindOfClass:[NSNumber class]]) {
                  value = [((NSNumber *)value) stringValue];
              }
              
              if ([HTUtility isBlankString:key]) {
                  if (responseCallback) {
                      responseCallback(@{@"result":@"failed",@"data":@"invalid_param"});
                  }
                  return ;
              }
              [self setObject:value forKey:key persistent:YES callback:responseCallback];
    
        }
        
       
       
        
        
        
        
    }];
    [bridge registerHandler:@"getAllKeys" handler:^(id  _Nullable data, HTJBResponseCallback  _Nullable responseCallback) {
        if (responseCallback) {
               responseCallback(@{@"result":@"success",@"data":[HTStorageModule memory].allKeys});
           }
    }];
    [bridge registerHandler:@"removeItem" handler:^(id  _Nullable data, HTJBResponseCallback  _Nullable responseCallback) {
//        NSArray *allKey = [data allKeys];
        id key = data;
//        id value = [data objectForKey:allKey[0]];
        if ([self checkInput:key]) {
               if (responseCallback) {
                   responseCallback(@{@"result":@"failed",@"data":@"key must a string or number!"});
               }
               return;
           }
           
           if ([key isKindOfClass:[NSNumber class]]) {
               key = [((NSNumber *)key) stringValue];
           }
           
           if ([HTUtility isBlankString:key]) {
               if (responseCallback) {
                   responseCallback(@{@"result":@"failed",@"data":@"invalid_param"});
               }
               return ;
           }
           BOOL removed = [self executeRemoveItem:key];
           if (removed) {
               if (responseCallback) {
                   responseCallback(@{@"result":@"success"});
               }
           } else {
               if (responseCallback) {
                   responseCallback(@{@"result":@"failed"});
               }
           }
    }];
    
    [bridge registerHandler:@"RSAenc" handler:^(id  _Nullable data, HTJBResponseCallback  _Nullable responseCallback) {
        
        NSError *parseError =nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:&parseError];
        
        NSString *originString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if (!originString) {
            responseCallback(@{@"result":@"error",@"data":@"参数错误"});
        }
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"pubkey" ofType:@"json"];
        NSData * cerData = [NSData dataWithContentsOfFile:path];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:cerData options:NSJSONReadingFragmentsAllowed error:nil];
        if(!dic[@"pubkey"]){
            responseCallback(@{@"result":@"error",@"data":@"公钥未配置"});
        }
        
        
        
        NSString *  encWithPubKey = [RSA encryptString:originString publicKey:dic[@"pubkey"]];
        
        responseCallback(@{@"result":@"success",@"data":encWithPubKey});
        
    }];
    
    return YES;
    
}



@end
