//
//  NSURLSession+CorrectedResumeData.h
//  HybridForiOS
//
//  Created by wjx on 2020/3/23.
//  Copyright © 2020 WJX. All rights reserved.
//




#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURLSession (CorrectedResumeData)

- (NSURLSessionDownloadTask *)downloadTaskWithCorrectResumeData:(NSData *)resumeData;
@end

NS_ASSUME_NONNULL_END
