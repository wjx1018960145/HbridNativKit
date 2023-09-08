//
//  HTScanResult.h
//  HybridForiOS
//
//  Created by wjx on 2020/3/25.
//  Copyright © 2020 WJX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface HTScanResult : NSObject


- (instancetype)initWithScanString:(NSString*)str imgScan:(UIImage*)img barCodeType:(NSString*)type;


/**
 @brief  条码字符串
 */
@property (nonatomic, copy) NSString* strScanned;
/**
 @brief  扫码图像
 */
@property (nonatomic, strong) UIImage* imgScanned;

/**
 @brief  扫码码的类型,AVMetadataObjectType  如AVMetadataObjectTypeQRCode，AVMetadataObjectTypeEAN13Code等
 如果使用ZXing扫码，返回类型也已经转换成对应的AVMetadataObjectType
 */
@property (nonatomic, copy) NSString* strBarCodeType;

@end

NS_ASSUME_NONNULL_END
