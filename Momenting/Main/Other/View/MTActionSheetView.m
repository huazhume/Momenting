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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deleteLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *deleteLabel;
@property (assign, nonatomic) CGFloat contentViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *alphaView;


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
    self.contentViewHeight = 140.f;
}

- (void)show
{
    self.contentViewHeightConstraint.constant = self.contentViewHeight;
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    self.alphaView.alpha = 0.0;
    [UIView animateWithDuration:0.29 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.contentViewBottomConstraint.constant = 0.f;
        self.alphaView.alpha = 0.3;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - events
- (IBAction)sheetButtonClicked:(UIButton *)sender
{
    
    [UIView animateWithDuration:0.29 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.contentViewBottomConstraint.constant = - self.contentViewHeight;
        self.alphaView.alpha = 0.0;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(sheetToolsActionWithType:)]) {
            [self.delegate sheetToolsActionWithType:sender.tag];
        }
        [self removeFromSuperview];
    }];
}

#pragma mark - setter
- (void)setIsShowDelete:(BOOL)isShowDelete
{
    CGFloat height = 140.f / 3.0;
    self.contentViewHeight = isShowDelete ? height * 4 : height * 3;
    self.deleteLabelHeightConstraint.constant = height;
    self.deleteLabel.hidden = !isShowDelete;
}



@end
