//
//  MTSettingNameCell.h
//  Momenting
//
//  Created by xiaobai zhang on 2018/8/23.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTSettingNameCell : UITableViewCell

@property (copy, nonatomic) NSString *title;

+ (CGFloat)heightForCell;

- (void)becomeFirstResponder;

@end
