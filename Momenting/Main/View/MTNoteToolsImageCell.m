//
//  MTNoteToolsImageCell.m
//  Momenting
//
//  Created by xiaobai zhang on 2018/8/8.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import "MTNoteToolsImageCell.h"
#import "MTNoteModel.h"

@interface MTNoteToolsImageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;

@end

@implementation MTNoteToolsImageCell


+ (CGFloat)heightForCellWithModel:(MTNoteImageModel *)model
{
    return model.image.size.height / model.image.size.width * (CGRectGetWidth([UIScreen mainScreen].bounds) - 16);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}

- (void)setModel:(MTNoteImageModel *)model
{
    self.contentImageView.image = model.image;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
