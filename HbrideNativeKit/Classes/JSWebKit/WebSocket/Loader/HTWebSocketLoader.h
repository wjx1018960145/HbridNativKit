//
//  HTWebSocketLoader.h
//  HybridForiOS
//
//  Created by wjx on 2020/3/10.
//  Copyright © 2020 WJX. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTWebSocketLoader : NSObject<NSCopying>

@property (nonatomic, copy) void (^onOpen)(void);
@property (nonatomic, copy) void (^onReceiveMessage)(id);
@property (nonatomic, copy) void (^onClose)(NSInteger,NSString *,BOOL);
@property (nonatomic, copy) void (^onFail)(NSError *);

- (instancetype)initWithUrl:(NSString *)url protocol:(NSString *)protocol;
- (void)open;
- (void)send:(id)data;
- (void)close;
- (void)close:(NSInteger)code reason:(NSString *)reason;
- (void)clear;
@end

NS_ASSUME_NONNULL_END
