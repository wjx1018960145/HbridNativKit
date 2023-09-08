//
//  UIScrollView+HTRefresh.m
//  HybridForiOS
//
//  Created by wjx on 2020/4/10.
//  Copyright © 2020 WJX. All rights reserved.
//

#import "UIScrollView+HTRefresh.h"
#import "HTRefreshHeader.h"
#import "HTRefreshFooter.h"
#import <objc/runtime.h>

@implementation UIScrollView (HTRefresh)

static const char HTRefreshHeaderKey = '\0';
- (void)setHt_header:(HTRefreshHeader *)ht_header
{
    if (ht_header != self.ht_header) {
        // 删除旧的，添加新的
        [self.ht_header removeFromSuperview];
        [self insertSubview:ht_header atIndex:0];
        
        // 存储新的
        objc_setAssociatedObject(self, &HTRefreshHeaderKey,
                                 ht_header, OBJC_ASSOCIATION_RETAIN);
    }
}

- (HTRefreshHeader *)ht_header
{
    return objc_getAssociatedObject(self, &HTRefreshHeaderKey);
}

#pragma mark - footer
static const char HTRefreshFooterKey = '\0';
- (void)setHt_footer:(HTRefreshFooter *)ht_footer
{
    if (ht_footer != self.ht_footer) {
        // 删除旧的，添加新的
        [self.ht_footer removeFromSuperview];
        [self insertSubview:ht_footer atIndex:0];
        
        // 存储新的
        objc_setAssociatedObject(self, &HTRefreshFooterKey,
                                 ht_footer, OBJC_ASSOCIATION_RETAIN);
    }
}

- (HTRefreshFooter *)ht_footer
{
    return objc_getAssociatedObject(self, &HTRefreshFooterKey);
}

#pragma mark - 过期
- (void)setFooter:(HTRefreshFooter *)footer
{
    self.ht_footer = footer;
}

- (HTRefreshFooter *)footer
{
    return self.ht_footer;
}

- (void)setHeader:(HTRefreshHeader *)header
{
    self.ht_header = header;
}

- (HTRefreshHeader *)header
{
    return self.ht_header;
}

#pragma mark - other
- (NSInteger)ht_totalDataCount
{
    NSInteger totalCount = 0;
    if ([self isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self;

        for (NSInteger section = 0; section < tableView.numberOfSections; section++) {
            totalCount += [tableView numberOfRowsInSection:section];
        }
    } else if ([self isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)self;

        for (NSInteger section = 0; section < collectionView.numberOfSections; section++) {
            totalCount += [collectionView numberOfItemsInSection:section];
        }
    }
    return totalCount;
}
@end
