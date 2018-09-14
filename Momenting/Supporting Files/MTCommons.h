//
//  MYCommons.h
//  Meiyu
//
//  Created by QingyunLiao on 15/11/6.
//  Copyright © 2015年 jimeiyibao. All rights reserved.
//

#ifndef MYCommons_h
#define MYCommons_h


#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define Localized(key)  [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"]] ofType:@"lproj"]] localizedStringForKey:(key) value:nil table:@"Language"]



#import "UIColor+Hex.h"
#import "UITableViewCell+Categoty.h"
#import "UITextView+Category.h"
#import <Masonry/Masonry.h>
#import "UIView+Category.h"
#import "MTHelp.h"
#import "NSDateFormatter+Category.h"
#import "MTLanguageManager.h"


#endif /* MYCommons_h */
