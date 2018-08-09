//
//  MTHomeSectionView.m
//  Momenting
//
//  Created by xiaobai zhang on 2018/8/7.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import "MTHomeSectionView.h"

@implementation MTHomeSectionView

+ (instancetype)loadFromNib
{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"MTHomeSectionView" owner:nil options:nil];
    if (views && views.count > 0) {
        return [views firstObject];
    }
    return nil;
}

+ (CGFloat)viewHeight
{
    return 40.f;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}

#pragma mark - events
- (IBAction)noteButtonClicked:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(homeNoteAction)]) {
        [self.delegate homeNoteAction];
    }
}

- (IBAction)noteSettingButtonClicked:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(homeSettingAction)]) {
        [self.delegate homeSettingAction];
    }
}

@end
