//
//  MTHomeTextViewCell.h
//  Momenting
//
//  Created by xiaobai zhang on 2018/8/7.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MTNoteModel;

@interface MTHomeTextViewCell : UITableViewCell

@property (strong, nonatomic) MTNoteModel *model;

+ (CGFloat)heightForCellWithModel:(MTNoteModel *)model;

@end
