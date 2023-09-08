//
//  UIButton+WebCache.m
//  HybridForiOS
//
//  Created by wjx on 2020/3/17.
//  Copyright © 2020 WJX. All rights reserved.
//

#import "UIButton+WebCache.h"
#import "objc/runtime.h"

#import "UIVew+WebCacheOperation.h"



static char imageURLStorageKey;

@implementation UIButton (WebCache)
- (NSURL *)ht_currentImageURL {
    NSURL *url = self.imageURLStorage[@(self.state)];

    if (!url) {
        url = self.imageURLStorage[@(UIControlStateNormal)];
    }

    return url;
}

- (NSURL *)ht_imageURLForState:(UIControlState)state {
    return self.imageURLStorage[@(state)];
}

- (void)ht_setImageWithURL:(NSURL *)url forState:(UIControlState)state {
    [self ht_setImageWithURL:url forState:state placeholderImage:nil options:0 completed:nil];
}

- (void)ht_setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder {
    [self ht_setImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:nil];
}

- (void)ht_setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(HTWebImageOptions)options {
    [self ht_setImageWithURL:url forState:state placeholderImage:placeholder options:options completed:nil];
}

- (void)ht_setImageWithURL:(NSURL *)url forState:(UIControlState)state completed:(HTWebImageCompletionBlock)completedBlock {
    [self ht_setImageWithURL:url forState:state placeholderImage:nil options:0 completed:completedBlock];
}

- (void)ht_setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder completed:(HTWebImageCompletionBlock)completedBlock {
    [self ht_setImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:completedBlock];
}

- (void)ht_setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(HTWebImageOptions)options completed:(HTWebImageCompletionBlock)completedBlock {

    [self setImage:placeholder forState:state];
    [self ht_cancelImageLoadForState:state];
    
    if (!url) {
        [self.imageURLStorage removeObjectForKey:@(state)];
        
        dispatch_main_async_safe(^{
            if (completedBlock) {
                NSError *error = [NSError errorWithDomain:HTWebImageErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
                completedBlock(nil, error, HTImageCacheTypeNone, url);
            }
        });
        
        return;
    }
    
    self.imageURLStorage[@(state)] = url;

    __weak __typeof(self)wself = self;
    id <HTWebImageOperation> operation = [HTWebImageManager.sharedManager downloadImageWithURL:url options:options progress:nil completed:^(UIImage *image, NSError *error, HTImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (!wself) return;
        dispatch_main_sync_safe(^{
            __strong UIButton *sself = wself;
            if (!sself) return;
            if (image && (options & HTWebImageAvoidAutoSetImage) && completedBlock)
            {
                completedBlock(image, error, cacheType, url);
                return;
            }
            else if (image) {
                [sself setImage:image forState:state];
            }
            if (completedBlock && finished) {
                completedBlock(image, error, cacheType, url);
            }
        });
    }];
    [self ht_setImageLoadOperation:operation forState:state];
}

- (void)ht_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state {
    [self ht_setBackgroundImageWithURL:url forState:state placeholderImage:nil options:0 completed:nil];
}

- (void)ht_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder {
    [self ht_setBackgroundImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:nil];
}

- (void)sd_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(HTWebImageOptions)options {
    [self ht_setBackgroundImageWithURL:url forState:state placeholderImage:placeholder options:options completed:nil];
}

- (void)ht_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state completed:(HTWebImageCompletionBlock)completedBlock {
    [self ht_setBackgroundImageWithURL:url forState:state placeholderImage:nil options:0 completed:completedBlock];
}

- (void)ht_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder completed:(HTWebImageCompletionBlock)completedBlock {
    [self ht_setBackgroundImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:completedBlock];
}

- (void)ht_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(HTWebImageOptions)options completed:(HTWebImageCompletionBlock)completedBlock {
    [self ht_cancelBackgroundImageLoadForState:state];

    [self setBackgroundImage:placeholder forState:state];

    if (url) {
        __weak __typeof(self)wself = self;
        id <HTWebImageOperation> operation = [HTWebImageManager.sharedManager downloadImageWithURL:url options:options progress:nil completed:^(UIImage *image, NSError *error, HTImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (!wself) return;
            dispatch_main_sync_safe(^{
                __strong UIButton *sself = wself;
                if (!sself) return;
                if (image && (options & HTWebImageAvoidAutoSetImage) && completedBlock)
                {
                    completedBlock(image, error, cacheType, url);
                    return;
                }
                else if (image) {
                    [sself setBackgroundImage:image forState:state];
                }
                if (completedBlock && finished) {
                    completedBlock(image, error, cacheType, url);
                }
            });
        }];
        [self ht_setBackgroundImageLoadOperation:operation forState:state];
    } else {
        dispatch_main_async_safe(^{
            NSError *error = [NSError errorWithDomain:HTWebImageErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
            if (completedBlock) {
                completedBlock(nil, error, HTImageCacheTypeNone, url);
            }
        });
    }
}

- (void)ht_setImageLoadOperation:(id<HTWebImageOperation>)operation forState:(UIControlState)state {
    [self ht_setImageLoadOperation:operation forKey:[NSString stringWithFormat:@"UIButtonImageOperation%@", @(state)]];
}

- (void)ht_cancelImageLoadForState:(UIControlState)state {
    [self ht_cancelImageLoadOperationWithKey:[NSString stringWithFormat:@"UIButtonImageOperation%@", @(state)]];
}

- (void)ht_setBackgroundImageLoadOperation:(id<HTWebImageOperation>)operation forState:(UIControlState)state {
    [self ht_setImageLoadOperation:operation forKey:[NSString stringWithFormat:@"UIButtonBackgroundImageOperation%@", @(state)]];
}

- (void)ht_cancelBackgroundImageLoadForState:(UIControlState)state {
    [self ht_cancelImageLoadOperationWithKey:[NSString stringWithFormat:@"UIButtonBackgroundImageOperation%@", @(state)]];
}

- (NSMutableDictionary *)imageURLStorage {
    NSMutableDictionary *storage = objc_getAssociatedObject(self, &imageURLStorageKey);
    if (!storage)
    {
        storage = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, &imageURLStorageKey, storage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }

    return storage;
}

@end

@implementation UIButton (WebCacheDeprecated)

- (NSURL *)currentImageURL {
    return [self ht_currentImageURL];
}

- (NSURL *)imageURLForState:(UIControlState)state {
    return [self ht_imageURLForState:state];
}

- (void)setImageWithURL:(NSURL *)url forState:(UIControlState)state {
    [self ht_setImageWithURL:url forState:state placeholderImage:nil options:0 completed:nil];
}

- (void)setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder {
    [self ht_setImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:nil];
}

- (void)setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(HTWebImageOptions)options {
    [self ht_setImageWithURL:url forState:state placeholderImage:placeholder options:options completed:nil];
}

- (void)setImageWithURL:(NSURL *)url forState:(UIControlState)state completed:(HTWebImageCompletedBlock)completedBlock {
    [self ht_setImageWithURL:url forState:state placeholderImage:nil options:0 completed:^(UIImage *image, NSError *error, HTImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, cacheType);
        }
    }];
}

