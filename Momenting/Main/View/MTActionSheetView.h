//
//  MTActionSheetView.h
//  Momenting
//
//  Created by xiaobai zhang on 2018/8/8.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    MTActionSheetViewCancel = 0,
    MTActionSheetViewOne,
    MTActionSheetViewTwo,
    MTActionSheetViewDelete,
} MTActionSheetViewType;

@protocol MTActionSheetViewDelegate <NSObject>

- (void)sheetToolsActionWithType:(MTActionSheetViewType)type;

@end

@interface MTActionSheetView : UIView

@property (weak, nonatomic) id <MTActionSheetViewDelegate> delegate;

@property (assign, nonatomic) BOOL isShowDelete;

+ (instancetype)loadFromNib;

+ (CGFloat)viewHeight;

- (void)show;

@end
