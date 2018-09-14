//
//  MTNoteSettingHeaderCell.m
//  Momenting
//
//  Created by huazhume on 2018/8/18.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import "MTNoteSettingHeaderCell.h"
#import "MTMeModel.h"
#import "MTUserInfoDefault.h"

@interface MTNoteSettingHeaderCell ()
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *aboutLabel;

@end

@implementation MTNoteSettingHeaderCell

+ (CGFloat)heightForCell
{
    return 120.f;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.coverImageView.layer.cornerRadius = self.coverImageView.bounds.size.height / 2.0;
    self.coverImageView.layer.masksToBounds = YES;
}

- (void)refreshCell
{
    MTMeModel *meModel = [MTUserInfoDefault getUserDefaultMeModel];
    self.coverImageView.image = [UIImage imageWithContentsOfFile:meModel.image];
    self.nameLabel.text = meModel.name ?: Localized(@"username");;
    self.aboutLabel.text = meModel.about ?: Localized(@"userDescription");
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
