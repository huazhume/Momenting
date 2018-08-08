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

@interface ViewController ()
<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,
MTHomeSectionViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) MTHomeSectionView *sectionView;
@property (assign, nonatomic) CGPoint scrollViewOldOffset;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBaseViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - Views
- (void)initBaseViews
{
    [self.tableView registerNib:[UINib nibWithNibName:@"MTHomeTextViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[MTHomeTextViewCell getIdentifier]];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    self.navigationController.navigationBar.hidden = YES;
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
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MTHomeTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[MTHomeTextViewCell getIdentifier]];
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

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MTHomeTextViewCell heightForCell];
}

#pragma mark - MTHomeSectionViewDelegate
- (void)homeNoteAction
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

- (void)dealloc
{
    [self.tableView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
