//
//  ViewController.m
//  Momenting
//
//  Created by xiaobai zhang on 2018/8/7.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import "ViewController.h"
#import "MTHomeSectionView.h"
#import "MTHomeTextViewCell.h"
#import "UITableViewCell+Categoty.h"
#import "MTNoteViewController.h"
#import "MTCoreDataDao.h"
#import "MTHomeEmptyView.h"
#import "MTNoteModel.h"
#import <MJRefresh/MJRefresh.h>
#import "MTDeleteStyleTableView.h"
#import "MTNoteDetailViewController.h"
#import "MTActionAlertView.h"
#import "MTCoreDataDao.h"
#import "MTMediaFileManager.h"
#import "MTNoteSettingView.h"
#import "MTMeModel.h"
#import "MTUserInfoDefault.h"

@interface ViewController ()
<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,
MTHomeSectionViewDelegate,
MTHomeEmptyViewDelegate>

@property (weak, nonatomic) IBOutlet MTDeleteStyleTableView *tableView;
@property (strong, nonatomic) MTHomeSectionView *sectionView;
@property (assign, nonatomic) CGPoint scrollViewOldOffset;
@property (strong, nonatomic) NSMutableArray *datalist;
@property (weak, nonatomic) IBOutlet MTNoteSettingView *setView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *setViewLeadingCostraint;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerViewTopConstraint;

@property (assign, nonatomic) BOOL isAnimationing;
@property (strong, nonatomic) NSDate *lastScrollDate;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBaseViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.datalist = [[[MTCoreDataDao new] getNoteSelf] mutableCopy];
    [self.tableView reloadData];
    
    NSString * path =[[MTMediaFileManager sharedManager] getMediaFilePathWithAndSanBoxType:SANBOX_DOCUMNET_TYPE AndMediaType:FILE_IMAGE_TYPE];
    NSString *fileName = @"homeStyle";
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",path,fileName];
    self.bgImageView.image = [UIImage imageWithContentsOfFile:filePath];
    
    MTMeModel *meModel = [MTUserInfoDefault getUserDefaultMeModel];
    self.sectionView.name = meModel.name;
    [self.setView refreshData];
}
#pragma mark - Views
- (void)initBaseViews
{
    [self.tableView registerNib:[UINib nibWithNibName:@"MTHomeTextViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[MTHomeTextViewCell getIdentifier]];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.navigationController.navigationBar.hidden = YES;
    self.logoImageView.layer.cornerRadius = self.logoImageView.bounds.size.height / 2.0;
    self.logoImageView.layer.masksToBounds = YES;
    
    [self.headerView addSubview:self.sectionView];
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    NSMutableArray *muImage = [NSMutableArray array];
    for (int i = 1 ; i < 34 ; i ++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_anim__000%d",i]];
        [muImage addObject:image];
    }
    // 设置普通状态的动画图片
    [header setImages:muImage forState:MJRefreshStateIdle];
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    [header setImages:muImage forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [header setImages:muImage forState:MJRefreshStateRefreshing];
    // 设置header
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.tableView.mj_header = header;
    
    
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(settingViewIsShow:)];
    recognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.setView addGestureRecognizer:recognizer];
}

- (void)loadNewData
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_header endRefreshing];
    });
}

#pragma mark - ScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y - self.scrollViewOldOffset.y > 1) {
        //向下滑动
       [self scrollAnimationIsShow:NO];
    } else if (self.scrollViewOldOffset.y - scrollView.contentOffset.y > 0){
        [self scrollAnimationIsShow:YES];
    }
//    self.scrollViewOldOffset = scrollView.contentOffset;
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
    if (isShow && self.headerViewTopConstraint.constant == 0.f) {
        return;
    }
    
    if (!isShow && self.headerViewTopConstraint.constant == -60.f) {
        return;
    }
    self.lastScrollDate = [NSDate date];
    [self setNeedsStatusBarAppearanceUpdate];
    [UIView animateWithDuration:0.29 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.headerViewTopConstraint.constant = isShow ? 0.f : -60.f;
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
    MTHomeTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[MTHomeTextViewCell getIdentifier]];
    MTNoteModel *model = self.datalist[indexPath.row];
    model.indexRow = indexPath.row;
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    MTHomeEmptyView *footView = [MTHomeEmptyView loadFromNib];
    footView.delegate = self;
    return self.datalist.count > 0 ? [UIView new] : footView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return self.datalist.count > 0 ? 0.f : [MTHomeEmptyView viewHeight];
}

//先要设Cell可编辑
- (NSArray*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
//    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:NSLocalizedString(@"", @"") handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
//                                          {
//                                              [tableView setEditing:NO animated:YES];  // 这句很重要，退出编辑模式，隐藏左滑菜单
//
//                                          }];
//    deleteAction.backgroundColor = [UIColor whiteColor];
    NSString *readTitle = @"";
    UITableViewRowAction *readAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:readTitle handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                        {
                                            
                                            [MTActionAlertView alertShowWithMessage:@"真的忍心要删除嘛？" leftTitle:@"是哒" leftColor:[UIColor colorWithHex:0xCD6256] rightTitle:@"不啦" rightColor:[UIColor colorWithHex:0x333333] callBack:^(NSInteger index) {
                                                if (index == 2){
                                                    return;
                                                }
                                                MTNoteModel *model = self.datalist[indexPath.row];
                                                [[MTCoreDataDao new]deleteNoteWithNoteId:model.noteId];
                                                [self.datalist removeObjectAtIndex:indexPath.row];
                                                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationAutomatic)];
                                                 [tableView setEditing:NO animated:YES];
                                            }];

                                        }];
    readAction.backgroundColor = [UIColor whiteColor];
    return @[readAction];
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.tableView.editingIndexPath = indexPath;
    [self.view setNeedsLayout];   // 触发-(void)viewDidLayoutSubviews
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.tableView.editingIndexPath = nil;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MTHomeTextViewCell heightForCellWithModel:self.datalist[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MTNoteDetailViewController *detailVC = [[MTNoteDetailViewController alloc] init];
    MTNoteModel *model = self.datalist[indexPath.row];
    detailVC.noteId = model.noteId;
    detailVC.color = model.sectionColor;
    detailVC.isStatusBarHidden = [UIApplication sharedApplication].isStatusBarHidden;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - MTHomeSectionViewDelegate
- (void)homeNoteAction
{
    MTNoteViewController *noteVC = [[MTNoteViewController alloc] init];
    [self.navigationController pushViewController:noteVC animated:YES];
}

- (void)homeSettingAction
{
    [self settingViewIsShow:YES];
}
- (IBAction)setViewDismissAction:(id)sender
{
    [self settingViewIsShow:NO];
}

- (void)settingViewIsShow:(BOOL)isShow
{
    [UIView animateWithDuration:0.29 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.setViewLeadingCostraint.constant = isShow ? 0.f : -SCREEN_WIDTH;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - MTHomeEmptyViewDelegate
- (void)emptyNoteAction
{
    MTNoteViewController *noteVC = [[MTNoteViewController alloc] init];
    [self.navigationController pushViewController:noteVC animated:YES];
}

#pragma mark - getter
- (UIView *)sectionView
{
    if (!_sectionView) {
        _sectionView = [MTHomeSectionView loadFromNib];
        _sectionView.frame = CGRectMake(0, 20, self.view.bounds.size.width, 40);
        _sectionView.backgroundColor = [UIColor clearColor];
        _sectionView.delegate = self;
    }
    return _sectionView;
}

- (NSMutableArray *)datalist
{
    if (!_datalist) {
        _datalist = [NSMutableArray array];
    }
    return _datalist;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 1.创建通知
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
