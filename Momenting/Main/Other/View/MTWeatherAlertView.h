//
//  MTWeatherAlertView.h
//  Momenting
//
//  Created by xiaobai zhang on 2018/10/26.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MTWeatherAlertViewDelegate <NSObject>

- (void)weatherAlertViewSelectedWithTitle:(NSString *)title;

@end

@interface MTWeatherAlertView : UIView

@property (nonatomic, copy) NSString *selectTitle;

@property (weak, nonatomic) id <MTWeatherAlertViewDelegate> delegate;

+ (instancetype)loadFromNib;

- (void)show;



@end
