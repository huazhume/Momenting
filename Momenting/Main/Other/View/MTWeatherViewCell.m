//
//  MTWeatherViewCell.m
//  Momenting
//
//  Created by xiaobai zhang on 2018/10/26.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import "MTWeatherViewCell.h"

@interface MTWeatherViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation MTWeatherViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.font = [UIFont mtWeatherFontWithFontSize:24];
    self.titleLabel.textColor = [UIColor colorWithHex:0x333333];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}

- (void)setTitle:(NSString *)title selectTitle:(NSString *)selectTitle
{
    self.titleLabel.textColor = [title isEqualToString:selectTitle] ? [UIColor colorWithHex:0x039369] : [UIColor colorWithHex:0x333333];
    self.titleLabel.text = title;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
