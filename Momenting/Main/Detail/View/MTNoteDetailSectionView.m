//
//  MTNoteDetailSectionView.m
//  Momenting
//
//  Created by xiaobai zhang on 2018/8/15.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import "MTNoteDetailSectionView.h"

@interface MTNoteDetailSectionView ()

@property (weak, nonatomic) IBOutlet UIButton *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *headerView;

@end

@implementation MTNoteDetailSectionView


+ (instancetype)loadFromNib
{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"MTNoteDetailSectionView" owner:nil options:nil];
    if (views && views.count > 0) {
        return [views firstObject];
    }
    return nil;
}

+ (CGFloat)viewHeight
{
    return 30.f;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setColor:(UIColor *)color
{
    self.headerView.backgroundColor = color;
}

@end
