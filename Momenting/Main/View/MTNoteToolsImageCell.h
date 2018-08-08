//
//  MTNoteToolsImageCell.h
//  Momenting
//
//  Created by xiaobai zhang on 2018/8/8.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MTNoteImageModel;

@interface MTNoteToolsImageCell : UITableViewCell

@property (strong, nonatomic) MTNoteImageModel *model;

+ (CGFloat)heightForCellWithModel:(MTNoteImageModel *)model;


@end
