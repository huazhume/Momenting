//
//  MTNavigationView.h
//  Momenting
//
//  Created by huazhume on 2018/8/8.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MTNavigationViewDelegate <NSObject>

- (void)leftAction;

- (void)rightAction;

@end

typedef NS_ENUM(NSUInteger, MTNavigationViewType) {
    MTNavigationViewNote = 0,
    MTNavigationViewNoteDetail,
};


@interface MTNavigationView : UIView

@property (weak, nonatomic) id <MTNavigationViewDelegate> delegate;

@property (assign, nonatomic) MTNavigationViewType type;

+ (instancetype)loadFromNib;

+ (CGFloat)viewHeight;

@end
