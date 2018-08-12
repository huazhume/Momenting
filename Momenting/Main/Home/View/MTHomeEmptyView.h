//
//  MTHomeEmptyView.h
//  Momenting
//
//  Created by xiaobai zhang on 2018/8/9.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MTHomeEmptyViewDelegate <NSObject>

- (void)emptyNoteAction;


@end

@interface MTHomeEmptyView : UIView

@property (weak, nonatomic) id <MTHomeEmptyViewDelegate> delegate;

+ (instancetype)loadFromNib;

+ (CGFloat)viewHeight;

@end
