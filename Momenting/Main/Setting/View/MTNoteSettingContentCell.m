//
//  MTNoteSettingContentCell.m
//  Momenting
//
//  Created by huazhume on 2018/8/18.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import "MTNoteSettingContentCell.h"

@implementation MTNoteSettingContentCell


+ (CGFloat)heightForCell
{
    return 50.f;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
