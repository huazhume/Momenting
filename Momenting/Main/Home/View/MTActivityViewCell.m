//
//  MTActivityViewCell.m
//  Momenting
//
//  Created by xiaobai zhang on 2019/4/13.
//  Copyright © 2019年 xiaobai zhang. All rights reserved.
//

#import "MTActivityViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MTNoteDetailViewController.h"
#import "MTNoteModel.h"

@interface MTActivityViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;

@end

@implementation MTActivityViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
    
    self.imageView1.layer.masksToBounds = YES;
    self.imageView2.layer.masksToBounds = YES;
}

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    
    if (dataArray.count == 0) {
        return;
    }
    NSDictionary *dic1 = dataArray[0];
    [self.imageView1 sd_setImageWithURL:[NSURL URLWithString:dic1[@"image"]]];
    self.label1.text = dic1[@"title"];
    
    if (dataArray.count <= 1) {
        return;
    }
    NSDictionary *dic2 = dataArray[1];
    [self.imageView2 sd_setImageWithURL:[NSURL URLWithString:dic2[@"image"]]];
    self.label2.text = dic2[@"title"];
//    self
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)button1Clicked:(id)sender {
    
    
    
    if (self.dataArray.count == 0) {
        return;
    }
    NSDictionary *dic1 = self.dataArray[0];
    
    MTNoteDetailViewController *detailVC = [[MTNoteDetailViewController alloc] init];
    detailVC.noteId = dic1[@"id"];
    detailVC.isJubaoHidden = YES;
    detailVC.isStatusBarHidden = [UIApplication sharedApplication].isStatusBarHidden;
    [[MTHelp currentNavigation] pushViewController:detailVC animated:YES];
    
}

- (IBAction)button2Clicked:(id)sender {
    
    
    if (self.dataArray.count <= 1) {
        return;
    }
    NSDictionary *dic2 = self.dataArray[1];
    MTNoteDetailViewController *detailVC = [[MTNoteDetailViewController alloc] init];
    detailVC.noteId = dic2[@"id"];
    detailVC.isJubaoHidden = YES;
    detailVC.isStatusBarHidden = [UIApplication sharedApplication].isStatusBarHidden;
    [[MTHelp currentNavigation] pushViewController:detailVC animated:YES];
    
}

@end
