//
//  MTActionSheetView.m
//  Momenting
//
//  Created by xiaobai zhang on 2018/8/8.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import "MTActionSheetView.h"

@interface MTActionSheetView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewBottomConstraint;
@property (weak, nonatomic) IBOutlet UIView *contentView;


@end

@implementation MTActionSheetView

+ (instancetype)loadFromNib
{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"MTActionSheetView" owner:nil options:nil];
    if (views && views.count > 0) {
        return [views firstObject];
    }
    return nil;
}

+ (CGFloat)viewHeight
{
    return 140.f;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)show
{
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];

    [UIView animateWithDuration:0.29 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.contentViewBottomConstraint.constant = 0.f;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - events
- (IBAction)sheetButtonClicked:(UIButton *)sender
{
    
    [UIView animateWithDuration:0.29 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.contentViewBottomConstraint.constant = -140.f;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(sheetToolsActionWithType:)]) {
            [self.delegate sheetToolsActionWithType:sender.tag];
        }
        [self removeFromSuperview];
    }];
}



@end
