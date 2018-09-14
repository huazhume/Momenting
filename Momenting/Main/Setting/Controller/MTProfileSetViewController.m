//
//  MTProfileSetViewController.m
//  Momenting
//
//  Created by xiaobai zhang on 2018/8/23.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import "MTProfileSetViewController.h"
#import "MTNavigationView.h"
#import "MTSettingProfileCell.h"
#import "MTSettingNameCell.h"
#import "MTActionSheetView.h"
#import "MTMeModel.h"
#import "MTMediaFileManager.h"
#import "MTUserInfoDefault.h"


@interface MTProfileSetViewController ()
<UITableViewDelegate,UITableViewDataSource,
MTNavigationViewDelegate,
MTSettingNameCellDelegate,
UINavigationControllerDelegate,UIImagePickerControllerDelegate,
MTActionSheetViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) MTNavigationView *navigationView;
@property (strong, nonatomic) MTMeModel *meModel;

@end

@implementation MTProfileSetViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initBaseViews];
}

- (void)initBaseViews
{
    
    self.meModel = [MTUserInfoDefault getUserDefaultMeModel];
    
    [self.view addSubview:self.navigationView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MTSettingProfileCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[MTSettingProfileCell getIdentifier]];
    [self.tableView registerNib:[UINib nibWithNibName:@"MTSettingNameCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[MTSettingNameCell getIdentifier]];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView reloadData];
    
    MTSettingNameCell *nameCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    [nameCell becomeFirstResponder];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        MTSettingProfileCell *profileCell = [tableView dequeueReusableCellWithIdentifier:[MTSettingProfileCell getIdentifier]];
        [profileCell refreshCell];
        return profileCell;
    } else if (indexPath.row == 1) {
        MTSettingNameCell *nameCell = [tableView dequeueReusableCellWithIdentifier:[MTSettingNameCell getIdentifier]];
        
        nameCell.title = Localized(@"profileEditName");
        nameCell.content = self.meModel.name;
        nameCell.delegate = self;
        return nameCell;
    } else {
        MTSettingNameCell *descCell = [tableView dequeueReusableCellWithIdentifier:[MTSettingNameCell getIdentifier]];
        descCell.title = Localized(@"profileEditAbout");
        descCell.content = self.meModel.about;
        descCell.delegate = self;
        return descCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

#pragma mark - MTSettingNameCellDelegate
- (void)noteCell:(UITableViewCell *)cell didChangeText:(NSString *)text
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath.row == 1) { //name
        self.meModel.name = text;
    } else { //about
        self.meModel.about = text;
    }
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return [MTSettingProfileCell heightForCell];
    } else if (indexPath.row == 1) {
        return [MTSettingNameCell heightForCell];
    } else {
        return [MTSettingNameCell heightForCell] + 40.f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self.view endEditing:YES];
        MTActionSheetView *sheetView = [MTActionSheetView loadFromNib];
        sheetView.frame = [UIScreen mainScreen].bounds;
        sheetView.delegate = self;
        [sheetView show];
    }
}

#pragma mark - MTActionSheetViewDelegate

#pragma mark - MTActionSheetViewDelegate
- (void)sheetToolsActionWithType:(MTActionSheetViewType)type
{
    if (type == MTActionSheetViewOne) {
        [self takePhoto];
    } else if (type == MTActionSheetViewTwo) {
        [self LocalPhoto];
    } else if (type == MTActionSheetViewDelete) {
        //delete
    }
}

#pragma mark - photo
- (void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.videoQuality = UIImagePickerControllerQualityTypeIFrame1280x720;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    } else {
        NSLog(@"无法打开照相机");
    }
}

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if (![type isEqualToString:@"public.image"]) {
        return;
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    NSData *data;
    if (UIImagePNGRepresentation(image) == nil) {
        data = UIImageJPEGRepresentation(image, 1.0);
    } else {
        data = UIImagePNGRepresentation(image);
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createFileAtPath:[[MTMediaFileManager sharedManager] getUserImageFilePath] contents:data attributes:nil];
    [self.tableView reloadData];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)LocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}


#pragma mark - MTNavigationViewDelegate
- (void)leftAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightAction
{
    [self.view endEditing:YES];
    [MTUserInfoDefault saveDefaultUserInfo:self.meModel];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - setter & getter
- (MTNavigationView *)navigationView
{
    if (!_navigationView) {
        _navigationView = [MTNavigationView loadFromNib];
        _navigationView.frame = CGRectMake(0, iPhoneTopMargin, CGRectGetWidth(self.view.bounds), 55);
        _navigationView.delegate = self;
        _navigationView.navigationTitle = Localized(@"profileEditTitle");
        _navigationView.rightTitle = Localized(@"save");
    }
    return _navigationView;
}

- (MTMeModel *)meModel
{
    if (!_meModel) {
        _meModel = [[MTMeModel alloc] init];
    }
    return _meModel;
}



@end
