//
//  MTNoteToolsTextCell.h
//  Momenting
//
//  Created by xiaobai zhang on 2018/8/8.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MTNoteToolsTextCellDelegate <NSObject>
@optional

- (void)noteCell:(UITableViewCell *)cell didChangeText:(NSString *)text;

- (void)noteCell:(UITableViewCell *)cell textViewWillBeginEditing:(UITextView *)textView;

- (void)noteCell:(UITableViewCell *)cell textViewDidEndEditing:(UITextView *)textView;

@end


@interface MTNoteToolsTextCell : UITableViewCell

@property (strong, nonatomic) UIFont *font;

@property (weak, nonatomic) id <MTNoteToolsTextCellDelegate> delegate;

+ (CGFloat)heightForCell;

- (void)becomeKeyboardFirstResponder;

@end
