//
//  UIImageView+WebCache.m
//  HybridForiOS
//
//  Created by wjx on 2020/3/17.
//  Copyright © 2020 WJX. All rights reserved.
//

#import "UIImageView+WebCache.h"


#import "objc/runtime.h"
#import "UIVew+WebCacheOperation.h"
static char imageURLKey;
static char TAG_ACTIVITY_INDICATOR;
static char TAG_ACTIVITY_STYLE;
static char TAG_ACTIVITY_SHOW;
@implementation UIImageView (WebCache)

- (void)ht_setImageWithURL:(NSURL *)url {
    [self ht_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:nil];
}

- (void)ht_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder {
    [self ht_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:nil];
}

- (void)ht_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(HTWebImageOptions)options {
    [self ht_setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:nil];
}

- (void)ht_setImageWithURL:(NSURL *)url completed:(HTWebImageCompletionBlock)completedBlock {
    [self ht_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:completedBlock];
}

- (void)ht_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(HTWebImageCompletionBlock)completedBlock {
    [self ht_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:completedBlock];
}

- (void)ht_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(HTWebImageOptions)options completed:(HTWebImageCompletionBlock)completedBlock {
    [self ht_setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:completedBlock];
}

- (void)ht_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(HTWebImageOptions)options progress:(HTWebImageDownloaderProgressBlock)progressBlock completed:(HTWebImageCompletionBlock)completedBlock {
    [self ht_cancelCurrentImageLoad];
    objc_setAssociatedObject(self, &imageURLKey, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    if (!(options & HTWebImageDelayPlaceholder)) {
        dispatch_main_async_safe(^{
            self.image = placeholder;
        });
    }
    
    if (url) {

        // check if activityView is enabled or not
        if ([self showActivityIndicatorView]) {
            [self addActivityIndicator];
        }

        __weak __typeof(self)wself = self;
        id <HTWebImageOperation> operation = [HTWebImageManager.sharedManager downloadImageWithURL:url options:options progress:progressBlock completed:^(UIImage *image, NSError *error, HTImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            [wself removeActivityIndicator];
            if (!wself) return;
            dispatch_main_sync_safe(^{
                if (!wself) return;
                if (image && (options & HTWebImageAvoidAutoSetImage) && completedBlock)
                {
                    completedBlock(image, error, cacheType, url);
                    return;
                }
                else if (image) {
                    wself.image = image;
                    [wself setNeedsLayout];
                } else {
                    if ((options & HTWebImageDelayPlaceholder)) {
                        wself.image = placeholder;
                        [wself setNeedsLayout];
                    }
                }
                if (completedBlock && finished) {
                    completedBlock(image, error, cacheType, url);
                }
            });
        }];
        [self ht_setImageLoadOperation:operation forKey:@"UIImageViewImageLoad"];
    } else {
        dispatch_main_async_safe(^{
            [self removeActivityIndicator];
            if (completedBlock) {
                NSError *error = [NSError errorWithDomain:HTWebImageErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
                completedBlock(nil, error, HTImageCacheTypeNone, url);
            }
        });
    }
}

- (void)ht_setImageWithPreviousCachedImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(HTWebImageOptions)options progress:(HTWebImageDownloaderProgressBlock)progressBlock completed:(HTWebImageCompletionBlock)completedBlock {
    NSString *key = [[HTWebImageManager sharedManager] cacheKeyForURL:url];
    UIImage *lastPreviousCachedImage = [[HTImageCache sharedImageCache] imageFromDiskCacheForKey:key];
    
    [self ht_setImageWithURL:url placeholderImage:lastPreviousCachedImage ?: placeholder options:options progress:progressBlock completed:completedBlock];
}

- (NSURL *)ht_imageURL {
    return objc_getAssociatedObject(self, &imageURLKey);
}

- (void)ht_setAnimationImagesWithURLs:(NSArray *)arrayOfURLs {
    [self ht_cancelCurrentAnimationImagesLoad];
    __weak __typeof(self)wself = self;

    NSMutableArray *operationsArray = [[NSMutableArray alloc] init];

    for (NSURL *logoImageURL in arrayOfURLs) {
        id <HTWebImageOperation> operation = [HTWebImageManager.sharedManager downloadImageWithURL:logoImageURL options:0 progress:nil completed:^(UIImage *image, NSError *error, HTImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (!wself) return;
            dispatch_main_sync_safe(^{
                __strong UIImageView *sself = wself;
                [sself stopAnimating];
                if (sself && image) {
                    NSMutableArray *currentImages = [[sself animationImages] mutableCopy];
                    if (!currentImages) {
                        currentImages = [[NSMutableArray alloc] init];
                    }
                    [currentImages addObject:image];

                    sself.animationImages = currentImages;
                    [sself setNeedsLayout];
                }
                [sself startAnimating];
            });
        }];
        [operationsArray addObject:operation];
    }

    [self ht_setImageLoadOperation:[NSArray arrayWithArray:operationsArray] forKey:@"UIImageViewAnimationImages"];
}

- (void)ht_cancelCurrentImageLoad {
    [self ht_cancelImageLoadOperationWithKey:@"UIImageViewImageLoad"];
}

- (void)sd_cancelCurrentAnimationImagesLoad {
    [self ht_cancelImageLoadOperationWithKey:@"UIImageViewAnimationImages"];
}


#pragma mark -
- (UIActivityIndicatorView *)activityIndicator {
    return (UIActivityIndicatorView *)objc_getAssociatedObject(self, &TAG_ACTIVITY_INDICATOR);
}

- (void)setActivityIndicator:(UIActivityIndicatorView *)activityIndicator {
    objc_setAssociatedObject(self, &TAG_ACTIVITY_INDICATOR, activityIndicator, OBJC_ASSOCIATION_RETAIN);
}

- (void)setShowActivityIndicatorView:(BOOL)show{
    objc_setAssociatedObject(self, &TAG_ACTIVITY_SHOW, [NSNumber numberWithBool:show], OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)showActivityIndicatorView{
    return [objc_getAssociatedObject(self, &TAG_ACTIVITY_SHOW) boolValue];
}

- (void)setIndicatorStyle:(UIActivityIndicatorViewStyle)style{
    objc_setAssociatedObject(self, &TAG_ACTIVITY_STYLE, [NSNumber numberWithInt:style], OBJC_ASSOCIATION_RETAIN);
}

- (int)getIndicatorStyle{
    return [objc_getAssociatedObject(self, &TAG_ACTIVITY_STYLE) intValue];
}

- (void)addActivityIndicator {
    if (!self.activityIndicator) {
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:[self getIndicatorStyle]];
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;

        dispatch_main_async_safe(^{
            [self addSubview:self.activityIndicator];

            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.activityIndicator
                                                             attribute:NSLayoutAttributeCenterX
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeCenterX
                                                            multiplier:1.0
                                                              constant:0.0]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.activityIndicator
                                                             attribute:NSLayoutAttributeCenterY
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeCenterY
                                                            multiplier:1.0
                                                              constant:0.0]];
        });
    }

    dispatch_main_async_safe(^{
        [self.activityIndicator startAnimating];
    });

}

- (void)removeActivityIndicator {
    if (self.activityIndicator) {
        [self.activityIndicator removeFromSuperview];
        self.activityIndicator = nil;
    }
}

@end
