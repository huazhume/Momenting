//
//  MTNoteSettingView.m
//  Momenting
//
//  Created by xiaobai zhang on 2018/8/9.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import "MTNoteSettingView.h"
#import "MTNoteSettingContentCell.h"
#import "MTNoteSettingHeaderCell.h"
#import "MTProfileSetViewController.h"
#import "MTNotificationViewController.h"
#import "MTLanguageViewController.h"
#import <Masonry.h>
#import "FLBaseWebViewController.h"

@interface MTNoteSettingView ()
<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *datalist;

@end

@implementation MTNoteSettingView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initBaseViews];
    [self registNotification];
}

#pragma mark - initBaseViews
- (void)initBaseViews
{
    [self addSubview:self.tableView];
    [self loadData];
    self.backgroundColor = [UIColor clearColor];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.bottom.equalTo(self);
        make.trailing.equalTo(self).offset(-90);
    }];
}

- (void)loadData
{
    self.datalist = [@[@[@"header"],@[Localized(@"modifyProfile"),Localized(@"modifyLanguage")],@[Localized(@"notifications"),Localized(@"pushNotification")],@[Localized(@"contactUs"), Localized(@"about")]] mutableCopy];
}

- (void)refreshData
{
    [self.tableView reloadData];
}

- (void)registNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageChangeAction) name:kLanguageNotification object:nil];
}

- (void)languageChangeAction
{
    [self loadData];
    [self.tableView reloadData];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else if (section ==  1 || section == 2) {
        return 2;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        
        MTNoteSettingHeaderCell *headerCell = [tableView dequeueReusableCellWithIdentifier:[MTNoteSettingHeaderCell getIdentifier]];
        cell = headerCell;
        [headerCell refreshCell];
        
    } else {
        MTNoteSettingContentCell *contentCell = [tableView dequeueReusableCellWithIdentifier:[MTNoteSettingContentCell getIdentifier]];
        [contentCell setTitle:self.datalist[indexPath.section][indexPath.row]];
        cell = contentCell;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.f;
    } else if (section == 2) {
        return 30.f;
    }
    return 30.f + 40.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [UIView new];
    headerView.backgroundColor = [UIColor colorWithHex:0xF9F9F9];
    return headerView;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        return [MTNoteSettingHeaderCell heightForCell];
        
    } else {
        return [MTNoteSettingContentCell heightForCell];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            // header
            
        }
            break;
        case 1:
        {
            if (indexPath.row == 0) {
                //修改资料
                MTProfileSetViewController *vc = [MTProfileSetViewController new];
                [[MTHelp currentNavigation] pushViewController:vc animated:YES];
            } else {
                //更换背景
                MTLanguageViewController * vc = [MTLanguageViewController new];
                [[MTHelp currentNavigation] pushViewController:vc animated:YES];
            }
        }
            break;
        case 2:
        {
            if (indexPath.row == 0) {
                //通知1
                MTNotificationViewController *notification = [MTNotificationViewController new];
                [[MTHelp currentNavigation] pushViewController:notification animated:YES];
            } else if (indexPath.row == 1) {
                //通知2
                [self goinSettingInterface];
            } 
        }
            break;
        case 3:
        {
            if (indexPath.row == 0) {
                //联系我们
                [self sendEmail];
            } else {
                //关于我们
                
                NSString * htmlPath = @"aboutours";
                FLBaseWebViewController *web = [[FLBaseWebViewController alloc] initWithUrl:htmlPath];
                web.isShowNavigation = YES;
                web.navigationTitle = @"about us";
                [[MTHelp currentNavigation] pushViewController:web animated:YES];
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)changeDeviceOrienationIsV:(BOOL)status
{
    self.tableView.frame = CGRectMake(0, 0,status ?  SCREEN_WIDTH - 90 : SCREEN_HEIGHT - 50, SCREEN_HEIGHT);
}

#pragma mark - Actions
- (void)goinSettingInterface
{
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

-(void)sendEmail
{
    NSMutableString *mailUrl = [NSMutableString string];
    //添加收件人
    NSArray *toRecipients = [NSArray arrayWithObject: @"huazhume@163.com"];
    [mailUrl appendFormat:@"mailto:%@", [toRecipients componentsJoinedByString:@","]];
//    //添加抄送
//    NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
//    [mailUrl appendFormat:@"?cc=%@", [ccRecipients componentsJoinedByString:@","]];
//    //添加密送
//    NSArray *bccRecipients = [NSArray arrayWithObjects:@"fourth@example.com", nil];
//    [mailUrl appendFormat:@"&bcc=%@", [bccRecipients componentsJoinedByString:@","]];
    //添加主题
    [mailUrl appendString:@"&subject=联系我们"];
    //添加邮件内容
    [mailUrl appendString:@"&body=<b>Thanks</b> body!"];
    NSString* email = [mailUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:email]];
}

#pragma mark - getter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - 90, self.frame.size.height) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"MTNoteSettingHeaderCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[MTNoteSettingHeaderCell getIdentifier]];
        [_tableView registerNib:[UINib nibWithNibName:@"MTNoteSettingContentCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[MTNoteSettingContentCell getIdentifier]];
        
    }
    return _tableView;
}

- (NSMutableArray *)datalist
{
    if (!_datalist) {
        _datalist = [NSMutableArray array];
    }
    return _datalist;
}

@end
