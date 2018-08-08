//
//  MTHomeTextViewCell.m
//  Momenting
//
//  Created by xiaobai zhang on 2018/8/7.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import "MTHomeTextViewCell.h"
#import <Masonry/Masonry.h>

@interface MTHomeTextViewCell ()

@property (strong, nonatomic) UIVisualEffectView *effectView;
@property (weak, nonatomic) IBOutlet UIView *conntentSecView;

@end

@implementation MTHomeTextViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initBaseViews];
    // Initialization code
}


+ (CGFloat)heightForCell
{
    return 200.f;
}

- (void)initBaseViews
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.conntentSecView.layer.cornerRadius = 10.f;
    self.conntentSecView.layer.masksToBounds = YES;
    
    [self.conntentSecView addSubview:self.effectView];
    [self.effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.conntentSecView);
    }];
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
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
