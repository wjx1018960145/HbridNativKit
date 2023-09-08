//
//  HTScanViewController.m
//  HybridForiOS
//
//  Created by wjx on 2020/3/25.
//  Copyright © 2020 WJX. All rights reserved.
//

#import "HTScanViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
@interface HTScanViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation HTScanViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self drawScanView];
    
    [self requestCameraPemissionWithResult:^(BOOL granted) {

        if (granted) {

            //不延时，可能会导致界面黑屏并卡住一会
            [self performSelector:@selector(startScan) withObject:nil afterDelay:0.3];

        }else{

#ifdef LBXScan_Define_UI
            [_qRScanView stopDeviceReadying];
#endif

        }
    }];
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
       
       if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
           
           self.edgesForExtendedLayout = UIRectEdgeNone;
       }
       
       self.view.backgroundColor = [UIColor blackColor];
       

       switch (_libraryType) {
           case SLT_Native:
               self.title = @"native";
               break;
           case SLT_ZXing:
               self.title = @"ZXing";
               break;
           case SLT_ZBar:
               self.title = @"ZBar";
               break;
           default:
               break;
       }
    // Do any additional setup after loading the view.
}

//绘制扫描区域
- (void)drawScanView
{
#ifdef LBXScan_Define_UI
    
    if (!_qRScanView)
    {
        CGRect rect = self.view.frame;
        rect.origin = CGPointMake(0, 0);
        
        self.qRScanView = [[LBXScanView alloc]initWithFrame:rect style:_style];
        
        [self.view addSubview:_qRScanView];
    }
    
    if (!_cameraInvokeMsg) {
        
//        _cameraInvokeMsg = NSLocalizedString(@"wating...", nil);
    }
    
    [_qRScanView startDeviceReadyingWithText:_cameraInvokeMsg];
#endif
}

- (void)reStartDevice
{
    switch (_libraryType) {
        case SLT_Native:
        {
#ifdef LBXScan_Define_Native
            [_scanObj startScan];
#endif
        }
            break;
        case SLT_ZXing:
        {
#ifdef LBXScan_Define_ZXing
            [_zxingObj start];
#endif
        }
            break;
        case SLT_ZBar:
        {
#ifdef LBXScan_Define_ZBar
            [_zbarObj start];
#endif
        }
            break;
        default:
            break;
    }
    
}

//启动设备
- (void)startScan
{
    UIView *videoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    videoView.backgroundColor = [UIColor clearColor];
    [self.view insertSubview:videoView atIndex:0];
    __weak __typeof(self) weakSelf = self;
    
    switch (_libraryType) {
        case SLT_Native:
        {

            
#ifdef LBXScan_Define_Native
            
            if (!_scanObj )
            {
                CGRect cropRect = CGRectZero;
                
                if (_isOpenInterestRect) {
                    
                    //设置只识别框内区域
                    cropRect = [HTScanView getScanRectWithPreView:self.view style:_style];
                }

                NSString *strCode = AVMetadataObjectTypeQRCode;
                if (_scanCodeType != SCT_BarCodeITF ) {
                    
                    strCode = [self nativeCodeWithType:_scanCodeType];
                }
                
                //AVMetadataObjectTypeITF14Code 扫码效果不行,另外只能输入一个码制，虽然接口是可以输入多个码制
                self.scanObj = [[HTScanNative alloc]initWithPreView:videoView ObjectType:@[strCode] cropRect:cropRect success:^(NSArray<LBXScanResult *> *array) {
                    
                    [weakSelf scanResultWithArray:array];
                }];
                [_scanObj setNeedCaptureImage:_isNeedScanImage];
            }
            [_scanObj startScan];
#endif

        }
            break;
        default:
            break;
    }
    
#ifdef LBXScan_Define_UI
    [_qRScanView stopDeviceReadying];
    [_qRScanView startScanAnimation];
#endif
    
    self.view.backgroundColor = [UIColor clearColor];
}



- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
 
    [self stopScan];
    
