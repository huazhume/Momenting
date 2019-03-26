//
//  MTNoteToolsView.m
//  Momenting
//
//  Created by huazhume on 2018/8/8.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import "MTNoteToolsView.h"

@interface MTNoteToolsView ()

@property (assign, nonatomic) NSInteger fontIndex;
@property (assign, nonatomic) NSInteger italicIndex;
@property (strong, nonatomic) NSArray *fonts;
@property (strong, nonatomic) NSArray *fontImages;
@property (strong, nonatomic) NSArray *italicImages;
@property (strong, nonatomic) NSArray *italicFonts;
@property (strong, nonatomic) NSArray *rankImages;
@property (assign, nonatomic) NSInteger rankIndex;
@property (weak, nonatomic) IBOutlet UIButton *normalFontButton;
@property (weak, nonatomic) IBOutlet UIButton *italicFontButton;
@property (weak, nonatomic) IBOutlet UIButton *keyboardButton;
@property (weak, nonatomic) IBOutlet UIButton *weatherButton;

@end

@implementation MTNoteToolsView

+ (instancetype)loadFromNib
{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"MTNoteToolsView" owner:nil options:nil];
    if (views && views.count > 0) {
        return [views firstObject];
    }
    return nil;
}

+ (CGFloat)viewHeight
{
    return 40.f;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.fonts = @[[UIFont fontWithName:@"PingFangSC-Light" size:14],[UIFont fontWithName:@"PingFangSC-Medium" size:14],[UIFont fontWithName:@"PingFangSC-Regular" size:14]];
    self.fontImages = @[@"editor-toolbar-title-0" ,@"editor-toolbar-title-1",@"editor-toolbar-title-2"];
    
    self.italicFonts = @[[UIFont fontWithName:@"AvenirNext-UltraLightItalic" size:14],[UIFont fontWithName:@"AvenirNext-MediumItalic" size:14],[UIFont fontWithName:@"AvenirNext-Italic" size:14]];
    self.italicImages = @[@"editor-toolbar-quote-0" ,@"editor-toolbar-quote-1",@"editor-toolbar-quote-2"];
    self.rankImages = @[@"editor-toolbar-list-0" ,@"editor-toolbar-list-1",@"editor-toolbar-list-2"];
    
    self.weatherButton.titleLabel.font = [UIFont mtWeatherFontWithFontSize:22];
}

#pragma mark - setter
- (void)setKeyBoardIsVisiable:(BOOL)keyBoardIsVisiable
{
    _keyBoardIsVisiable = keyBoardIsVisiable;
    self.keyboardButton.hidden = !keyBoardIsVisiable;
}

- (void)setWeatherTitle:(NSString *)weatherTitle
{
    _weatherTitle = weatherTitle;
    [self.weatherButton setTitle:weatherTitle forState:UIControlStateNormal];
}

#pragma mark - events
- (IBAction)toolsButtonClicked:(UIButton *)sender
{
    if (sender.tag == MTNoteToolsViewFont) {
        
        self.italicIndex = 0;
        [self.italicFontButton setImage:[UIImage imageNamed:self.italicImages[self.italicIndex]] forState:UIControlStateNormal];
        self.fontIndex ++;
        if (self.fontIndex == 3) {
            self.fontIndex = 0;
        }
        [sender setImage:[UIImage imageNamed:self.fontImages[self.fontIndex]] forState:UIControlStateNormal];
        if (self.delegate && [self.delegate respondsToSelector:@selector(noteToolsFootActionWithFont:)]) {
            [self.delegate noteToolsFootActionWithFont:self.fonts[self.fontIndex]];
        }
    } else if (sender.tag == MTNoteToolsViewItalic) {
        
        self.fontIndex = 0;
        [self.normalFontButton setImage:[UIImage imageNamed:self.fontImages[self.fontIndex]] forState:UIControlStateNormal];
        self.italicIndex ++;
        if (self.italicIndex == 3) {
            self.italicIndex = 0;
        }
        [sender setImage:[UIImage imageNamed:self.italicImages[self.italicIndex]] forState:UIControlStateNormal];
        if (self.delegate && [self.delegate respondsToSelector:@selector(noteToolsFootActionWithFont:)]) {
            [self.delegate noteToolsFootActionWithFont:self.italicFonts[self.italicIndex]];
        }
        
    } else if (sender.tag == MTNoteToolsViewRank) {
        
        self.rankIndex ++;
        if (self.rankIndex == 3) {
            self.rankIndex = 0;
        }
        [sender setImage:[UIImage imageNamed:self.rankImages[self.rankIndex]] forState:UIControlStateNormal];
    } else if (sender.tag == MTNoteToolsViewKeyboardDiss) {
        
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(noteToolsActionWithType:)]) {
            [self.delegate noteToolsActionWithType:sender.tag];
        }
    }
}
@end
