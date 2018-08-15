//
//  UIView+Category.h
//  finbtc
//
//  Created by XT Xiong on 2018/3/19.
//  Copyright © 2018年 MTY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, UIBorderSideType) {
    UIBorderSideTypeAll  = 0,
    UIBorderSideTypeTop = 1 << 0,
    UIBorderSideTypeBottom = 1 << 1,
    UIBorderSideTypeLeft = 1 << 2,
    UIBorderSideTypeRight = 1 << 3,
};

@interface UIView (Category)

//渐变色
- (void)gradientColorWithColorArray:(NSArray *)colorArray LocationArray:(NSArray *)locationArray StartPoint:(CGPoint)startPoint EndPoint:(CGPoint)endPoint;

//切圆角
- (void)cornerRadiusWithCorner:(UIRectCorner)corner CornerRadii:(CGSize)cornerRadii;


- (void)renderViewToImageCompletion:(void (^)(UIImage *image))completion;

/**  自定义UIView边框线 */
- (UIView *)borderForColor:(UIColor *)color borderWidth:(CGFloat)borderWidth borderType:(UIBorderSideType)borderType;


@end
