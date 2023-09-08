//
//  HTAlterView.h
//  HybridForiOS
//
//  Created by wjx on 2020/4/26.
//  Copyright © 2020 WJX. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
//取消按钮点击事件
typedef void(^cancelBlock)();

//确定按钮点击事件
typedef void(^sureBlock)();

@interface HTAlterView : UIView

@property(nonatomic,copy)cancelBlock cancel_block;
@property(nonatomic,copy)sureBlock sure_block;
/**
 *
 *
 *  @param title       标题
 *  @param content     内容
 *  @param cancel      取消按钮内容
 *  @param sure        确定按钮内容
 *  @param cancelBlock 取消按钮点击事件
 *  @param sureBlock   确定按钮点击事件
 *
 *  @return HTAlterView
 */
-(instancetype)alterViewWithTitle:(NSString *)title
                          content:(NSString *)content
                           cancel:(NSString *)cancel
                             sure:(NSString *)sure
                    cancelBtClcik:(cancelBlock)cancelBlock
                      sureBtClcik:(sureBlock)sureBlock;

- (void)show;

@end

NS_ASSUME_NONNULL_END
