//
//  MTNoteDetailViewController.m
//  Momenting
//
//  Created by xiaobai zhang on 2018/8/14.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import "MTNoteDetailViewController.h"
#import "MTNavigationView.h"
#import "MTNoteToolsTextCell.h"
#import "MTNoteToolsImageCell.h"
#import "MTNoteModel.h"
#import "MTCoreDataDao.h"
#import "MTActionToastView.h"
#import "MTNoteDetailSectionView.h"

@interface MTNoteDetailViewController ()
<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,
MTNavigationViewDelegate>

@property (strong, nonatomic) MTNavigationView *navigationView;
@property (weak, nonatomic) IBOutlet UIView *navigationBgView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *toolsBgView;
@property (strong, nonatomic) NSMutableArray *datalist;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationBarTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolsViewBottomConstraint;

@property (assign, nonatomic) BOOL isAnimationing;
@property (strong, nonatomic) NSDate *lastScrollDate;
@property (assign, nonatomic) CGPoint scrollViewOldOffset;

@property (assign, nonatomic) BOOL isDownloading;

@end

@implementation MTNoteDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBaseViews];
    [self loadData];
}

- (void)loadData
{
    self.datalist = [[[MTCoreDataDao new] getNoteDetailList:self.noteId] mutableCopy];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.isStatusBarHidden = [UIApplication sharedApplication].isStatusBarHidden;
//    [UIApplication sharedApplication].statusBarStyle =  UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarHidden = self.isStatusBarHidden;
//    [UIApplication sharedApplication].statusBarStyle =  UIStatusBarStyleDefault;
}

- (void)initBaseViews
{
//    [self.navigationBgView addSubview:self.navigationView];
    [self.tableView registerNib:[UINib nibWithNibName:@"MTNoteToolsTextCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[MTNoteToolsTextCell getIdentifier]];
    [self.tableView registerNib:[UINib nibWithNibName:@"MTNoteToolsImageCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[MTNoteToolsImageCell getIdentifier]];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.layer.borderColor = self.color.CGColor;
    self.tableView.layer.masksToBounds = YES;
}

#pragma mark - ScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    if (scrollView.contentOffset.y - self.scrollViewOldOffset.y > 1) {
//        //向下滑动
//        [self scrollAnimationIsShow:NO];
//    } else if (self.scrollViewOldOffset.y - scrollView.contentOffset.y > 0){
//        [self scrollAnimationIsShow:YES];
//    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // 获取开始拖拽时tableview偏移量
    self.scrollViewOldOffset = scrollView.contentOffset;
}

- (void)scrollAnimationIsShow:(BOOL)isShow
{
    NSDate *nowDate = [NSDate date];
    
    NSTimeInterval times = [nowDate timeIntervalSinceDate:self.lastScrollDate];
    if (self.isAnimationing || self.tableView.contentOffset.y <= 0 || times < 0.5 || self.tableView.contentOffset.y >= self.tableView.contentSize.height) {
        return;
    }
    if (isShow && self.toolsViewBottomConstraint.constant == 0.f) {
        return;
    }
    
    if (!isShow && self.toolsViewBottomConstraint.constant == -44.f) {
        return;
    }
    self.lastScrollDate = [NSDate date];
    [self setNeedsStatusBarAppearanceUpdate];
    [UIView animateWithDuration:0.29 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        self.navigationBarTopConstraint.constant = isShow ? -20.f : -40.f;
        self.toolsViewBottomConstraint.constant = isShow ? 0.f : -44.f;
        [UIApplication sharedApplication].statusBarHidden = !isShow;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.isAnimationing = NO;
    }];
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
        [textCell setType:MTNoteToolsTextCellDetail];
        textCell.model = model;
        cell = textCell;
        
    } else {
        MTNoteToolsImageCell *imageCell = [tableView dequeueReusableCellWithIdentifier:[MTNoteToolsImageCell getIdentifier]];
        imageCell.model = model;
        [imageCell setType:MTNoteToolsImageCellDetail];
        cell = imageCell;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.isDownloading ? [MTNoteDetailSectionView viewHeight] : 0.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MTNoteDetailSectionView *sectionView = [MTNoteDetailSectionView loadFromNib];
    sectionView.color = self.color;
    return self.isDownloading ? sectionView : [UIView new];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id model = self.datalist[indexPath.row];
    if ([model isKindOfClass:[MTNoteTextVo class]]) {
        return [MTNoteToolsTextCell heightForCellWithModel:model];
    } else {
        return [MTNoteToolsImageCell heightForCellWithModel:model];
    }
}

#pragma mark - events
- (IBAction)dismissButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)downloadButtonClicked:(id)sender
{
    [UIView animateWithDuration:0.29 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.tableView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.85f, 0.85f);
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.29 delay:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.tableView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0f, 1.0f);
        } completion:^(BOOL finished) {
            [self.tableView renderViewToImageCompletion:^(UIImage *image) {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
                MTActionToastView *toastView = [MTActionToastView loadFromNib];
                toastView.bounds = CGRectMake(0, 0, 110, 32);
                [toastView show];
                
            }];
        }];
    }];
    
}

#pragma mark - getter
- (MTNavigationView *)navigationView
{
    if (!_navigationView) {
        _navigationView = [MTNavigationView loadFromNib];
        _navigationView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 55);
        _navigationView.delegate = self;
        _navigationView.backgroundColor = self.color;
        _navigationView.type = MTNavigationViewNoteDetail;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
