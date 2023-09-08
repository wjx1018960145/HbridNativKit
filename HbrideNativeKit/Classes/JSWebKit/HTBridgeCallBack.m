//
//  HTBridgeCallBack.m
//  HybridForiOS
//
//  Created by wjx on 2020/3/3.
//  Copyright © 2020 WJX. All rights reserved.
//

#import "HTBridgeCallBack.h"

@implementation HTBridgeCallBack
+ (void)wrapResponseCallBack:(HTJBResponseCallback)responseCallBack message:(NSString *)message result:(BOOL)result responseObject:(id)responseObject{
    NSString *realMessage = message?message:@"";
    if (!responseObject) {
        responseObject = @"";
        
    }
    NSDictionary *response = @{
        @"result":@(result),
        @"message":realMessage,
        @"responseObject":responseObject
    };
    
    responseCallBack(response);
    
}
@end
