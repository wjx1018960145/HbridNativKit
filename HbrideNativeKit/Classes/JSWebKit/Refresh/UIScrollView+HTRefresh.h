//
//  UIScrollView+HTRefresh.h
//  HybridForiOS
//
//  Created by wjx on 2020/4/10.
//  Copyright © 2020 WJX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTRefreshConst.h"
NS_ASSUME_NONNULL_BEGIN

@class HTRefreshHeader, HTRefreshFooter;
@interface UIScrollView (HTRefresh)
/** 下拉刷新控件 */
@property (strong, nonatomic, nullable) HTRefreshHeader *ht_header;
@property (strong, nonatomic, nullable) HTRefreshHeader *header HTRefreshDeprecated("使用ht_header");
/** 上拉刷新控件 */
@property (strong, nonatomic, nullable) HTRefreshFooter *ht_footer;
@property (strong, nonatomic, nullable) HTRefreshFooter *footer HTRefreshDeprecated("使用ht_footer");

#pragma mark - other
- (NSInteger)ht_totalDataCount;
@end

NS_ASSUME_NONNULL_END
