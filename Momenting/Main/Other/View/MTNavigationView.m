//
//  MTNavigationView.m
//  Momenting
//
//  Created by huazhume on 2018/8/8.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import "MTNavigationView.h"

@implementation MTNavigationView

+ (instancetype)loadFromNib
{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"MTNavigationView" owner:nil options:nil];
    if (views && views.count > 0) {
        return [views firstObject];
    }
    return nil;
}

+ (CGFloat)viewHeight
{
    return 55.f;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}

#pragma mark - events

- (IBAction)leftButtonClicked:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(leftAction)]) {
        [self.delegate leftAction];
    }
}
- (IBAction)rightButtonClicked:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(rightAction)]) {
        [self.delegate rightAction];
    }
}

@end
