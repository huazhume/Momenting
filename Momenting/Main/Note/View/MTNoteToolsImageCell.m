//
//  MTNoteToolsImageCell.m
//  Momenting
//
//  Created by xiaobai zhang on 2018/8/8.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import "MTNoteToolsImageCell.h"
#import "MTNoteModel.h"
#import "MTMediaFileManager.h"

@interface MTNoteToolsImageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

@end

@implementation MTNoteToolsImageCell


+ (CGFloat)heightForCellWithModel:(MTNoteImageVo *)model
{
    return model.height / model.width * (CGRectGetWidth([UIScreen mainScreen].bounds) - 16);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}

- (void)setModel:(MTNoteImageVo *)model
{
    NSString *path = [[MTMediaFileManager sharedManager] getMediaFilePathWithAndSanBoxType:SANBOX_DOCUMNET_TYPE AndMediaType:FILE_IMAGE_TYPE];
    self.contentImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",path,model.path]]];
}

- (void)setType:(MTNoteToolsImageCellType)type
{
    self.editButton.hidden = (type == MTNoteToolsImageCellDetail);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
