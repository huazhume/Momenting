//
//  MTStyleViewController.m
//  Momenting
//
//  Created by xiaobai zhang on 2018/8/28.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import "MTStyleViewController.h"
#import "MTNavigationView.h"
#import "MTSettingProfileCell.h"
#import "MTSettingNameCell.h"
#import "MTActionSheetView.h"
#import "RSKImagePicker.h"
#import "MTMediaFileManager.h"
#import "MTActionToastView.h"

@interface MTStyleViewController ()
<MTNavigationViewDelegate,
MTActionSheetViewDelegate,
RSKImagePickerDelegate,RSKImageCropViewControllerDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) MTNavigationView *navigationView;
@property (strong, nonatomic) RSKImagePicker *imagePicker;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@property (assign, nonatomic) BOOL isHomeStyleExist;

@end

@implementation MTStyleViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    self.isHomeStyleExist = [fileManager fileExistsAtPath:[[MTMediaFileManager sharedManager] getHomeStyleFilePath]];
    if (self.isHomeStyleExist) {
        self.bgImageView.image = [UIImage imageWithContentsOfFile:[[MTMediaFileManager sharedManager] getHomeStyleFilePath]];
    }
    [self initBaseViews];
}

- (void)initBaseViews
{
    [self.view addSubview:self.navigationView];
}


#pragma mark - MTNavigationViewDelegate
- (void)leftAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightAction
{
    NSString *string = nil;
    if (self.isHomeStyleExist) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:[[MTMediaFileManager sharedManager] getHomeStyleFilePath] error:nil];
        self.bgImageView.image = nil;
        self.isHomeStyleExist = NO;
        string = @"删除成功";
        
    } else {
        UIImage *image = self.bgImageView.image;
        if (!image) {
            MTActionToastView *toastView = [MTActionToastView loadFromNib];
            toastView.bounds = CGRectMake(0, 0, 110, 32);
            toastView.content = @"未添加图片哦";
            [toastView show];
            return;
        }
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil) {
            data = UIImageJPEGRepresentation(image, 1.0);
        } else {
            data = UIImagePNGRepresentation(image);
        }
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager createFileAtPath:[[MTMediaFileManager sharedManager] getHomeStyleFilePath] contents:data attributes:nil];
        string = @"更新成功";
    }
    
    MTActionToastView *toastView = [MTActionToastView loadFromNib];
    toastView.bounds = CGRectMake(0, 0, 110, 32);
    toastView.content = string;
    [toastView show];
    self.navigationView.rightTitle = self.isHomeStyleExist ? @"delete" : @"save";
    self.navigationView.rightColor = self.isHomeStyleExist ? [UIColor colorWithHex:0xCD3127] : [UIColor colorWithHex:0x039369];
}

#pragma mark - MTActionSheetViewDelegate
- (void)sheetToolsActionWithType:(MTActionSheetViewType)type
{
    if (type == MTActionSheetViewOne) {
        [self choosePhotoFromSource:UIImagePickerControllerSourceTypeCamera];
    } else if (type == MTActionSheetViewTwo) {
         [self choosePhotoFromSource:UIImagePickerControllerSourceTypePhotoLibrary];
    } else if (type == MTActionSheetViewDelete) {
        //delete
    }
}

#pragma mark - PickImageFromLibrary
- (void)choosePhotoFromSource:(UIImagePickerControllerSourceType)sourceType
{
    self.imagePicker = [[RSKImagePicker alloc] init];
    self.imagePicker.cropMode = RSKImageCropModeCustom;
    self.imagePicker.delegate = self;
    self.imagePicker.dataSource = self;
    self.imagePicker.imagePickerController.sourceType = sourceType;
    [self presentViewController:self.imagePicker.imagePickerController animated:YES completion:nil];
}

#pragma mark - RSKImagePickerDelegate

- (void)imagePicker:(RSKImagePicker *)imagePicker pickedImage:(UIImage *)image
{
    
    self.isHomeStyleExist = NO;
    self.navigationView.rightTitle = self.isHomeStyleExist ? @"delete" : @"save";
    self.navigationView.rightColor = self.isHomeStyleExist ? [UIColor colorWithHex:0xCD3127] : [UIColor colorWithHex:0x039369];
    
    self.bgImageView.image = image;
    __weak __typeof(self) weakSelf = self;
    [imagePicker.imagePickerController dismissViewControllerAnimated:YES completion:^{
        
        __strong __typeof(self) strongSelf = weakSelf;
        strongSelf.imagePicker = nil;
    }];
}

- (void)imagePickerDidCancel:(RSKImagePicker *)imagePicker
{
    __weak __typeof(self) weakSelf = self;
    
    [imagePicker.imagePickerController dismissViewControllerAnimated:YES completion:^{
        __strong __typeof(self) strongSelf = weakSelf;
        strongSelf.imagePicker = nil;
    }];
    self.tableView.userInteractionEnabled = YES;
}

#pragma mark - RSKImageCropViewControllerDataSource
- (CGRect)imageCropViewControllerCustomMaskRect:(RSKImageCropViewController *)controller
{
    return self.view.bounds;
}

- (UIBezierPath *)imageCropViewControllerCustomMaskPath:(RSKImageCropViewController *)controller
{
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:controller.maskRect];
    return path;
}

- (CGRect)imageCropViewControllerCustomMovementRect:(RSKImageCropViewController *)controller
{
    return controller.maskRect;
}


#pragma mark - events
- (IBAction)editStyleButtonClicked:(id)sender
{
    MTActionSheetView *sheetView = [MTActionSheetView loadFromNib];
    sheetView.frame = [UIScreen mainScreen].bounds;
    sheetView.delegate = self;
    [sheetView show];
}

#pragma mark - setter & getter
- (MTNavigationView *)navigationView
{
    if (!_navigationView) {
        _navigationView = [MTNavigationView loadFromNib];
        _navigationView.frame = CGRectMake(0, iPhoneTopMargin, SCREEN_WIDTH, 55);
        _navigationView.delegate = self;
        _navigationView.navigationTitle = @"Modify Style";
        _navigationView.rightTitle = self.isHomeStyleExist ? @"delete" : @"save";
        _navigationView.rightColor = self.isHomeStyleExist ? [UIColor colorWithHex:0xCD3127] : [UIColor colorWithHex:0x039369];
        
    }
    return _navigationView;
}



@end

