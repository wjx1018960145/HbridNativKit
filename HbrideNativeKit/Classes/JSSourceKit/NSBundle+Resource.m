//
//  NSBundle+Resource.m
//  HybridForiOS
//
//  Created by wjx on 2020/3/2.
//  Copyright © 2020 WJX. All rights reserved.
//

#import "NSBundle+Resource.h"

//#import <AppKit/AppKit.h>


@implementation NSBundle (Resource)

+ (NSBundle*)bundleName:(NSString*)bundleName {
    NSString *path = [[NSBundle mainBundle] pathForResource:bundleName ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:path];
    return bundle;
    
}
@end
