//
//  HTAssert.m
//  HybridForiOS
//
//  Created by wjx on 2020/3/3.
//  Copyright © 2020 WJX. All rights reserved.
//

#import "HTAssert.h"

void HTAssertInternal(NSString *func, NSString *file, int lineNum, NSString *format, ...)
{
    va_list args;
    va_start(args, format);
    NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    
    NSLog(@"%@", message);
    [[NSAssertionHandler currentHandler] handleFailureInFunction:func file:file lineNumber:lineNum description:format, message];
}
