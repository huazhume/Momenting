//
//  MTNoteModel.h
//  Momenting
//
//  Created by xiaobai zhang on 2018/8/8.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    MTNoteFontTypeNormal,
    MTNoteFontTypeItalic,
    MTNoteFontTypeBold,
} MTNoteFontType;


@interface MTNoteModel : NSObject

@property (strong, nonatomic) NSArray *contents;
@property (copy, nonatomic) NSString *noteId;
@property (copy, nonatomic) NSString *imagePath;
@property (copy, nonatomic) NSString *text;
@property (assign, nonatomic) CGFloat width;
@property (assign, nonatomic) CGFloat height;
@property (assign, nonatomic) NSInteger indexRow;
@property (strong, nonatomic) UIColor *sectionColor;
@property (assign, nonatomic) CGFloat fontSize;
@property (strong, nonatomic) NSString *fontName;
@property (strong, nonatomic) NSString *weather;

@end

@interface MTNoteBaseVo : NSObject

@property (copy, nonatomic) NSString *noteId;
@property (assign, nonatomic) NSInteger sortIndex;

@end

@interface MTNoteImageVo : MTNoteBaseVo

@property (strong, nonatomic) UIImage *image;
@property (assign, nonatomic) CGFloat width;
@property (assign, nonatomic) CGFloat height;
@property (copy, nonatomic) NSString *path;

@end

@interface MTNoteTextVo : MTNoteBaseVo

@property (assign, nonatomic) CGFloat fontSize;
@property (strong, nonatomic) NSString *fontName;
@property (copy, nonatomic) NSString *text;
@property (assign, nonatomic) MTNoteFontType fontType;

@end





