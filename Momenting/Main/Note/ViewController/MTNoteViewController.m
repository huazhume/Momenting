//
//  MTNoteViewController.m
//  Momenting
//
//  Created by xiaobai zhang on 2018/8/7.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import "MTNoteViewController.h"
#import "MTNoteToolsView.h"
#import "MTNavigationView.h"
#import "MTNoteToolsTextCell.h"
#import "MTNoteToolsImageCell.h"
#import "MTNoteModel.h"
#import "MTActionSheetView.h"
#import "MTMediaFileManager.h"
#import "MTCoreDataDao.h"
#import "MTActionAlertView.h"
#import "UIImage+ImageCompress.h"

@interface MTNoteViewController ()
<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,
MTNavigationViewDelegate,
MTNoteToolsViewDelegate,
UIActionSheetDelegate,
UINavigationControllerDelegate,UIImagePickerControllerDelegate,
MTActionSheetViewDelegate,
MTNoteToolsTextCellDelegate>

@property (strong, nonatomic) MTNoteToolsView *toolsView;
@property (strong, nonatomic) MTNavigationView *navigationView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) CGFloat keyboardHeight;

@property (strong, nonatomic) NSMutableArray *datalist;

@property (strong, nonatomic) UIFont *textFont;

@end

@implementation MTNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerNotification];
    [self initBaseViews];
}

