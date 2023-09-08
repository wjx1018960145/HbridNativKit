//
//  UIImageView+HighlightedWebCache.m
//  HybridForiOS
//
//  Created by wjx on 2020/3/17.
//  Copyright © 2020 WJX. All rights reserved.
//

#import "UIImageView+HighlightedWebCache.h"
#import "UIVew+WebCacheOperation.h"
#define UIImageViewHighlightedWebCacheOperationKey @"highlightedImage"

@implementation UIImageView (HighlightedWebCache)
- (void)ht_setHighlightedImageWithURL:(NSURL *)url {
    [self ht_setHighlightedImageWithURL:url options:0 progress:nil completed:nil];
}

- (void)ht_setHighlightedImageWithURL:(NSURL *)url options:(HTWebImageOptions)options {
    [self ht_setHighlightedImageWithURL:url options:options progress:nil completed:nil];
}

- (void)ht_setHighlightedImageWithURL:(NSURL *)url completed:(HTWebImageCompletionBlock)completedBlock {
    [self ht_setHighlightedImageWithURL:url options:0 progress:nil completed:completedBlock];
}

- (void)ht_setHighlightedImageWithURL:(NSURL *)url options:(HTWebImageOptions)options completed:(HTWebImageCompletionBlock)completedBlock {
    [self ht_setHighlightedImageWithURL:url options:options progress:nil completed:completedBlock];
}

- (void)ht_setHighlightedImageWithURL:(NSURL *)url options:(HTWebImageOptions)options progress:(HTWebImageDownloaderProgressBlock)progressBlock completed:(HTWebImageCompletionBlock)completedBlock {
    [self ht_cancelCurrentHighlightedImageLoad];

    if (url) {
        __weak __typeof(self)wself = self;
        id<HTWebImageOperation> operation = [HTWebImageManager.sharedManager downloadImageWithURL:url options:options progress:progressBlock completed:^(UIImage *image, NSError *error, HTImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (!wself) return;
            dispatch_main_sync_safe (^
                                     {
                                         if (!wself) return;
                                         if (image && (options & HTWebImageAvoidAutoSetImage) && completedBlock)
                                         {
                                             completedBlock(image, error, cacheType, url);
                                             return;
                                         }
                                         else if (image) {
                                             wself.highlightedImage = image;
                                             [wself setNeedsLayout];
                                         }
                                         if (completedBlock && finished) {
                                             completedBlock(image, error, cacheType, url);
                                         }
                                     });
        }];
        [self ht_setImageLoadOperation:operation forKey:UIImageViewHighlightedWebCacheOperationKey];
    } else {
        dispatch_main_async_safe(^{
            NSError *error = [NSError errorWithDomain:HTWebImageErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
            if (completedBlock) {
                completedBlock(nil, error, HTImageCacheTypeNone, url);
            }
        });
    }
}

- (void)sd_cancelCurrentHighlightedImageLoad {
    [self ht_cancelImageLoadOperationWithKey:UIImageViewHighlightedWebCacheOperationKey];
}

@end
@implementation UIImageView (HighlightedWebCacheDeprecated)

- (void)setHighlightedImageWithURL:(NSURL *)url {
    [self ht_setHighlightedImageWithURL:url options:0 progress:nil completed:nil];
}

- (void)setHighlightedImageWithURL:(NSURL *)url options:(HTWebImageOptions)options {
    [self ht_setHighlightedImageWithURL:url options:options progress:nil completed:nil];
}

- (void)setHighlightedImageWithURL:(NSURL *)url completed:(HTWebImageCompletedBlock)completedBlock {
    [self ht_setHighlightedImageWithURL:url options:0 progress:nil completed:^(UIImage *image, NSError *error, HTImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, cacheType);
        }
    }];
}

- (void)setHighlightedImageWithURL:(NSURL *)url options:(HTWebImageOptions)options completed:(HTWebImageCompletedBlock)completedBlock {
    [self ht_setHighlightedImageWithURL:url options:options progress:nil completed:^(UIImage *image, NSError *error, HTImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, cacheType);
        }
    }];
}

- (void)setHighlightedImageWithURL:(NSURL *)url options:(HTWebImageOptions)options progress:(HTWebImageDownloaderProgressBlock)progressBlock completed:(HTWebImageCompletedBlock)completedBlock {
    [self ht_setHighlightedImageWithURL:url options:0 progress:progressBlock completed:^(UIImage *image, NSError *error, HTImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, cacheType);
        }
    }];
}

- (void)cancelCurrentHighlightedImageLoad {
    [self ht_cancelCurrentHighlightedImageLoad];
}

@end
