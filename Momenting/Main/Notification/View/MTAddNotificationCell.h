//
//  MTAddNotificationCell.h
//  Momenting
//
//  Created by xiaobai zhang on 2018/8/27.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTAddNotificationCell : UITableViewCell

@property (copy, nonatomic) NSString *title;

+ (CGFloat)heightForCell;

- (void)becomeFirstResponder;

@end
