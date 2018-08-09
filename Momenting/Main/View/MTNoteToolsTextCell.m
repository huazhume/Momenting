//
//  MTNoteToolsTextCell.m
//  Momenting
//
//  Created by xiaobai zhang on 2018/8/8.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import "MTNoteToolsTextCell.h"
#import "UIColor+Hex.h"
#import "UITextView+Category.h"
#import "MTNoteModel.h"

@interface MTNoteToolsTextCell ()
<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation MTNoteToolsTextCell

+ (CGFloat)heightForCell
{
    return 150.f;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.textView.delegate = self;
    [self.textView setPlaceholder:@"Miss Zhou. Please input..." placeholdColor:[UIColor colorWithHex:0x666666] font:[UIFont fontWithName:@"AvenirNext-Italic" size:14]];
    // Initialization code
}

#pragma mark - textView delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView;
{
    
    if ([self.delegate respondsToSelector:@selector(noteCell:textViewWillBeginEditing:)]) {
        [self.delegate noteCell:self textViewWillBeginEditing:textView];
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    
    if ([self.delegate respondsToSelector:@selector(noteCell:didChangeText:)]) {
        [self.delegate noteCell:self didChangeText:self.textView.text];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    
    if ([self.delegate respondsToSelector:@selector(noteCell:textViewDidEndEditing:)]) {
        [self.delegate noteCell:self textViewDidEndEditing:textView];
    }
}


#pragma mark - setter
- (void)setFont:(UIFont *)font
{
    _font = font;
    self.textView.font = font;
}

- (void)becomeKeyboardFirstResponder
{
    [self.textView becomeFirstResponder];
}

- (void)setModel:(MTNoteTextVo *)model
{
    self.textView.text = model.text;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
