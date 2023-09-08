//
//  ZZQAvatarPicker.m
//  ZZQAvatarPicker
//
//  Created by 郑志强 on 2018/10/31.
//  Copyright © 2018 郑志强. All rights reserved.
//

#import "ZZQAvatarPicker.h"
#import "ZZQResourceSheetView.h"
#import "ZZQAuthorizationManager.h"
#import <PhotosUI/PhotosUI.h>
#import "HTFileStreamSeparation.h"
typedef void(^seletedImage)(UIImage *image,NSURL *filePath);

@interface ZZQAvatarPicker ()<UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
ZZQResouceSheetViewDelegate>

@property (nonatomic, strong) UIImagePickerController *imagePicker;

@property (nonatomic, strong) ZZQResourceSheetView *toolView;

@property (nonatomic, copy) seletedImage selectedImage;

@end

@implementation ZZQAvatarPicker


+ (void)startSelectedblack:(HTJBResponseCallback)responseCallback compleiton:(void(^)(UIImage *image,NSURL * filePath))compleiton {
    
    [[self new] startSelected:^(UIImage * _Nonnull image,NSURL *path) {
        //          responseCallback(@"1231");
        compleiton(image,path);
    }];
}


- (void)startSelected:(void (^)(UIImage * _Nonnull,NSURL *path))compleiton {
    [self.toolView show];
    self.selectedImage = compleiton;
}


#pragma mark - <ZZQResouceSheetViewDelegate>

- (void)ZZQResourceSheetView:(ZZQResourceSheetView *)sheetView seletedMode:(ResourceMode)resourceMode {
    
    if (resourceMode == ResourceModeNone) {
        //        self.selectedImage ? self.selectedImage(nil,nil) : nil;
        [self clean];
        return;
    }
    
    if (resourceMode == ResourceModeAlbum) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        __weak typeof(self) weakSelf = self;
        [ZZQAuthorizationManager checkPhotoLibraryAuthorization:^(BOOL isPermission) {
            if (isPermission) {
                [weakSelf presentToImagePicker];
            } else {
                [ZZQAuthorizationManager requestPhotoLibraryAuthorization];
            }
        }];
        
    } else if (resourceMode == ResourceModeCamera) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
        
        __weak typeof(self) weakSelf = self;
        [ZZQAuthorizationManager checkCameraAuthorization:^(BOOL isPermission) {
            if (isPermission) {
                [weakSelf presentToImagePicker];
            } else {
                [ZZQAuthorizationManager requestCameraAuthorization];
            }
        }];
    }
}


- (void)presentToImagePicker {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *rootVC = [[[UIApplication sharedApplication] delegate] window].rootViewController;
        [rootVC presentViewController:self.imagePicker animated:YES completion:nil];
    });
}

#pragma mark - <UIImagePickerControllerDelegate>

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if(picker.sourceType == UIImagePickerControllerSourceTypeCamera){
        NSMutableArray *imageIds = [NSMutableArray array];
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            
            PHAssetChangeRequest *req = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
            
            [imageIds addObject:req.placeholderForCreatedAsset.localIdentifier];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                //成功后取相册中的图片对象
                __block PHAsset *imageAsset = nil;
                
                PHFetchResult *result = [PHAsset fetchAssetsWithLocalIdentifiers:imageIds options:nil];
                [result enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    imageAsset = obj;
                    *stop = YES;
                    
                }];
                
                if (imageAsset) {
                    //加载图片数据
                    [[PHImageManager defaultManager] requestImageDataForAsset:imageAsset
                          options:nil
                          resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                                                                    
                               NSLog(@"imageinfo = %@", info);
                        NSURL *pathurl = info[@"PHImageFileURLKey"];
                        
                         NSString *originalPath = [pathurl.absoluteString stringByReplacingOccurrencesOfString:@"file://" withString:@""];
                        
                        NSString *path=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", [HTFileStreamSeparation fileKeyMD5WithPath:originalPath]]];
                        [imageData writeToFile:path atomically:YES];
                      
                        
                        
                            self.selectedImage ? self.selectedImage(image,[NSURL URLWithString:path]) : nil;
                          }];

                }
                
            }
            
            
            
        }];
        
    }else{
        
        NSLog(@"photoInfo%@",info);
        self.selectedImage ? self.selectedImage(image,info[@"UIImagePickerControllerImageURL"]) : nil;
    }
    
//    SEL selectorToCall = @selector(imageWasSavedSuccessfully:didFinishSavingWithError:contextInfo:);
//    UIImageWriteToSavedPhotosAlbum(image, self,selectorToCall, NULL);
    
    //    self.selectedImage ? self.selectedImage(image,info[@"UIImagePickerControllerImageURL"]) : nil;
    [picker dismissViewControllerAnimated:YES completion:^{
        [self clean];
    }];
}

- (void) imageWasSavedSuccessfully:(UIImage *)paramImage didFinishSavingWithError:(NSError *)paramError contextInfo:(void *)paramContextInfo{
    
    if (paramError == nil){
        
        NSLog(@"Image was saved successfully.");
        
    } else {
        
        NSLog(@"An error happened while saving the image.");
        
        NSLog(@"Error = %@", paramError);
        
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    //    self.selectedImage ? self.selectedImage(nil,nil) : nil;
    [picker dismissViewControllerAnimated:YES completion:^{
        [self clean];
    }];
}


- (void)clean {
    self.toolView.delegate = nil;
    self.toolView = nil;
}


#pragma mark - getter

- (UIImagePickerController *)imagePicker {
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc]init];
        _imagePicker.delegate = self;
        _imagePicker.allowsEditing = YES;
    }
    return _imagePicker;
}


- (ZZQResourceSheetView *)toolView {
    if (!_toolView) {
        _toolView = [ZZQResourceSheetView new];
        _toolView.delegate = self;
    }
    return _toolView;
}


- (void)dealloc {
    NSLog(@"picker dealloc");
}

@end
