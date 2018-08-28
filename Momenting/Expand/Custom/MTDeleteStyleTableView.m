//
//  MTDeleteStyleTableView.m
//  Momenting
//
//  Created by xiaobai zhang on 2018/8/13.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import "MTDeleteStyleTableView.h"


@interface MTDeleteStyleTableView ()

@property (strong, nonatomic) UIButton *rightButton;

@property (strong, nonatomic) UIButton *leftButton;

@end

@implementation MTDeleteStyleTableView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.editingIndexPath) {
        [self configSwipeButtons];
    }
}

- (void)configSwipeButtons
{
    // 获取选项按钮的reference
    if (@available(iOS 11.0, *))
    {
        // iOS 11层级 (Xcode 9编译): UITableView -> UISwipeActionPullView
        for (UIView *subview in self.subviews)
        {
            if ([subview isKindOfClass:NSClassFromString(@"UISwipeActionPullView")] && [subview.subviews count] >= 1)
            {
                UIButton *readButton = subview.subviews[0];
                self.rightButton.frame = CGRectMake(20, 0, readButton.bounds.size.width - 60, readButton.bounds.size.height);
                [readButton addSubview:self.rightButton];
                readButton.backgroundColor = [UIColor clearColor];
                subview.backgroundColor = [UIColor clearColor];
                
                UIView *readViews = readButton.subviews[0];
                readViews.backgroundColor = [UIColor clearColor];
                
            }
        }
    }
    else
    {
        // iOS 8-10层级: UITableView -> UITableViewCell -> UITableViewCellDeleteConfirmationView
        UITableViewCell*tableCell = [self cellForRowAtIndexPath:self.editingIndexPath];
        for (UIView *subview in tableCell.subviews)
        {
            if ([subview isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")] && [subview.subviews count] >= 1)
            {
                UIButton *deleteButton = subview.subviews[0];
                self.leftButton.frame = CGRectMake(10, 0, deleteButton.bounds.size.width - 40, deleteButton.bounds.size.height);
                [deleteButton addSubview:self.leftButton];
//                UIButton *readButton = subview.subviews[1];
//                self.rightButton.frame = CGRectMake(20, 0, readButton.bounds.size.width - 40, readButton.bounds.size.height);
//                [readButton addSubview:self.rightButton];
            }
        }
    }

}

#pragma mark - getter
- (UIButton *)rightButton
{
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setImage:[UIImage imageNamed:@"trash"] forState:UIControlStateNormal];
        _rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _rightButton.userInteractionEnabled = NO;
//        _rightButton.backgroundColor = [UIColor colorWithHex:0xC496C5];
        _rightButton.backgroundColor = [UIColor clearColor];
    }
    return _rightButton;
}

- (UIButton *)leftButton
{
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_leftButton setImage:[UIImage imageNamed:@"radioMoreButtonSelected"] forState:UIControlStateNormal];
        _leftButton.userInteractionEnabled = NO;
        _leftButton.backgroundColor = [UIColor clearColor];
//        _leftButton.backgroundColor = [UIColor colorWithHex:0xC496C5];
    }
    return _leftButton;
}


@end
