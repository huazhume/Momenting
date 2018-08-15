//
//  MTNoteToolsImageCell.h
//  Momenting
//
//  Created by xiaobai zhang on 2018/8/8.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MTNoteImageVo;


typedef enum : NSUInteger {
    MTNoteToolsImageCellNormal,
    MTNoteToolsImageCellDetail,
} MTNoteToolsImageCellType;

@interface MTNoteToolsImageCell : UITableViewCell

@property (strong, nonatomic) MTNoteImageVo *model;

@property (assign, nonatomic) MTNoteToolsImageCellType type;

+ (CGFloat)heightForCellWithModel:(MTNoteImageVo *)model;


@end
