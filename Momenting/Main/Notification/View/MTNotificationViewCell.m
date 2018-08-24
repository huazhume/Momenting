//
//  MTNotificationViewCell.m
//  Momenting
//
//  Created by xiaobai zhang on 2018/8/24.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import "MTNotificationViewCell.h"

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

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initBaseViews];
    // Initialization code
}

- (void)initBaseViews
{
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
- (void)setSignName:(NSString *)signName
{
    _signName = signName;
    [self.signButton setImage:[UIImage imageNamed:signName] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
