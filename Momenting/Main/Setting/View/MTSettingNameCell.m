//
//  MTSettingNameCell.m
//  Momenting
//
//  Created by xiaobai zhang on 2018/8/23.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import "MTSettingNameCell.h"

@interface MTSettingNameCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation MTSettingNameCell


+ (CGFloat)heightForCell
{
    return 100.f;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)becomeFirstResponder
{
    [self.textView becomeFirstResponder];
}

#pragma mark - setting & getter
- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
