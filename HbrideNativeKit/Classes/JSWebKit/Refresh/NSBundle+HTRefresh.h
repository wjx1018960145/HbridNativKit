//
//  NSBundle+HTRefresh.h
//  HybridForiOS
//
//  Created by wjx on 2020/4/10.
//  Copyright © 2020 WJX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (HTRefresh)
+ (instancetype)ht_refreshBundle;
+ (UIImage *)ht_arrowImage;
+ (NSString *)ht_localizedStringForKey:(NSString *)key value:(nullable NSString *)value;
+ (NSString *)ht_localizedStringForKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
