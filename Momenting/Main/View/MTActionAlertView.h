//
//  MTActionAlertView.h
//  Momenting
//
//  Created by xiaobai zhang on 2018/8/10.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AlertBlock)(NSInteger index);

@interface MTActionAlertView : UIView

@property (copy, nonatomic) AlertBlock block;

+ (instancetype)loadFromNib;

+ (CGFloat)viewHeight;

- (void)show;

+ (void)alertShowWithMessage:(NSString *)message leftTitle:(NSString *)leftTitle leftColor:(UIColor *)color rightTitle:(NSString *)rightTitle rightColor:(UIColor *)rightColor callBack:(AlertBlock)block;

@end
