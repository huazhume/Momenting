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

@interface MTProfileSetViewController ()
<UITableViewDelegate,UITableViewDataSource,
MTNavigationViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) MTNavigationView *navigationView;

@end

@implementation MTProfileSetViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initBaseViews];
}

- (void)initBaseViews
{
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
        return profileCell;
    } else if (indexPath.row == 1) {
        MTSettingNameCell *nameCell = [tableView dequeueReusableCellWithIdentifier:[MTSettingNameCell getIdentifier]];
        nameCell.title = @"Name";
        return nameCell;
    } else {
        MTSettingNameCell *descCell = [tableView dequeueReusableCellWithIdentifier:[MTSettingNameCell getIdentifier]];
        descCell.title = @"About";
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
    
}

#pragma mark - MTNavigationViewDelegate
- (void)leftAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - setter & getter
- (MTNavigationView *)navigationView
{
    if (!_navigationView) {
        _navigationView = [MTNavigationView loadFromNib];
        _navigationView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 55);
        _navigationView.delegate = self;
        _navigationView.navigationTitle = @"Edit Profile";
        _navigationView.rightTitle = @"save";
    }
    return _navigationView;
}



@end
