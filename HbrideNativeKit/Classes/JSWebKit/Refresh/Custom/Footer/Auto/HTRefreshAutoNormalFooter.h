//
//  HTRefreshAutoNormalFooter.h
//  HybridForiOS
//
//  Created by wjx on 2020/4/10.
//  Copyright © 2020 WJX. All rights reserved.
//

#import "HTRefreshAutoStateFooter.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTRefreshAutoNormalFooter : HTRefreshAutoStateFooter
@property (weak, nonatomic, readonly) UIActivityIndicatorView *loadingView;

/** 菊花的样式 */
@property (assign, nonatomic) UIActivityIndicatorViewStyle activityIndicatorViewStyle HTRefreshDeprecated("first deprecated in 3.2.2 - Use `loadingView` property");
@end

NS_ASSUME_NONNULL_END