- (void)initBaseViews
{
    [self.view addSubview:self.toolsView];
    [self.view addSubview:self.navigationView];
    
    self.textFont = [UIFont fontWithName:@"PingFangSC-Light" size:14];
    [self.tableView registerNib:[UINib nibWithNibName:@"MTNoteToolsTextCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[MTNoteToolsTextCell getIdentifier]];
    [self.tableView registerNib:[UINib nibWithNibName:@"MTNoteToolsImageCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[MTNoteToolsImageCell getIdentifier]];
//    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView reloadData];
    
    MTNoteToolsTextCell *textCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [textCell becomeKeyboardFirstResponder];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datalist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id model = self.datalist[indexPath.row];
    UITableViewCell *cell = nil;
    if ([model isKindOfClass:[MTNoteTextVo class]]) {
        
        MTNoteToolsTextCell *textCell = [tableView dequeueReusableCellWithIdentifier:[MTNoteToolsTextCell getIdentifier]];
        textCell.font = self.textFont;
        textCell.delegate = self;
        textCell.model = model;
        cell = textCell;
        
    } else {
        MTNoteToolsImageCell *imageCell = [tableView dequeueReusableCellWithIdentifier:[MTNoteToolsImageCell getIdentifier]];
        imageCell.model = model;
        cell = imageCell;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id model = self.datalist[indexPath.row];
    if ([model isKindOfClass:[MTNoteTextVo class]]) {
        return [self imageCount] ? [MTNoteToolsTextCell heightForCell] : CGRectGetHeight(self.view.bounds) - 100;
    } else {
        return [MTNoteToolsImageCell heightForCellWithModel:model];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    MTActionSheetView *sheetView = [MTActionSheetView loadFromNib];
    sheetView.isShowDelete = YES;
    sheetView.frame = [UIScreen mainScreen].bounds;
    sheetView.delegate = self;
    [sheetView show];
}

#pragma mark - MTNoteToolsTextCellDelegate
- (void)noteCell:(UITableViewCell *)cell textViewWillBeginEditing:(UITextView *)textView;
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self adjustTableViewToFitWithKeyboardHeight:self.keyboardHeight indexPath: indexPath];
}

- (void)noteCell:(UITableViewCell *)cell didChangeText:(NSString *)text
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    id model = self.datalist[indexPath.row];
    if ([model isKindOfClass: [MTNoteTextVo class]]) {
        MTNoteTextVo *textModel = model;
        textModel.text = text;
    }
}

- (void)adjustTableViewToFitWithKeyboardHeight:(CGFloat)keyboardHeight indexPath:(NSIndexPath *)indexPath
{
    if (indexPath == nil || indexPath.row == 0) {
        return;
    }
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
    CGRect rect = [cell.superview convertRect:cell.frame toView:window];
    CGFloat delta = CGRectGetMaxY(rect) - (window.bounds.size.height - keyboardHeight);
    CGPoint offset = self.tableView.contentOffset;
    offset.y += delta;
    if (offset.y < 0) {
        offset.y = 0;
    }
    offset.y = offset.y + 30;
    [self.tableView setContentOffset:offset animated:YES];
}


#pragma mark - MTNoteToolsViewDelegate
- (void)noteToolsFootActionWithFont:(UIFont *)font
{
    self.textFont = font;
    [self.tableView reloadData];
}

- (void)noteToolsActionWithType:(MTNoteToolsViewType)type
{
    if (type == MTNoteToolsViewImage) {
        [self.view endEditing:YES];
        MTActionSheetView *sheetView = [MTActionSheetView loadFromNib];
        sheetView.frame = [UIScreen mainScreen].bounds;
        sheetView.delegate = self;
        [sheetView show];
    }
}

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
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.videoQuality = UIImagePickerControllerQualityTypeIFrame1280x720;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else
    {
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
    
    UIImage *beta_image = [UIImage compressImage:image compressRatio:0.4];
    NSData *beta_data;
    if (UIImagePNGRepresentation(beta_image) == nil) {
        beta_data = UIImageJPEGRepresentation(beta_image, 1.0);
    } else {
        beta_data = UIImagePNGRepresentation(beta_image);
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString * path =[[MTMediaFileManager sharedManager] getMediaFilePathWithAndSanBoxType:SANBOX_DOCUMNET_TYPE AndMediaType:FILE_IMAGE_TYPE];
    NSString * beta_path =[[MTMediaFileManager sharedManager] getMediaFilePathWithAndSanBoxType:SANBOX_DOCUMNET_TYPE AndMediaType:FILE_IMAGEBATE_TYPE];
    NSString *fileName = [NSString stringWithFormat:@"%ld.png",(long)[[NSDate date]timeIntervalSince1970]];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",path,fileName];
    NSString *beta_filePath = [NSString stringWithFormat:@"%@/%@",beta_path,fileName];
    [fileManager createFileAtPath:filePath contents:data attributes:nil];
    [fileManager createFileAtPath:beta_filePath contents:beta_data attributes:nil];
    MTNoteImageVo *model = [MTNoteImageVo new];
    model.path = fileName;
    model.width = image.size.width;
    model.height = image.size.height;
    [self.datalist addObject:model];
    
    MTNoteTextVo *textModel = [MTNoteTextVo new];
    [self.datalist addObject:textModel];
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

#pragma mark - keyboard notification
- (void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChange:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChange:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)keyboardWillChange:(NSNotification *)notification
{
    NSTimeInterval animationDuration;
    NSDictionary *info = [notification userInfo];
    
    [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat y = keyboardRect.origin.y;
//    CGSize contentSize = self.tableView.contentSize;
    if (notification.name == UIKeyboardWillHideNotification) {
        y = CGRectGetHeight(self.view.bounds) - 40;
//        contentSize.height -= 2 * keyboardRect.size.height;
        
    } else {
        y = CGRectGetHeight(self.view.bounds) - keyboardRect.size.height - 40;
//        contentSize.height +=  2 * keyboardRect.size.height;
    }
//    self.tableView.contentSize = contentSize;
    self.keyboardHeight = keyboardRect.size.height;
    
    self.toolsView.keyBoardIsVisiable = (notification.name != UIKeyboardWillHideNotification);
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         self.toolsView.frame = CGRectMake(0, y, SCREEN_WIDTH, 40);
                     }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - MTNavigationViewDelegate
- (void)leftAction
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)rightAction
{
    [self.view endEditing:YES];
    [MTActionAlertView alertShowWithMessage:@"天气这么好，多写写可好？" leftTitle:@"够了" leftColor:[UIColor colorWithHex:0xCD6256] rightTitle:@"继续" rightColor:[UIColor colorWithHex:0x333333] callBack:^(NSInteger index) {
        if (index == 2){
            return;
        }
        [self saveNote];
    }];
}

- (void)saveNote
{
    __block MTNoteModel *noteModel = [MTNoteModel new];
    noteModel.noteId = [NSString stringWithFormat:@"%ld",(long)[[NSDate date]timeIntervalSince1970]];
    __block BOOL isTextFind = 0;
    __block BOOL isImageFind = 0;
    [self.datalist enumerateObjectsUsingBlock:^(id  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([model isKindOfClass:[MTNoteTextVo class]]) {
            MTNoteTextVo *vo = (MTNoteTextVo *)model;
            if (vo.text.length > 0 && !isTextFind) {
                isTextFind = YES;
                noteModel.text = vo.text;
            }
            vo.noteId = noteModel.noteId;
        } else if ([model isKindOfClass:[MTNoteImageVo class]]) {
            MTNoteImageVo *vo = (MTNoteImageVo *)model;
            if (vo.path.length > 0 && !isImageFind) {
                isImageFind = YES;
                noteModel.imagePath = vo.path;
                noteModel.width = vo.width;
                noteModel.height = vo.height;
            }
            vo.noteId = noteModel.noteId;
        }
    }];
    
    [[MTCoreDataDao new] insertDatas:@[noteModel] withType:MTCoreDataContentTypeNoteSelf];
    [[MTCoreDataDao new] insertDatas:self.datalist withType:MTCoreDataContentTypeNoteContent];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - getter
- (MTNoteToolsView *)toolsView
{
    if (!_toolsView) {
        _toolsView = [MTNoteToolsView loadFromNib];
        _toolsView.frame = CGRectMake(0, self.view.bounds.size.height - 40, self.view.bounds.size.width, 40);
        _toolsView.delegate = self;
    }
    return _toolsView;
}

- (MTNavigationView *)navigationView
{
    if (!_navigationView) {
        _navigationView = [MTNavigationView loadFromNib];
        _navigationView.frame = CGRectMake(0, iPhoneTopMargin, SCREEN_WIDTH, 55);
        _navigationView.delegate = self;
        _navigationView.navigationTitle = Localized(@"noteTitle");
        _navigationView.rightTitle = Localized(@"noteNext");
    }
    return _navigationView;
}

- (NSMutableArray *)datalist
{
    if (!_datalist) {
        _datalist = [NSMutableArray array];
        MTNoteTextVo *textModel = [[MTNoteTextVo alloc] init];
        [_datalist addObject:textModel];
    }
    return _datalist;
}

- (NSInteger)imageCount
{
    __block NSInteger sum = 0;
    [self.datalist enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[MTNoteImageVo class]]) {
            sum ++;
        }
    }];
    return sum;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
