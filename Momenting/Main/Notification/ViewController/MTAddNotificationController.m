//
//  MTAddNotificationController.m
//  Momenting
//
//  Created by xiaobai zhang on 2018/8/24.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import "MTAddNotificationController.h"
#import "MTAddNotificationTimeCell.h"
#import "MTNavigationView.h"
#import "MTAddNotificationCell.h"
#import "MTAddNotificationStateCell.h"
#import "MTNotificationVo.h"
#import "MTActionToastView.h"
#import "MTLocalDataManager.h"
#import "MTNotificationManager.h"
#import "MTDateFormatManager.h"


@interface MTAddNotificationController ()
<UITableViewDelegate,UITableViewDataSource,
MTNavigationViewDelegate,
MTAddNotificationCellDelegate,
MTAddNotificationTimeCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) MTNavigationView *navigationView;
@property (strong, nonatomic) MTNotificationVo *vo;

@property (copy, nonatomic) NSString *hour;
@property (copy, nonatomic) NSString *minute;
@end

@implementation MTAddNotificationController
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initBaseViews];
}

- (void)initBaseViews
{
    
    NSString *time = [[NSDateFormatter my_getHHmmFormatter] stringFromDate:[NSDate date]];
    NSArray *times = [time componentsSeparatedByString:@":"];
    if (times.count < 2) {
        return;
    }
    self.hour = ((NSString *)times[0]);
    self.minute = ((NSString *)times[1]);
    
    [self.view addSubview:self.navigationView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MTAddNotificationCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[MTAddNotificationCell getIdentifier]];
    [self.tableView registerNib:[UINib nibWithNibName:@"MTAddNotificationTimeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[MTAddNotificationTimeCell getIdentifier]];
    [self.tableView registerNib:[UINib nibWithNibName:@"MTAddNotificationStateCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[MTAddNotificationStateCell getIdentifier]];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView reloadData];
    
    MTAddNotificationCell *nameCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [nameCell becomeFirstResponder];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        MTAddNotificationCell *descCell = [tableView dequeueReusableCellWithIdentifier:[MTAddNotificationCell getIdentifier]];
        descCell.delegate = self;
        return descCell;
    } else if (indexPath.row == 1){
        MTAddNotificationTimeCell *timeCell = [tableView dequeueReusableCellWithIdentifier:[MTAddNotificationTimeCell getIdentifier]];
        timeCell.delegate = self;
        return timeCell;
    } else {
        MTAddNotificationStateCell *stateCell = [tableView dequeueReusableCellWithIdentifier:[MTAddNotificationStateCell getIdentifier]];
        return stateCell;
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
        return [MTAddNotificationCell heightForCell];
    } else if (indexPath.row == 1){
        return [MTAddNotificationTimeCell heightForCell];
    } else {
        return [MTAddNotificationStateCell heightForCell];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - MTSettingNameCellDelegate
- (void)noteCell:(UITableViewCell *)cell didChangeText:(NSString *)text
{
    self.vo.content = text;
}

#pragma mark - MTAddNotificationTimeCellDelegate
- (void)notificationTime:(NSString *)time withIsHour:(BOOL)isHour
{
    if (isHour) {
        self.hour = time;
    } else {
        self.minute = time;
    }
}


#pragma mark - MTNavigationViewDelegate
- (void)leftAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightAction
{
    if (!self.vo.content.length) {
        MTActionToastView *toastView = [MTActionToastView loadFromNib];
        toastView.bounds = CGRectMake(0, 0, 110, 32);
        toastView.content = Localized(@"addNotificationToast");
        [toastView show];
        return;
    }
    self.vo.time = [NSString stringWithFormat:@"%@:%@",self.hour,self.minute];
    self.vo.notificationId = [NSString stringWithFormat:@"%ld",(NSInteger)[[NSDate date] timeIntervalSince1970]];
    [[MTLocalDataManager shareInstance] insertNotificationDatas:@[self.vo]];
    MTActionToastView *toastView = [MTActionToastView loadFromNib];
    toastView.bounds = CGRectMake(0, 0, 110, 32);
    toastView.content = Localized(@"addNotificationSaveSuccess");
    [toastView show];
    [[MTNotificationManager shareInstance] addNotificationWithVo:self.vo];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - setter & getter
- (MTNavigationView *)navigationView
{
    if (!_navigationView) {
        _navigationView = [MTNavigationView loadFromNib];
        _navigationView.frame = CGRectMake(0, iPhoneTopMargin, SCREEN_WIDTH, 55);
        _navigationView.delegate = self;
        _navigationView.navigationTitle = Localized(@"addNotificationTitle");
        _navigationView.rightTitle = Localized(@"save");
    }
    return _navigationView;
}

- (MTNotificationVo *)vo
{
    if (!_vo) {
        _vo = [MTNotificationVo new];
    }
    return _vo;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
