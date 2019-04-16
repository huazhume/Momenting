//
//  MTMarketHotView.m
//  finbtc
//
//  Created by xiaobai zhang on 2018/12/11.
//  Copyright © 2018年 MTY. All rights reserved.
//

#import "MTMarketHotView.h"
#import "MTMarketHotBannerCell.h"
#import "MTMarketPageControl.h"
#import <Masonry/Masonry.h>
#import "MTMarketHotItemView.h"
#import "MTNoteDetailViewController.h"


@interface MTMarketHotView() <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) MTMarketPageControl *pageControl;

@property (nonatomic, strong) NSMutableArray *pageArray;

/**当前滚动的位置*/
@property (nonatomic, assign) NSInteger currentIndex;

/**上次滚动的位置*/
@property (nonatomic, assign) NSInteger lastIndex;

/**是否拖动了*/
@property (nonatomic, assign) BOOL isDrag;

@end

@implementation MTMarketHotView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initBaseViews];
    }
    return self;
}

- (void)initBaseViews
{
    [self addSubview:self.collectionView];
    [self addSubview:self.pageControl];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.equalTo(self);
        make.bottom.equalTo(self).offset(0);
    }];
    [self.collectionView reloadData];
}

- (void)setDataArray:(NSArray *)dataArray
{
    
//    if (!dataArray.count) return;
    _dataArray = dataArray;
    self.pageArray = [@[@{},@{},@{},@{},@{}] mutableCopy];
    self.pageControl.numberOfPages = self.pageArray.count - 2;
    NSArray *cells = self.collectionView.visibleCells;//加载出来的cells 当前只有一个
    if (!cells.count) {
        //不存在 说明第一次加载 则滑倒第二个cell的位置
        [self.collectionView setContentOffset:CGPointMake(_collectionView.bounds.size.width, 0)];
    }
    [self.collectionView reloadData];
}


#pragma mark - Timer
- (void)switchCurrentBanner
{
    if (self.isDrag) return;
    [self nextpage];
}

- (void)nextpage
{
    //手指拖拽是禁止自动轮播
    if (_collectionView.isDragging) {return;}
    CGFloat targetX =  _collectionView.contentOffset.x + _collectionView.bounds.size.width;
    [_collectionView setContentOffset:CGPointMake(targetX, 0) animated:true];
}

#pragma mark - UICollectionViewDataSource & delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.pageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //重用
    NSString *identifierString = NSStringFromClass([MTMarketHotBannerCell class]);
    MTMarketHotBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifierString forIndexPath:indexPath];
    cell.dataArray = self.pageArray[indexPath.row];
    
    NSInteger index = indexPath.row - 1;
    if (indexPath.row == 0) {
        index = 2;
    }
    if (indexPath.row == self.pageArray.count - 1) {
        index = 0;
    }
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"banner_0%ld",index+1]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.frame.size.width, 165);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.01f;
}
- (CGFloat )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.01f;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger index = indexPath.row - 1;
    if (indexPath.row == 0) {
        index = 2;
    }
    if (indexPath.row == self.pageArray.count - 1) {
        index = 0;
    }
    MTNoteDetailViewController *detailVC = [[MTNoteDetailViewController alloc] init];
    detailVC.noteId = [NSString stringWithFormat:@"banner_0%ld",index+1];
    detailVC.isJubaoHidden = YES;
    detailVC.isStatusBarHidden = [UIApplication sharedApplication].isStatusBarHidden;
    [[MTHelp currentNavigation] pushViewController:detailVC animated:YES];
}


//手动拖拽结束
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self cycleScroll];
    //拖拽动作后间隔3s继续轮播
    self.isDrag = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isDrag = NO;
    });
}

//自动轮播结束
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self cycleScroll];
}

//循环显示
- (void)cycleScroll {
    NSInteger page = _collectionView.contentOffset.x/_collectionView.bounds.size.width;
    if (page == 0) {//滚动到左边
        _collectionView.contentOffset = CGPointMake(_collectionView.bounds.size.width * (_pageArray.count - 2), 0);
        _pageControl.currentPage = _pageArray.count - 2;
    }else if (page == _pageArray.count - 1){//滚动到右边
        _collectionView.contentOffset = CGPointMake(_collectionView.bounds.size.width, 0);
        _pageControl.currentPage = 0;
    }else{
        _pageControl.currentPage = page - 1;
    }
}

#pragma mark - getter
- (UICollectionView *)collectionView
{
    if (!_collectionView ) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.itemSize = CGSizeMake(self.frame.size.width,self.frame.size.height);
        flowLayout.sectionInset  = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        NSString *identifierString = NSStringFromClass([MTMarketHotBannerCell class]);
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[MTMarketHotBannerCell class] forCellWithReuseIdentifier:identifierString];
    }
    return  _collectionView;
}

- (MTMarketPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[MTMarketPageControl alloc]initWithFrame:CGRectMake(0, 147, SCREEN_WIDTH, 16)];
        _pageControl.numberOfPages = 2;
        _pageControl.userInteractionEnabled = NO;
        _pageControl.center = CGPointMake(self.center.x, _pageControl.center.y);
        [_pageControl setValue:[UIImage imageNamed:@"market_home_page"] forKeyPath:@"_pageImage"];
        [_pageControl setValue:[UIImage imageNamed:@"market_home_page_selected"] forKeyPath:@"_currentPageImage"];
    }
    return _pageControl;
}

- (NSMutableArray *)pageArray
{
    if (!_pageArray) {
        _pageArray = [NSMutableArray array];
    }
    return _pageArray;
}


@end


