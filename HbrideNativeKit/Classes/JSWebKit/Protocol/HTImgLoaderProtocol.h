//
//  HTImgLoaderProtocol.h
//  HybridForiOS
//
//  Created by wjx on 2020/3/11.
//  Copyright © 2020 WJX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HTType.h"
#import "HTWebBridgeProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@protocol HTImageOperationProtocol <NSObject>

- (void)cancel;

@end
typedef NS_ENUM(NSInteger, HTImageLoaderCacheType) {
    /**
     * The image wasn't available the imageLoad caches, but was downloaded from the web.
     */
    HTImageLoaderCacheTypeNone,
    /**
     * The image was obtained from the disk cache.
     */
    HTImageLoaderCacheTypeDisk,
    /**
     * The image was obtained from the memory cache.
     */
    HTImageLoaderCacheTypeMemory
};

@protocol HTImgLoaderProtocol <HTWebBridgeProtocol>

/**
 * @abstract Creates a image download handler with a given URL
 *
 * @param url The URL of the image to download
 *
 * @param imageFrame  The frame of the image you want to set
 *
 * @param options : The options to be used for this download
 *
 * @param completedBlock : A block called once the download is completed.
 *                 image : the image which has been download to local.
 *                 error : the error which has happened in download.
 *              finished : a Boolean value indicating whether download action has finished.
 */
- (id<HTImageOperationProtocol>)downloadImageWithURL:(NSString *)url imageFrame:(CGRect)imageFrame userInfo:(NSDictionary * _Nullable)options completed:(void(^)(UIImage * _Nullable image,  NSError * _Nullable error, BOOL finished))completedBlock;

@optional

/**
 * @abstract Creates a image download handler with a given URL
 *
 * @param imageView UIImageView to display the image
 *
 * @param url The URL of the image to download
 *
 * @param placeholder The image to be set initially, until the image request finishes.
 *
 * @param options : The options to be used for download operation
 *
 * @param progressBlock : A block called while the download start
 *
 * @param completedBlock : A block called once the download is completed.
 *                 image : the image which has been download to local.
 *                 error : the error which has happened in download.
 *              finished : a Boolean value indicating whether download action has finished.
 */
- (void)setImageViewWithURL:(UIImageView*)imageView
                        url:(NSURL *)url
           placeholderImage:(UIImage * _Nullable)placeholder
                    options:(NSDictionary* _Nullable)options
                   progress:(nullable void (^)(NSInteger receivedSize, NSInteger expectedSize))progressBlock
                  completed:(nullable void(^)(UIImage *_Nullable image, NSError *_Nullable error, HTImageLoaderCacheType cacheType, NSURL *imageURL))completedBlock;

/**
 * Cancel the current download image
 */
- (void)cancelCurrentImageLoad:(UIImageView*)imageView;
@end

NS_ASSUME_NONNULL_END
