//
//  HTLocationModule.m
//  HybridForiOS
//
//  Created by wjx on 2020/3/17.
//  Copyright © 2020 WJX. All rights reserved.
//

#import "HTLocationModule.h"
#import "CCLocationManager.h"
@implementation HTLocationModule

@synthesize htInstance;

- (BOOL)registerBridge:(nonnull WKWebViewJavascriptBridge *)bridge {
    
    [bridge registerHandler:@"getlocation" handler:^(id  _Nullable data, HTJBResponseCallback  _Nullable responseCallback) {
        
        [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
            if (responseCallback) {responseCallback(@{@"result":@"success",@"data":@{@"Latitude":[NSString stringWithFormat:@"%f",locationCorrrdinate.latitude],@"Longitude":[NSString stringWithFormat:@"%f",locationCorrrdinate.longitude ]}});
            }
               
           }];
    }];
    
    return YES;
}

@end
