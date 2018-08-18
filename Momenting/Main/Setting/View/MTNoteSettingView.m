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

@interface MTNoteSettingView ()
<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation MTNoteSettingView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initBaseViews];
}

#pragma mark - initBaseViews
- (void)initBaseViews
{
    [self addSubview:self.tableView];
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
    } else if (section == 1) {
        return 2;
    }
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        
        MTNoteSettingHeaderCell *headerCell = [tableView dequeueReusableCellWithIdentifier:[MTNoteSettingHeaderCell getIdentifier]];
        cell = headerCell;
        
    } else {
        MTNoteSettingContentCell *contentCell = [tableView dequeueReusableCellWithIdentifier:[MTNoteSettingContentCell getIdentifier]];
        cell = contentCell;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section ? 30.f : 0.f;
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
   
}

#pragma mark - getter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 90, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"MTNoteSettingHeaderCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[MTNoteSettingHeaderCell getIdentifier]];
        [_tableView registerNib:[UINib nibWithNibName:@"MTNoteSettingContentCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[MTNoteSettingContentCell getIdentifier]];
        
    }
    return _tableView;
}

@end
