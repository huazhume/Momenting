//
//  MTLanguageViewController.m
//  Momenting
//
//  Created by xiaobai zhang on 2018/8/30.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import "MTLanguageViewController.h"
#import "MTNavigationView.h"
#import "MTLanguageViewCell.h"
#import "MTUserInfoDefault.h"


@interface MTLanguageViewController ()
<UITableViewDelegate,UITableViewDataSource,
MTNavigationViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) MTNavigationView *navigationView;

@property (assign, nonatomic) BOOL lanagureStatus;

@end

@implementation MTLanguageViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initBaseViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)initBaseViews
{
    [self.view addSubview:self.navigationView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MTLanguageViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[MTLanguageViewCell getIdentifier]];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    
    self.lanagureStatus = [MTUserInfoDefault getUserDefaultLanagureIsChinese];
    [self.tableView reloadData];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MTLanguageViewCell *languageCell = [tableView dequeueReusableCellWithIdentifier:[MTLanguageViewCell getIdentifier]];
    NSString *title = indexPath.row ? @"English" : @"中文(简体)";
    languageCell.title = title;
    languageCell.languageStatus = (self.lanagureStatus != indexPath.row);
    return languageCell;
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
    return [MTLanguageViewCell heightForCell];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.lanagureStatus = (indexPath.row == 0);
    [MTUserInfoDefault saveDefaultLanagure:self.lanagureStatus];
    [self.tableView reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:kLanguageNotification object:nil];
    self.navigationView.navigationTitle = Localized(@"language");
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
        _navigationView.frame = CGRectMake(0, iPhoneTopMargin, SCREEN_WIDTH, 55);
        _navigationView.delegate = self;
        _navigationView.navigationTitle = Localized(@"language");
        _navigationView.rightImageName = @"";
        _navigationView.rightTitle = @"";
    }
    return _navigationView;
}



@end
