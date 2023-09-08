//
//  NSURLRequest+HTImageHttps.m
//  HybridKit
//
//  Created by wjx on 2020/5/9.
//

#import "NSURLRequest+HTImageHttps.h"

@implementation NSURLRequest (HTImageHttps)
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host {
    return YES;
}

+ (void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString *)host {
    
}
@end