#ifdef LBXScan_Define_UI
    [_qRScanView stopScanAnimation];
#endif
}

- (void)stopScan
{
    switch (_libraryType) {
        case SLT_Native:
        {
#ifdef LBXScan_Define_Native
            [_scanObj stopScan];
#endif
        }
            break;
        case SLT_ZXing:
        {
#ifdef LBXScan_Define_ZXing
            [_zxingObj stop];
#endif
        }
            break;
        case SLT_ZBar:
        {
#ifdef LBXScan_Define_ZBar
            [_zbarObj stop];
#endif
        }
            break;
        default:
            break;
    }

}

#pragma mark -扫码结果处理

- (void)scanResultWithArray:(NSArray<HTScanResult*>*)array
{
    //设置了委托的处理
    if (_delegate) {
        [_delegate scanResultWithArray:array];
    }
    
    //也可以通过继承LBXScanViewController，重写本方法即可
}



//开关闪光灯
- (void)openOrCloseFlash
{
    
    switch (_libraryType) {
        case SLT_Native:
        {
#ifdef LBXScan_Define_Native
            [_scanObj changeTorch];
#endif
        }
          
            break;
        default:
            break;
    }
    self.isOpenFlash =!self.isOpenFlash;
}


#pragma mark --打开相册并识别图片

/*!
 *  打开本地照片，选择图片识别
 */
- (void)openLocalPhoto:(BOOL)allowsEditing
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    picker.delegate = self;
   
    //部分机型有问题
    picker.allowsEditing = allowsEditing;
    
    
    [self presentViewController:picker animated:YES completion:nil];
}



//当选择一张图片后进入这里

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    __block UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if (!image){
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    __weak __typeof(self) weakSelf = self;
        
    switch (_libraryType) {
        case SLT_Native:
        {
#ifdef LBXScan_Define_Native
            if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0)
            {
                [LBXScanNative recognizeImage:image success:^(NSArray<LBXScanResult *> *array) {
                    [weakSelf scanResultWithArray:array];
                }];
            }
            else
            {
                [self showError:@"native低于ios8.0系统不支持识别图片条码"];
            }
#endif
        }
            break;
            
        default:
            break;
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"cancel");
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}




- (NSString*)nativeCodeWithType:(SCANCODETYPE)type
{
    switch (type) {
        case SCT_QRCode:
            return AVMetadataObjectTypeQRCode;
            break;
        case SCT_BarCode93:
            return AVMetadataObjectTypeCode93Code;
            break;
        case SCT_BarCode128:
            return AVMetadataObjectTypeCode128Code;
            break;
        case SCT_BarCodeITF:
            return @"ITF条码:only ZXing支持";
            break;
        case SCT_BarEAN13:
            return AVMetadataObjectTypeEAN13Code;
            break;

        default:
            return AVMetadataObjectTypeQRCode;
            break;
    }
}

- (void)showError:(NSString*)str
{
    
}

- (void)requestCameraPemissionWithResult:(void(^)( BOOL granted))completion
{
    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)])
    {
        AVAuthorizationStatus permission =
        [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        switch (permission) {
            case AVAuthorizationStatusAuthorized:
                completion(YES);
                break;
            case AVAuthorizationStatusDenied:
            case AVAuthorizationStatusRestricted:
                completion(NO);
                break;
            case AVAuthorizationStatusNotDetermined:
            {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo
                                         completionHandler:^(BOOL granted) {
                                             
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 if (granted) {
                                                     completion(true);
                                                 } else {
                                                     completion(false);
                                                 }
                                             });
                                             
                                         }];
            }
                break;
                
        }
    }
    
    
}

+ (BOOL)photoPermission
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
    {
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        
        if ( author == ALAuthorizationStatusDenied ) {
            
            return NO;
        }
        return YES;
    }
    
    PHAuthorizationStatus authorStatus = [PHPhotoLibrary authorizationStatus];
    if ( authorStatus == PHAuthorizationStatusDenied ) {
        
        return NO;
    }
    return YES;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
