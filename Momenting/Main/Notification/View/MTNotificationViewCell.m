//
//  MTNotificationViewCell.m
//  Momenting
//
//  Created by xiaobai zhang on 2018/8/24.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import "MTNotificationViewCell.h"
#import "MTNotificationVo.h"

@interface MTNotificationViewCell ()

@property (strong, nonatomic) UIVisualEffectView *effectView;
@property (weak, nonatomic) IBOutlet UIView *conntentSecView;
@property (weak, nonatomic) IBOutlet UIView *contentBgView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (strong, nonatomic) NSArray *colors;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *signButton;

@end

@implementation MTNotificationViewCell


+ (CGFloat)heightForCellWithModel:(MTNotificationVo *)model
{
    CGFloat textHeight = 0.f;
    if (model.content.length > 0) {
        CGSize textLabelSize = [model.content boundingRectWithSize:CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds) - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Light" size:12]} context:nil].size;
        textHeight = textLabelSize.height + 10.f;
    }
    return 46.f + textHeight;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initBaseViews];
    // Initialization code
}

- (void)initBaseViews
{
    
    self.colors = @[[UIColor colorWithHex:0x96B46C],[UIColor colorWithHex:0xE48370],[UIColor colorWithHex:0xC496C5],[UIColor colorWithHex:0x79B47C],[UIColor colorWithHex:0xA299CE],[UIColor colorWithHex:0xA2AEBB] ];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.contentBgView.layer.borderColor = [[UIColor colorWithHex:0xC496C5 andAlpha:0.6] CGColor];
    self.contentBgView.layer.borderWidth = 0.5;
    
    self.conntentSecView.layer.cornerRadius = 10.f;
    self.conntentSecView.layer.masksToBounds = YES;
    
    self.contentBgView.layer.cornerRadius = 10.f;
    self.contentBgView.layer.masksToBounds = YES;
    
    [self.signButton setImage:[UIImage imageNamed:@"notification_sign"] forState:UIControlStateNormal];
    [self.signButton setImage:[UIImage imageNamed:@"notification_sign_selected"] forState:UIControlStateSelected];
}

#pragma mark - Actions

- (IBAction)signButtonClicked:(id)sender
{
    self.signButton.selected = !self.signButton.isSelected;
}

- (void)setIndexRow:(NSInteger)indexRow
{
    _indexRow = indexRow;
    NSInteger index = indexRow % self.colors.count;
    self.topView.backgroundColor = self.colors[index];
    self.contentBgView.layer.borderColor = [self.topView.backgroundColor CGColor];
}

- (void)setSignName:(NSString *)signName
{
    _signName = signName;
    [self.signButton setImage:[UIImage imageNamed:signName] forState:UIControlStateNormal];
}

- (void)setModel:(MTNotificationVo *)model
{
    _model = model;
    [self.timeLabel setTitle:model.time forState:UIControlStateNormal];
    self.contentLabel.text = model.content;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
