//
//  MTActionAlertView.m
//  Momenting
//
//  Created by xiaobai zhang on 2018/8/10.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import "MTActionAlertView.h"

@interface MTActionAlertView ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *contentAphaView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UIButton *alphaView;

@end

@implementation MTActionAlertView

+ (instancetype)loadFromNib
{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"MTActionAlertView" owner:nil options:nil];
    if (views && views.count > 0) {
        return [views firstObject];
    }
    return nil;
}

+ (CGFloat)viewHeight
{
    return 140.f;
}

+ (void)alertShowWithMessage:(NSString *)message leftTitle:(NSString *)leftTitle leftColor:(UIColor *)color rightTitle:(NSString *)rightTitle rightColor:(UIColor *)rightColor callBack:(AlertBlock)block
{
    MTActionAlertView *alertView = [MTActionAlertView loadFromNib];
    alertView.frame = [UIScreen mainScreen].bounds;
    [alertView setMessage:message leftTitle:leftTitle leftColor:color rightTitle:rightTitle rightColor:rightColor];
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:alertView];
    alertView.block = ^(NSInteger index) {
        if (block) {
            block(index);
        }
    };
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.contentAphaView.layer.cornerRadius = 8.f;
    self.contentAphaView.layer.masksToBounds = YES;
    
    self.contentView.layer.cornerRadius = 8.f;
    self.contentView.layer.masksToBounds = YES;
}

- (void)setMessage:(NSString *)message leftTitle:(NSString *)leftTitle leftColor:(UIColor *)color rightTitle:(NSString *)rightTitle rightColor:(UIColor *)rightColor
{
    self.contentLabel.text = message;
    [self.leftButton setTitle:leftTitle forState:UIControlStateNormal];
    [self.rightButton setTitle:rightTitle forState:UIControlStateNormal];
    
    [self.leftButton setTitleColor:color forState:UIControlStateNormal];
    [self.rightButton setTitleColor:rightColor forState:UIControlStateNormal];
}

- (void)show
{
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    self.contentView.alpha = 0.f;
    self.alphaView.alpha = 0.f;
    [UIView animateWithDuration:0.29 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.contentView.alpha = 1;
         self.alphaView.alpha = 0.3f;
        [self.contentView layoutIfNeeded];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
    
    }];
}

- (IBAction)alertAction:(UIButton *)sender
{
    if (sender.tag == 0) {
        [self removeFromSuperview];
        return;
    }
    
    if (self.block) {
        self.block(sender.tag);
    }
    
    [UIView animateWithDuration:0.29 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.contentView.alpha = 0.f;
        self.alphaView.alpha = 0.f;
        [self.contentView layoutIfNeeded];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
         [self removeFromSuperview];
    }];
    
}



@end
