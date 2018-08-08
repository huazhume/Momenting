//
//  MTNoteModel.h
//  Momenting
//
//  Created by xiaobai zhang on 2018/8/8.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MTNoteModel : NSObject

@end

@interface MTNoteTextModel : NSObject

@property (strong, nonatomic) UIFont *font;
@property (copy, nonatomic) NSString *text;

@end

@interface MTNoteImageModel : NSObject

@property (strong, nonatomic) UIImage *image;
@property (assign, nonatomic) CGFloat width;
@property (assign, nonatomic) CGFloat height;
@property (copy, nonatomic) NSString *path;

@end
