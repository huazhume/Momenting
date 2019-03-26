//
//  MTNoteDetailViewController.h
//  Momenting
//
//  Created by xiaobai zhang on 2018/8/14.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTNoteDetailViewController : UIViewController

@property (copy, nonatomic) NSString *noteId;

@property (strong, nonatomic) UIColor *color;

@property (assign, nonatomic) BOOL isStatusBarHidden;

@property (copy, nonatomic) NSString *weather;

@end
