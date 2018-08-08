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
#import "UITableViewCell+Categoty.h"
#import "MTNoteModel.h"
#import "UIColor+Hex.h"
#import "MTActionSheetView.h"

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
    if ([model isKindOfClass:[MTNoteTextModel class]]) {
        
        MTNoteToolsTextCell *textCell = [tableView dequeueReusableCellWithIdentifier:[MTNoteToolsTextCell getIdentifier]];
        textCell.font = self.textFont;
        textCell.delegate = self;
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
    if ([model isKindOfClass:[MTNoteTextModel class]]) {
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
    MTNoteImageModel *model = [MTNoteImageModel new];
    model.image = image;
    [self.datalist addObject:model];
    
    MTNoteTextModel *textModel = [MTNoteTextModel new];
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
    if (notification.name == UIKeyboardWillHideNotification) {
        y = CGRectGetHeight(self.view.bounds) - 40;
    } else {
        y = CGRectGetHeight(self.view.bounds) - keyboardRect.size.height - 40;
    }
    self.keyboardHeight = keyboardRect.size.height;
    
    self.toolsView.keyBoardIsVisiable = (notification.name != UIKeyboardWillHideNotification);
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         self.toolsView.frame = CGRectMake(0, y, CGRectGetWidth(self.view.bounds), 40);
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
        _navigationView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 55);
        _navigationView.delegate = self;
    }
    return _navigationView;
}

- (NSMutableArray *)datalist
{
    if (!_datalist) {
        _datalist = [NSMutableArray array];
        MTNoteTextModel *textModel = [[MTNoteTextModel alloc] init];
        [_datalist addObject:textModel];
    }
    return _datalist;
}

- (NSInteger)imageCount
{
    __block NSInteger sum = 0;
    [self.datalist enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[MTNoteImageModel class]]) {
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
