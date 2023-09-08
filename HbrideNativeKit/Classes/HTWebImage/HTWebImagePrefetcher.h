//
//  HTWebImagePrefetcher.h
//  HybridForiOS
//
//  Created by wjx on 2020/3/17.
//  Copyright © 2020 WJX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTWebImageManager.h"
NS_ASSUME_NONNULL_BEGIN

@class HTWebImagePrefetcher;

@protocol HTWebImagePrefetcherDelegate <NSObject>

@optional

/**
 * Called when an image was prefetched.
 *
 * @param imagePrefetcher The current image prefetcher
 * @param imageURL        The image url that was prefetched
 * @param finishedCount   The total number of images that were prefetched (successful or not)
 * @param totalCount      The total number of images that were to be prefetched
 */
- (void)imagePrefetcher:(HTWebImagePrefetcher *)imagePrefetcher didPrefetchURL:(NSURL *)imageURL finishedCount:(NSUInteger)finishedCount totalCount:(NSUInteger)totalCount;

/**
 * Called when all images are prefetched.
 * @param imagePrefetcher The current image prefetcher
 * @param totalCount      The total number of images that were prefetched (whether successful or not)
 * @param skippedCount    The total number of images that were skipped
 */
- (void)imagePrefetcher:(HTWebImagePrefetcher *)imagePrefetcher didFinishWithTotalCount:(NSUInteger)totalCount skippedCount:(NSUInteger)skippedCount;

@end

typedef void(^HTWebImagePrefetcherProgressBlock)(NSUInteger noOfFinishedUrls, NSUInteger noOfTotalUrls);
typedef void(^HTWebImagePrefetcherCompletionBlock)(NSUInteger noOfFinishedUrls, NSUInteger noOfSkippedUrls);

@interface HTWebImagePrefetcher : NSObject
/**
 *  The web image manager
 */
@property (strong, nonatomic, readonly) HTWebImageManager *manager;

/**
 * Maximum number of URLs to prefetch at the same time. Defaults to 3.
 */
@property (nonatomic, assign) NSUInteger maxConcurrentDownloads;

/**
 * SDWebImageOptions for prefetcher. Defaults to SDWebImageLowPriority.
 */
@property (nonatomic, assign) HTWebImageOptions options;

/**
 * Queue options for Prefetcher. Defaults to Main Queue.
 */
@property (nonatomic, assign) dispatch_queue_t prefetcherQueue;

@property (weak, nonatomic) id <HTWebImagePrefetcherDelegate> delegate;

/**
 * Return the global image prefetcher instance.
 */
+ (HTWebImagePrefetcher *)sharedImagePrefetcher;

/**
 * Allows you to instantiate a prefetcher with any arbitrary image manager.
 */
- (id)initWithImageManager:(HTWebImageManager *)manager;

/**
 * Assign list of URLs to let SDWebImagePrefetcher to queue the prefetching,
 * currently one image is downloaded at a time,
 * and skips images for failed downloads and proceed to the next image in the list
 *
 * @param urls list of URLs to prefetch
 */
- (void)prefetchURLs:(NSArray *)urls;

/**
 * Assign list of URLs to let SDWebImagePrefetcher to queue the prefetching,
 * currently one image is downloaded at a time,
 * and skips images for failed downloads and proceed to the next image in the list
 *
 * @param urls            list of URLs to prefetch
 * @param progressBlock   block to be called when progress updates;
 *                        first parameter is the number of completed (successful or not) requests,
 *                        second parameter is the total number of images originally requested to be prefetched
 * @param completionBlock block to be called when prefetching is completed
 *                        first param is the number of completed (successful or not) requests,
 *                        second parameter is the number of skipped requests
 */
- (void)prefetchURLs:(NSArray *)urls progress:(HTWebImagePrefetcherProgressBlock)progressBlock completed:(HTWebImagePrefetcherCompletionBlock)completionBlock;

/**
 * Remove and cancel queued list
 */
- (void)cancelPrefetching;


@end

NS_ASSUME_NONNULL_END
