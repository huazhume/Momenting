//
//  RSKImagePicker.m
//  RSKImageCropperExample
//
//  Created by QingyunLiao on 2017/4/6.
//  Copyright © 2017年 Ruslan Skorb. All rights reserved.
//

#import "RSKImagePicker.h"

#import "RSKImageCropViewController.h"

@interface RSKImagePicker ()
<UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
RSKImageCropViewControllerDelegate>

@property (nonatomic, strong, readwrite) UIImagePickerController *imagePickerController;

- (void)_hideController;

@end

@implementation RSKImagePicker

- (instancetype)init
{
    self = [super init];
    if (self) {
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
    }

    return self;
}

- (void)_hideController
{
    [self.imagePickerController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIImagePickerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self cancel];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *sourceImage = [info objectForKey:UIImagePickerControllerOriginalImage];

    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:sourceImage cropMode:self.cropMode];
    imageCropVC.delegate = self;
    imageCropVC.dataSource = self.dataSource;
    imageCropVC.avoidEmptySpaceAroundImage = YES;

    [picker pushViewController:imageCropVC animated:YES];
}

#pragma mark - RSKImageCropViewControllerDelegate

- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller
{
    [self cancel];
}

- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect
{
    if ([self.delegate respondsToSelector:@selector(imagePicker:pickedImage:)]) {
        [self.delegate imagePicker:self pickedImage:croppedImage];
    }
}

#pragma mark - Cancel
- (void)cancel
{
    if ([self.delegate respondsToSelector:@selector(imagePickerDidCancel:)]) {

        [self.delegate imagePickerDidCancel:self];
    } else {

        [self _hideController];
    }
}

@end
