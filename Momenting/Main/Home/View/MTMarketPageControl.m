//
//  MTMarketPageControl.m
//  finbtc
//
//  Created by zhangyi on 2018/12/11.
//  Copyright © 2018年 MTY. All rights reserved.
//

#import "MTMarketPageControl.h"

static CGFloat dotWidth = 10;
static CGFloat dotHeight = 3;
static CGFloat margin = 3;

@implementation MTMarketPageControl

- (void)layoutSubviews{
    [super layoutSubviews];
    //计算圆点间距
    CGFloat marginX = dotWidth + margin;
    
    //计算整个pageControll的宽度
    CGFloat newW = self.subviews.count * dotWidth + (self.subviews.count - 1 ) * margin;
    
    //设置新frame
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, newW, self.frame.size.height);
    
    //设置居中
    CGPoint center = self.center;
    center.x = self.superview.center.x;
    self.center = center;
    
    //遍历subview,设置圆点frame
    for (int i=0; i<[self.subviews count]; i++) {
        UIImageView* dot = [self.subviews objectAtIndex:i];
        
        if (i == self.currentPage) {
            [dot setFrame:CGRectMake(i * marginX, dot.frame.origin.y, dotWidth, dotHeight)];
        }else {
            [dot setFrame:CGRectMake(i * marginX, dot.frame.origin.y, dotWidth, dotHeight)];
        }
    }
}

@end
