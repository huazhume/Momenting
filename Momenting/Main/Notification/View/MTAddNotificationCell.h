//
//  MTAddNotificationCell.h
//  Momenting
//
//  Created by xiaobai zhang on 2018/8/27.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MTAddNotificationCellDelegate <NSObject>
@optional

- (void)noteCell:(UITableViewCell *)cell didChangeText:(NSString *)text;

- (void)noteCell:(UITableViewCell *)cell textViewWillBeginEditing:(UITextView *)textView;

- (void)noteCell:(UITableViewCell *)cell textViewDidEndEditing:(UITextView *)textView;

@end

@interface MTAddNotificationCell : UITableViewCell

@property (copy, nonatomic) NSString *title;

@property (weak, nonatomic) id <MTAddNotificationCellDelegate> delegate;

+ (CGFloat)heightForCell;

- (void)becomeFirstResponder;

@end
