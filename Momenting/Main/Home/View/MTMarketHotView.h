//
//  MTMarketHotView.h
//  finbtc
//
//  Created by xiaobai zhang on 2018/12/11.
//  Copyright © 2018年 MTY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTMarketHotView : UIView

@property (nonatomic, copy) NSArray * dataArray;

/**
 切换banner
 */
-(void)switchCurrentBanner;

@end