- (void)setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder completed:(HTWebImageCompletedBlock)completedBlock {
    [self ht_setImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:^(UIImage *image, NSError *error, HTImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, cacheType);
        }
    }];
}

- (void)setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(HTWebImageOptions)options completed:(HTWebImageCompletedBlock)completedBlock {
    [self ht_setImageWithURL:url forState:state placeholderImage:placeholder options:options completed:^(UIImage *image, NSError *error, HTImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, cacheType);
        }
    }];
}

- (void)setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state {
    [self ht_setBackgroundImageWithURL:url forState:state placeholderImage:nil options:0 completed:nil];
}

- (void)setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder {
    [self ht_setBackgroundImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:nil];
}

- (void)setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(HTWebImageOptions)options {
    [self ht_setBackgroundImageWithURL:url forState:state placeholderImage:placeholder options:options completed:nil];
}

- (void)setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state completed:(HTWebImageCompletedBlock)completedBlock {
    [self ht_setBackgroundImageWithURL:url forState:state placeholderImage:nil options:0 completed:^(UIImage *image, NSError *error, HTImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, cacheType);
        }
    }];
}

- (void)setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder completed:(HTWebImageCompletedBlock)completedBlock {
    [self ht_setBackgroundImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:^(UIImage *image, NSError *error, HTImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, cacheType);
        }
    }];
}

- (void)setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(HTWebImageOptions)options completed:(HTWebImageCompletedBlock)completedBlock {
    [self ht_setBackgroundImageWithURL:url forState:state placeholderImage:placeholder options:options completed:^(UIImage *image, NSError *error, HTImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, cacheType);
        }
    }];
}

- (void)cancelCurrentImageLoad {
    // in a backwards compatible manner, cancel for current state
    [self ht_cancelImageLoadForState:self.state];
}

- (void)cancelBackgroundImageLoadForState:(UIControlState)state {
    [self ht_cancelBackgroundImageLoadForState:state];
}

@end
