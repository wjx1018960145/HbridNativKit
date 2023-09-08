//
//  HTScanResult.m
//  HybridForiOS
//
//  Created by wjx on 2020/3/25.
//  Copyright © 2020 WJX. All rights reserved.
//

#import "HTScanResult.h"


@implementation HTScanResult

- (instancetype)initWithScanString:(NSString*)str imgScan:(UIImage*)img barCodeType:(NSString*)type
{
    if (self = [super init]) {
        
        self.strScanned = str;
        self.imgScanned = img;
        self.strBarCodeType = type;
    }
    
    return self;
}
@end
