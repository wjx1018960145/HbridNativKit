//
//  HTResourceRequest.h
//  HybridForiOS
//
//  Created by wjx on 2020/3/10.
//  Copyright © 2020 WJX. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    HTResourceTypeMainBundle,
    HTResourceTypeServiceBundle,
    HTResourceTypeImage,
    HTResourceTypeFont,
    HTResourceTypeVideo,
    HTResourceTypeLink,
    HTResourceTypeOthers
} HTResourceType;

@interface HTResourceRequest : NSMutableURLRequest

@property (nonatomic, strong) id taskIdentifier;
@property (nonatomic, assign) HTResourceType type;

@property (nonatomic, strong) NSString *referrer;
@property (nonatomic, strong) NSString *userAgent;

+ (instancetype)requestWithURL:(NSURL *)url
                  resourceType:(HTResourceType)type
                      referrer:(NSString * _Nullable)referrer
                   cachePolicy:(NSURLRequestCachePolicy)cachePolicy;
@end

NS_ASSUME_NONNULL_END
