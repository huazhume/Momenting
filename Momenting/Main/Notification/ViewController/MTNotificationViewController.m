//
//  MTNotificationViewController.m
//  Momenting
//
//  Created by xiaobai zhang on 2018/8/24.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import "MTNotificationViewController.h"
#import "MTNavigationView.h"
#import "MTNotificationViewCell.h"
#import "MTDeleteStyleTableView.h"
#import "MTAddNotificationController.h"
#import "MTCoreDataDao.h"
#import "MTActionAlertView.h"
#import "MTNotificationVo.h"


@interface MTNotificationViewController ()
<UITableViewDelegate,UITableViewDataSource,
MTNavigationViewDelegate>

@property (weak, nonatomic) IBOutlet MTDeleteStyleTableView *tableView;
@property (strong, nonatomic) MTNavigationView *navigationView;
@property (strong, nonatomic) NSMutableArray *notifications;

@end

@implementation MTNotificationViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initBaseViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.notifications = [[[MTCoreDataDao new]getNotifications] mutableCopy];
    [self.tableView reloadData];
}

- (void)initBaseViews
{
    [self.view addSubview:self.navigationView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MTNotificationViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[MTNotificationViewCell getIdentifier]];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView reloadData];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.notifications.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MTNotificationViewCell *notificationCell = [tableView dequeueReusableCellWithIdentifier:[MTNotificationViewCell getIdentifier]];
    notificationCell.model = self.notifications[indexPath.row];
    notificationCell.indexRow = indexPath.row;
    return notificationCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (NSArray*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    NSString *readTitle = @"";
    UITableViewRowAction *readAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:readTitle handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        [MTActionAlertView alertShowWithMessage:@"真的忍心要删除嘛？" leftTitle:@"是哒" leftColor:[UIColor colorWithHex:0xCD6256] rightTitle:@"不啦" rightColor:[UIColor colorWithHex:0x333333] callBack:^(NSInteger index) {
            if (index == 2){
                return;
            }
            MTNotificationVo *model = self.notifications[indexPath.row];
            [[MTCoreDataDao new] deleteNotificationWithContent:model.content];
            [self.notifications removeObjectAtIndex:indexPath.row];
            
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
    return [MTNotificationViewCell heightForCellWithModel:self.notifications[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - MTNavigationViewDelegate
- (void)leftAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightAction
{
    MTAddNotificationController *addNoti = [MTAddNotificationController new];
    [[MTHelp currentNavigation] pushViewController:addNoti animated:YES];
}

#pragma mark - setter & getter
- (MTNavigationView *)navigationView
{
    if (!_navigationView) {
        _navigationView = [MTNavigationView loadFromNib];
        _navigationView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 55);
        _navigationView.delegate = self;
        _navigationView.navigationTitle = Localized(@"notificationTitle");
        _navigationView.rightImageName = @"add-icon";
        _navigationView.rightTitle = @"";
    }
    return _navigationView;
}



@end

