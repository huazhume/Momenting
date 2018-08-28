//
//  MTActionToastView.h
//  Momenting
//
//  Created by xiaobai zhang on 2018/8/15.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTActionToastView : UIView

@property (copy, nonatomic) NSString *content;

+ (instancetype)loadFromNib;

- (void)show;

@end
