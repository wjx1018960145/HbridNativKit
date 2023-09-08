//
//  HTResourceLoader.h
//  HybridForiOS
//
//  Created by wjx on 2020/3/10.
//  Copyright © 2020 WJX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTResourceRequest.h"
#import "HTResourceResponse.h"
NS_ASSUME_NONNULL_BEGIN

@interface HTResourceLoader : NSObject
@property (nonatomic, strong) HTResourceRequest *request;

@property (nonatomic, copy) void (^onDataSent)(unsigned long long /* bytesSent */, unsigned long long /* totalBytesToBeSent */);
@property (nonatomic, copy) void (^onResponseReceived)(const HTResourceResponse *);
@property (nonatomic, copy) void (^onDataReceived)(NSData *);
@property (nonatomic, copy) void (^onFinished)(const HTResourceResponse *, NSData *);
@property (nonatomic, copy) void (^onFailed)(NSError *);

- (instancetype)initWithRequest:(HTResourceRequest *)request;

- (void)start;

- (void)cancel:(NSError **)error;
@end

NS_ASSUME_NONNULL_END
