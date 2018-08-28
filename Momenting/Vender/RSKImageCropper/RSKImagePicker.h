//
//  RSKImagePicker.h
//  RSKImageCropperExample
//
//  Created by QingyunLiao on 2017/4/6.
//  Copyright © 2017年 Ruslan Skorb. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RSKImageCropViewController.h"

@protocol RSKImagePickerDelegate;

@interface RSKImagePicker : NSObject

@property (nonatomic, weak) id<RSKImagePickerDelegate> delegate;
@property (nonatomic, weak) id<RSKImageCropViewControllerDataSource> dataSource;
@property (nonatomic, assign) RSKImageCropMode cropMode;
@property (nonatomic, strong, readonly) UIImagePickerController *imagePickerController;

@end

@protocol RSKImagePickerDelegate <NSObject>

- (void)imagePicker:(RSKImagePicker *)imagePicker pickedImage:(UIImage *)image;

- (void)imagePickerDidCancel:(RSKImagePicker *)imagePicker;

@end
