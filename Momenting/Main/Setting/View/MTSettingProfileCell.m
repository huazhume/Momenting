//
//  MTSettingProfileCell.m
//  Momenting
//
//  Created by xiaobai zhang on 2018/8/23.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import "MTSettingProfileCell.h"
#import "MTMediaFileManager.h"

@interface MTSettingProfileCell ()

@property (weak, nonatomic) IBOutlet UILabel *editProfileLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@end


@implementation MTSettingProfileCell

+ (CGFloat)heightForCell
{
    return 80.f;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.coverImageView.layer.cornerRadius = self.coverImageView.bounds.size.height / 2.0;
    self.coverImageView.layer.masksToBounds = YES;
    self.editProfileLabel.text = Localized(@"profileEditPicture");
    
}

- (void)refreshCell
{
     self.coverImageView.image = [UIImage imageWithContentsOfFile:[[MTMediaFileManager sharedManager] getUserImageFilePath]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
