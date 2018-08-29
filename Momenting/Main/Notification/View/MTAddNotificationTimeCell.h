//
//  MTAddNotificationTimeCell.h
//  Momenting
//
//  Created by xiaobai zhang on 2018/8/27.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MTAddNotificationTimeCellDelegate <NSObject>

- (void)notificationTime:(NSString *)time withIsHour:(BOOL)isHour;

@end

@interface MTAddNotificationTimeCell : UITableViewCell

@property (weak, nonatomic) id <MTAddNotificationTimeCellDelegate> delegate;

+ (CGFloat)heightForCell;

@end
