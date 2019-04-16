//
//  MTMarketHotBannerCell.h
//  finbtc
//
//  Created by xiaobai zhang on 2018/12/17.
//  Copyright © 2018年 MTY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTMarketHotBannerCell : UICollectionViewCell

@property (nonatomic, copy) NSArray *dataArray;

@property (nonatomic, strong, readonly) NSMutableArray *itemSubViews;

@property (strong, nonatomic) UIImageView *imageView;;

@end
