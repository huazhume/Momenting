//
//  MTHomeSectionView.h
//  Momenting
//
//  Created by xiaobai zhang on 2018/8/7.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MTHomeSectionViewDelegate <NSObject>

- (void)homeNoteAction;

- (void)homeSettingAction;

- (void)homeButtonClickedWithIndex:(NSInteger)index;

@end

@interface MTHomeSectionView : UIView

@property (weak, nonatomic) id <MTHomeSectionViewDelegate> delegate;

@property (copy, nonatomic) NSString *name;

+ (instancetype)loadFromNib;

+ (CGFloat)viewHeight;

- (void)reloadData;

@end
