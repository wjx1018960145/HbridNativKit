//
//  NSURLRequest+HTImageHttps.h
//  HybridKit
//
//  Created by wjx on 2020/5/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURLRequest (HTImageHttps)
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host;
+ (void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString *)host;
@end

NS_ASSUME_NONNULL_END
