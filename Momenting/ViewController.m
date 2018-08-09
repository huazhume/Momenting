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

@interface ViewController ()
<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,
MTHomeSectionViewDelegate,
MTHomeEmptyViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) MTHomeSectionView *sectionView;
@property (assign, nonatomic) CGPoint scrollViewOldOffset;
@property (strong, nonatomic) NSMutableArray *datalist;
@property (weak, nonatomic) IBOutlet UIView *setView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *setViewLeadingCostraint;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

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
}

#pragma mark - Views
- (void)initBaseViews
{
    [self.tableView registerNib:[UINib nibWithNibName:@"MTHomeTextViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[MTHomeTextViewCell getIdentifier]];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    self.navigationController.navigationBar.hidden = YES;
    self.logoImageView.layer.cornerRadius = self.logoImageView.bounds.size.height / 2.0;
    self.logoImageView.layer.masksToBounds = YES;
}

#pragma mark - contentOfSet
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{

}

#pragma mark - ScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"_______%@",NSStringFromCGPoint(scrollView.contentOffset));
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
    return [MTHomeSectionView viewHeight];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.sectionView;
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

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MTHomeTextViewCell heightForCellWithModel:self.datalist[indexPath.row]];
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
        self.setViewLeadingCostraint.constant = isShow ? 0.f : -CGRectGetWidth(self.view.bounds);
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

- (void)dealloc
{
    [self.tableView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
