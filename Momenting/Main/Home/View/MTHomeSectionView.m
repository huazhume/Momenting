//
//  MTHomeSectionView.m
//  Momenting
//
//  Created by xiaobai zhang on 2018/8/7.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import "MTHomeSectionView.h"


@interface MTHomeSectionView ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *myNoteButton;
@property (weak, nonatomic) IBOutlet UIButton *activityButton;
@property (weak, nonatomic) IBOutlet UIView *indicatorView;
@property (weak, nonatomic) IBOutlet UIButton *noteButton;
@property (weak, nonatomic) IBOutlet UIButton *readButton;

@end

@implementation MTHomeSectionView

+ (instancetype)loadFromNib
{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"MTHomeSectionView" owner:nil options:nil];
    if (views && views.count > 0) {
        return [views firstObject];
    }
    return nil;
}

+ (CGFloat)viewHeight
{
    return 40.f;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self.noteButton setTitle:Localized(@"home_note") forState:UIControlStateNormal];
    [self.readButton setTitle:Localized(@"home_recommend") forState:UIControlStateNormal];
}

- (void)setName:(NSString *)name
{
    _name = name;
    self.nameLabel.text = name;

}

- (void)reloadData
{
    [self.noteButton setTitle:Localized(@"home_note") forState:UIControlStateNormal];
    [self.readButton setTitle:Localized(@"home_recommend") forState:UIControlStateNormal];
}

#pragma mark - events
- (IBAction)noteButtonClicked:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(homeNoteAction)]) {
        [self.delegate homeNoteAction];
    }
}

- (IBAction)noteSettingButtonClicked:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(homeSettingAction)]) {
        [self.delegate homeSettingAction];
    }
}

- (IBAction)homeButtonClicked:(UIButton *)sender {
    
    [UIView animateWithDuration:0.29 animations:^{
       self.indicatorView.center = CGPointMake(sender.center.x, self.indicatorView.center.y);
    }];
    
    NSInteger index = 0;
    if (![sender isEqual:self.myNoteButton]) {
        index = 1;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(homeButtonClickedWithIndex:)]) {
         [self.delegate homeButtonClickedWithIndex:index];
    }
   
}


@end
