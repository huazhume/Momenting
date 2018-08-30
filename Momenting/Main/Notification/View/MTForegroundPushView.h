//
//  MTForegroundPushView.h
//  finbtc
//
//  Created by xiaobai zhang on 2018/7/31.
//  Copyright © 2018年 MTY. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EBCustomBannerView;

typedef void(^Callback)(void);

@interface MTForegroundPushView : UIView

@property (nonatomic, weak) EBCustomBannerView *customView;

@property (nonatomic, copy) Callback callback;

+ (CGFloat)heightForViewWithContent:(NSString *)content;


@end
