//
//  MTNoteDetailSectionView.h
//  Momenting
//
//  Created by xiaobai zhang on 2018/8/15.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTNoteDetailSectionView : UIView

@property (strong, nonatomic) UIColor *color;

+ (instancetype)loadFromNib;

+ (CGFloat)viewHeight;

@end
