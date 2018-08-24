//
//  MTAddNotificationController.m
//  Momenting
//
//  Created by xiaobai zhang on 2018/8/24.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import "MTAddNotificationController.h"

#import "MTNavigationView.h"
#import "MTNotificationViewCell.h"
#import "MTDeleteStyleTableView.h"


@interface MTAddNotificationController ()
<UITableViewDelegate,UITableViewDataSource,
MTNavigationViewDelegate>

@property (weak, nonatomic) IBOutlet MTDeleteStyleTableView *tableView;
@property (strong, nonatomic) MTNavigationView *navigationView;

@end

@implementation MTAddNotificationController
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initBaseViews];
}

- (void)initBaseViews
{
    [self.view addSubview:self.navigationView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MTNotificationViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[MTNotificationViewCell getIdentifier]];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView reloadData];
}


//#pragma mark - UITableViewDataSource
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 3;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    MTNotificationViewCell *notificationCell = [tableView dequeueReusableCellWithIdentifier:[MTNotificationViewCell getIdentifier]];
//    return notificationCell;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 0.f;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return [UIView new];
//}
//
//- (NSArray*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
//{
//    NSString *readTitle = @"";
//    UITableViewRowAction *readAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:readTitle handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
//
//    }];
//    readAction.backgroundColor = [UIColor whiteColor];
//    return @[readAction];
//}
//
//- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    self.tableView.editingIndexPath = indexPath;
//    [self.view setNeedsLayout];   // 触发-(void)viewDidLayoutSubviews
//}
//
//- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    self.tableView.editingIndexPath = nil;
//}
//
//
//
//#pragma mark - UITableViewDelegate
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 100.f;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//}

#pragma mark - MTNavigationViewDelegate
- (void)leftAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightAction
{
    
}

#pragma mark - setter & getter
- (MTNavigationView *)navigationView
{
    if (!_navigationView) {
        _navigationView = [MTNavigationView loadFromNib];
        _navigationView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 55);
        _navigationView.delegate = self;
        _navigationView.navigationTitle = @"Add Notifications";
        _navigationView.rightImageName = @"done";
        _navigationView.rightTitle = @"";
    }
    return _navigationView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
