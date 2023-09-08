//
//  ReplacingImageURLProtocol.m
//  NSURLProtocol+WebKitSupport
//
//  Created by yeatse on 2016/10/11.
//  Copyright © 2016年 Yeatse. All rights reserved.
//

#import "ReplacingImageURLProtocol.h"
#import "UIImageView+WebCache.h"
#import "NSData+ImageContentType.h"
#import "UIImage+MultiFormat.h"

#import <UIKit/UIKit.h>

static NSString* const FilteredKey = @"FilteredKey";
@interface ReplacingImageURLProtocol()
@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) NSURLConnection *connection;
@end
@implementation ReplacingImageURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    NSString* extension = request.URL.pathExtension;

    BOOL isImage = [[self resourceTypes] indexOfObjectPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       // NSLog(@"%@",obj);
        return [extension compare:obj options:NSCaseInsensitiveSearch] == NSOrderedSame;
    }] != NSNotFound;
    return [NSURLProtocol propertyForKey:FilteredKey inRequest:request] == nil && isImage;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

- (void)startLoading {
    
    NSURL *url = super.request.URL;
    
    NSString *requestUrl = url.absoluteString;
    NSString *reqiestPath = url.pathExtension;
    NSMutableURLRequest* request = self.request.mutableCopy;
     //标记该请求已经处理
    [NSURLProtocol setProperty:@YES forKey:FilteredKey inRequest:request];
    
    NSString *fileName = [NSString stringWithFormat:@"%@",requestUrl];


    NSData* data = UIImagePNGRepresentation([UIImage imageNamed:@"image"]);
    NSURLResponse* response = [[NSURLResponse alloc] initWithURL:self.request.URL MIMEType:@"image/png" expectedContentLength:data.length textEncodingName:nil];
    
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowed];
    [self.client URLProtocol:self didLoadData:data];
    [self.client URLProtocolDidFinishLoading:self];
}

- (void)stopLoading {
    NSLog(@"stopLoading from networld");
       if (self.connection) {
           [self.connection cancel];
       }
}

+ (NSArray *)resourceTypes{
    return @[@"png", @"jpeg", @"gif", @"jpg",@"jpg",@"json" ,@"mp3",@"fnt"];
}


#pragma mark- NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    [self.client URLProtocol:self didFailWithError:error];
}

#pragma mark - NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.responseData = [[NSMutableData alloc] init];
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
    [self.client URLProtocol:self didLoadData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    //缓存图片
    UIImage *cacheImage = [UIImage ht_imageWithData:self.responseData];
    NSString *key = [[HTWebImageManager sharedManager] cacheKeyForURL:self.request.URL];
    
    [[HTImageCache sharedImageCache] storeImage:cacheImage
                           recalculateFromImage:NO
                                      imageData:self.responseData
                                         forKey:key
                                         toDisk:YES];
    
    [self.client URLProtocolDidFinishLoading:self];
}

@end

