//
//  MTActionToastView.m
//  Momenting
//
//  Created by xiaobai zhang on 2018/8/15.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import "MTActionToastView.h"

@interface MTActionToastView ()

@property (strong, nonatomic) UIVisualEffectView *effectView;
@property (weak, nonatomic) IBOutlet UIView *effectBgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation MTActionToastView

+ (instancetype)loadFromNib
{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"MTActionToastView" owner:nil options:nil];
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
    [self initBaseViews];
}

#pragma mark - initBaseViews
- (void)initBaseViews
{
    self.layer.cornerRadius = 5.f;
    self.layer.masksToBounds = YES;
    [self.effectBgView addSubview:self.effectView];
    [self.effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.bottom.equalTo(self);
    }];
}

- (void)show
{
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    CGPoint point = rootWindow.center;
    point.y = rootWindow.center.y + 50;
    self.center = point;
    [rootWindow addSubview:self];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
    
//    [UIView animateWithDuration:0.29 delay:0.1 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        self.hidden = NO;
//        [rootWindow layoutIfNeeded];
//        [self layoutIfNeeded];
//        [UIView animateWithDuration:0.29 delay:2 options:UIViewAnimationOptionCurveEaseIn animations:^{
//            self.hidden = YES;
//            [self layoutIfNeeded];
//        } completion:^(BOOL finished) {
//            [self removeFromSuperview];
//        }];
//    } completion:^(BOOL finished) {
//
//    }];
}

#pragma mark - setter
- (void)setContent:(NSString *)content
{
    _content = content;
    self.titleLabel.text = content;
}

#pragma mark - getter
- (UIVisualEffectView *)effectView
{
    if (!_effectView) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        _effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        _effectView.alpha = 0.8;
    }
    return _effectView;
}


@end
