//
//  MTAddNotificationStateCell.m
//  Momenting
//
//  Created by xiaobai zhang on 2018/8/27.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import "MTAddNotificationStateCell.h"

@interface MTAddNotificationStateCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation MTAddNotificationStateCell

+ (CGFloat)heightForCell
{
    return 40.f;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initBaseViews];
    // Initialization code
}

#pragma mark - initBaseViews
- (void)initBaseViews
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.titleLabel.text = Localized(@"addNotificationState");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
