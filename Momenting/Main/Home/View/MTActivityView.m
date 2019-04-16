
//
//  MTActivityView.m
//  Momenting
//
//  Created by xiaobai zhang on 2019/4/13.
//  Copyright © 2019年 xiaobai zhang. All rights reserved.
//

#import "MTActivityView.h"
#import "MTMarketHotView.h"
#import <MJRefresh/MJRefresh.h>
#import "MTActivityViewCell.h"
#import "MTNoteDetailViewController.h"

@interface MTActivityView () <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) MTMarketHotView *hotView;

@property (nonatomic, strong) NSTimer *marketTimer;
@property (nonatomic, assign) NSInteger totalTimes;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation MTActivityView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.top.equalTo(self);
    }];
    
    NSMutableArray *muImage = [NSMutableArray array];
    for (int i = 1 ; i < 34 ; i ++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_anim__000%d",i]];
        [muImage addObject:image];
    }
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
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
    [self addTimer];
    
    self.dataArray = [NSMutableArray array];
    NSMutableArray *muArray1 = [NSMutableArray array];
    [muArray1 addObject:@{@"title":@"奇妙物语",@"image":@"http://hpimg.pianke.com/e2fe4150cd894b4bead7fb237f30fa2c20170110.jpg",@"id" : @"detail_01"}];
    [muArray1 addObject:@{@"title":@"难忘故乡",@"image":@"http://hpimg.pianke.com/60922b22ebf8a08b0268d2ab2d33fb4020171018.jpg",@"id" : @"detail_02"}];
    
    [self.dataArray addObject:muArray1];
    
    
    NSMutableArray *muArray2 = [NSMutableArray array];
    [muArray2 addObject:@{@"title":@"缘浅缘深，如溪如河",@"image":@"http://hpimg.pianke.com/0b968d61dfa265d008f15ed33292bb9120180511.jpeg",@"id" : @"detail_03"}];
    [muArray2 addObject:@{@"title":@"浮生会",@"image":@"http://hpimg.pianke.com/bfc198dd1b13b9fdbb782f296018307820170111.jpg",@"id" : @"detail_04"}];
    
    [self.dataArray addObject:muArray2];
    
    
    NSMutableArray *muArray3 = [NSMutableArray array];
    [muArray3 addObject:@{@"title":@"读心术",@"image":@"http://hpimg.pianke.com/1ce5f4769efcd95fb167f01825c4550120170111.jpg",@"id" : @"detail_05"}];
    [muArray3 addObject:@{@"title":@"早安故事",@"image":@"http://hpimg.pianke.com/fbd889ec355b066d6511cbe6e1b0cfda20170111.jpg",@"id" : @"detail_06"}];
    
    [self.dataArray addObject:muArray3];
    
    
    NSMutableArray *muArray4 = [NSMutableArray array];
    [muArray4 addObject:@{@"title":@"晚安故事",@"image":@"http://hpimg.pianke.com/2e556b3b94a03000c193fd92eb7487aa20190214.jpg?imageView2/2/w/300/format/jpg",@"id" : @"detail_07"}];
    [muArray4 addObject:@{@"title":@"明天就要出嫁了",@"image":@"http://hpimg.pianke.com/7fa76174cb5dfa6b7ca2d257afc1911c20190223.jpg?imageView2/2/w/300/format/jpg",@"id" : @"detail_08"}];
    
    [self.dataArray addObject:muArray4];
    
    
    NSMutableArray *muArray5 = [NSMutableArray array];
    [muArray5 addObject:@{@"title":@"微笑是生活",@"image":@"http://hpimg.pianke.com/13b25b5c40d1f754948578c2a650426c20190307.png?imageView2/2/w/300/format/jpg",@"id" : @"detail_09"}];
    [muArray5 addObject:@{@"title":@"凡事忧愁",@"image":@"http://hpimg.pianke.com/68db3f6ce7f129a6dfa8a458f997055820190219.jpg?imageView2/2/w/300/format/jpg",@"id" : @"detail_010"}];
    
    [self.dataArray addObject:muArray5];
    
}


- (void)dealloc
{
    [self cleanTimer];
}


- (void)loadNewData
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_header endRefreshing];
    });
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MTActivityViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[MTActivityViewCell getIdentifier]];
    [cell setDataArray:self.dataArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (SCREEN_WIDTH - 15)/2 + 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}

#pragma mark - Timer
//添加定时器
-(void)addTimer{
    [[NSRunLoop currentRunLoop] addTimer:self.marketTimer forMode:NSRunLoopCommonModes];
}

- (void)timerAction:(id)sender
{
    self.totalTimes ++;
    [self.hotView switchCurrentBanner];
}

//删除定时器
-(void)cleanTimer{
    
    if (_marketTimer) {
        [_marketTimer invalidate];
        _marketTimer = nil;
    }
}

-(void)pauseTimer{
    
    if (_marketTimer) {
        _marketTimer.fireDate = [NSDate distantFuture];
    }
}
//继续定时器
- (void)continueTimer {
    if (_marketTimer) {
        _marketTimer.fireDate = [NSDate dateWithTimeIntervalSinceNow:0.5];
    }
}



#pragma mark - Lazy
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height) style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.hotView;
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView registerNib:[UINib nibWithNibName:@"MTActivityViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[MTActivityViewCell getIdentifier]];
        
    }
    return _tableView;
}

- (MTMarketHotView *)hotView
{
    if (!_hotView) {
        _hotView = [[MTMarketHotView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 170)];
        [_hotView setDataArray:nil];
    }
    return _hotView;
}

- (NSTimer *)marketTimer
{
    if (!_marketTimer) {
        _marketTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    }
    return _marketTimer;
}

@end
