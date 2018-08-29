//
//  MTNotificationViewCell.h
//  Momenting
//
//  Created by xiaobai zhang on 2018/8/24.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MTNotificationVo;

@interface MTNotificationViewCell : UITableViewCell

@property (copy, nonatomic) NSString *signName;

@property (strong, nonatomic) MTNotificationVo *model;

@property (assign, nonatomic) NSInteger indexRow;

+ (CGFloat)heightForCellWithModel:(MTNotificationVo *)model;

@end
