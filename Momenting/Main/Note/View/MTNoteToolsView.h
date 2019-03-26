//
//  MTNoteToolsView.h
//  Momenting
//
//  Created by huazhume on 2018/8/8.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    MTNoteToolsViewFont = 0,
    MTNoteToolsViewItalic,
    MTNoteToolsViewRank,
    MTNoteToolsViewSement,
    MTNoteToolsViewAt,
    MTNoteToolsViewImage,
    MTNoteToolsViewKeyboardDiss,
} MTNoteToolsViewType;


@protocol MTNoteToolsViewDelegate <NSObject>

- (void)noteToolsFootActionWithFont:(UIFont *)font;

- (void)noteToolsActionWithType:(MTNoteToolsViewType)type;

@end

@interface MTNoteToolsView : UIView

@property (weak, nonatomic) id <MTNoteToolsViewDelegate> delegate;

@property (assign, nonatomic) BOOL keyBoardIsVisiable;

@property (copy, nonatomic) NSString *weatherTitle;

+ (instancetype)loadFromNib;

+ (CGFloat)viewHeight;


@end
