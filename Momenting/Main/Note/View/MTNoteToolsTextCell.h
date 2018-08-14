//
//  MTNoteToolsTextCell.h
//  Momenting
//
//  Created by xiaobai zhang on 2018/8/8.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MTNoteTextVo;

@protocol MTNoteToolsTextCellDelegate <NSObject>
@optional

- (void)noteCell:(UITableViewCell *)cell didChangeText:(NSString *)text;

- (void)noteCell:(UITableViewCell *)cell textViewWillBeginEditing:(UITextView *)textView;

- (void)noteCell:(UITableViewCell *)cell textViewDidEndEditing:(UITextView *)textView;

@end

typedef enum : NSUInteger {
    MTNoteToolsTextCellNormal,
    MTNoteToolsTextCellDetail,
} MTNoteToolsTextCellType;


@interface MTNoteToolsTextCell : UITableViewCell

@property (strong, nonatomic) UIFont *font;

@property (weak, nonatomic) id <MTNoteToolsTextCellDelegate> delegate;

@property (strong, nonatomic) MTNoteTextVo *model;

@property (assign, nonatomic) MTNoteToolsTextCellType type;

+ (CGFloat)heightForCell;

+ (CGFloat)heightForCellWithModel:(MTNoteTextVo *)model;

- (void)becomeKeyboardFirstResponder;

@end
