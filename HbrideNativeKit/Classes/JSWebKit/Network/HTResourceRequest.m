//
//  HTResourceRequest.m
//  HybridForiOS
//
//  Created by wjx on 2020/3/10.
//  Copyright © 2020 WJX. All rights reserved.
//

#import "HTResourceRequest.h"
static NSString * const kHTTPHeaderNameUserAgent = @"User-Agent";
static NSString * const kHTTPHeaderNameReferrer = @"Referer"; // The misspelling referer originated in the original proposal by computer "scientist" Phillip Hallam-Baker to incorporate the field into the HTTP specification. ╮(╯_╰)╭
@implementation HTResourceRequest

+ (instancetype)requestWithURL:(NSURL *)url
                  resourceType:(HTResourceType)type
                      referrer:(NSString *)referrer
                   cachePolicy:(NSURLRequestCachePolicy)cachePolicy
{
    return [[self alloc] initWithURL:url resourceType:type referrer:referrer cachePolicy:cachePolicy];
}

- (instancetype)initWithURL:(NSURL *)url
               resourceType:(HTResourceType)type
                   referrer:(NSString *)referrer cachePolicy:(NSURLRequestCachePolicy)cachePolicy
{
    if (self = [super initWithURL:url]) {
        self.type = type;
        self.cachePolicy = cachePolicy;
        [self setValue:referrer forHTTPHeaderField:kHTTPHeaderNameReferrer];
    }
    
    return self;
}

- (NSString *)referrer
{
    return [self valueForHTTPHeaderField:kHTTPHeaderNameReferrer];
}

- (void)setReferrer:(NSString *)referrer
{
    [self setValue:referrer forHTTPHeaderField:kHTTPHeaderNameReferrer];
}

- (NSString *)userAgent
{
    return [self valueForHTTPHeaderField:kHTTPHeaderNameUserAgent];
}

- (void)setUserAgent:(NSString *)userAgent
{
    [self setValue:userAgent forHTTPHeaderField:kHTTPHeaderNameUserAgent];
}
@end
