//
//  NSData+ImageContentType.h
//  HybridForiOS
//
//  Created by wjx on 2020/3/17.
//  Copyright © 2020 WJX. All rights reserved.
//



#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (ImageContentType)

/**
 *  Compute the content type for an image data
 *
 *  @param data the input data
 *
 *  @return the content type as string (i.e. image/jpeg, image/gif)
 */
+ (NSString *)ht_contentTypeForImageData:(NSData *)data;

@end


@interface NSData (ImageContentTypeDeprecated)

+ (NSString *)contentTypeForImageData:(NSData *)data __deprecated_msg("Use `sd_contentTypeForImageData:`");
@end

NS_ASSUME_NONNULL_END
