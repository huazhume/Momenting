//
//  MTForegroundPushView.m
//  finbtc
//
//  Created by xiaobai zhang on 2018/7/31.
//  Copyright © 2018年 MTY. All rights reserved.
//

#import "MTForegroundPushView.h"
#import <Masonry/Masonry.h>
#import "EBCustomBannerView.h"
#import "MTNotificationVo.h"


@interface MTForegroundPushView ()

@property (strong, nonatomic) UIImageView *logoImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UIVisualEffectView *effectView;

@property (strong, nonatomic) UIView *contentView;

@end

@implementation MTForegroundPushView

+ (CGFloat)heightForViewWithContent:(NSString *)content
{
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
    CGSize textLabelSize = [content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    CGFloat maxHeight = [UIFont systemFontOfSize:13].lineHeight * 4 + 4;
    if (textLabelSize.height < maxHeight) {
        maxHeight = textLabelSize.height;
    }
    return 58 +  maxHeight;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initBaseViews];
    }
    return self;
}

- (void)initBaseViews
{
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.contentView];
    [self.contentView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.top.equalTo(self).offset(10);
        make.leading.equalTo(self).offset(8);
        make.trailing.equalTo(self).offset(-8);
    }];
    
    [self.contentView addSubview:self.effectView];
    [self.effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.logoImageView];
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).offset(12);
        make.top.equalTo(self.contentView).offset(9);
        make.size.mas_equalTo(CGSizeMake(19, 19));
    }];
    
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.logoImageView).offset(2);
    }];
    
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.logoImageView.mas_trailing).offset(8);
        make.centerY.equalTo(self.timeLabel);
        make.trailing.mas_lessThanOrEqualTo(self.timeLabel);
    }];
    
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).offset(12);
        make.trailing.equalTo(self.contentView).offset(-12);
        make.top.equalTo(self.logoImageView.mas_bottom).offset(8);
        make.bottom.equalTo(self.contentView).offset(-9);
    }];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
    self.userInteractionEnabled = YES;
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)];
    swipe.direction = UISwipeGestureRecognizerDirectionUp;
    [self addGestureRecognizer:swipe];
}

#pragma mark - Actions
- (void)tapAction:(id)sender
{
    if (self.callback) {
        self.callback();
    }
    [self.customView hide];
}

- (void)swipeAction:(id)sender
{
    [self.customView hide];
}

#pragma mark - setter
- (void)setModel:(MTNotificationVo *)model
{
    self.contentLabel.text = model.content;
}


#pragma mark - getter
- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor colorWithHex:0xFFFFFF andAlpha:0.8];
        _contentView.layer.masksToBounds = YES;
        _contentView.layer.cornerRadius = 10.f;
//        _contentView.layer.shadowOpacity = 0.5;// 阴影透明度
//        _contentView.layer.shadowColor = [UIColor grayColor].CGColor;// 阴影的颜色
//        _contentView.layer.shadowRadius = 3;// 阴影扩散的范围控制
//        _contentView.layer.shadowOffset = CGSizeMake(1, 1);// 阴影的范围
    }
    return _contentView;
}

- (UIImageView *)logoImageView
{
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] init];
        _logoImageView.image = [UIImage imageNamed:@"secret_logo"];
        _logoImageView.layer.cornerRadius = 4.f;
        _logoImageView.layer.masksToBounds = YES;
    }
    return _logoImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textColor = [UIColor colorWithHex:0x666666];
        _titleLabel.text = @"你的小秘密";
    }
    return _titleLabel;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = [UIFont systemFontOfSize:13];
        _contentLabel.textColor = [UIColor colorWithHex:0x333333];
        _contentLabel.text = @"你知道我有多想你么";
    }
    return _contentLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.textColor = [UIColor colorWithHex:0x666666];
        _timeLabel.text = @"现在";
    }
    return _timeLabel;
}

- (UIVisualEffectView *)effectView
{
    if (!_effectView) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        _effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        _effectView.layer.cornerRadius = 10.f;
        _effectView.layer.masksToBounds = YES;
        _effectView.alpha = 0.8;
    }
    return _effectView;
}

@end
