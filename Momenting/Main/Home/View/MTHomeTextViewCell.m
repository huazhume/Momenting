//
//  MTHomeTextViewCell.m
//  Momenting
//
//  Created by xiaobai zhang on 2018/8/7.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import "MTHomeTextViewCell.h"
#import "MTNoteModel.h"
#import "MTMediaFileManager.h"
#import "MTDateFormatManager.h"
#import "UIImage+ImageCompress.h"

@interface MTHomeTextViewCell ()

@property (strong, nonatomic) UIVisualEffectView *effectView;
@property (weak, nonatomic) IBOutlet UIView *conntentSecView;
@property (weak, nonatomic) IBOutlet UIView *contentBgView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeightConstraint;

@property (strong, nonatomic) NSArray *colors;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *weatherLabel;



@end

@implementation MTHomeTextViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initBaseViews];
    
    self.colors = @[[UIColor colorWithHex:0x96B46C],[UIColor colorWithHex:0xE48370],[UIColor colorWithHex:0xC496C5],[UIColor colorWithHex:0x79B47C],[UIColor colorWithHex:0xA299CE],[UIColor colorWithHex:0xA2AEBB] ];
    // Initialization code
}

+ (CGFloat)heightForCellWithModel:(MTNoteModel *)model
{
    CGFloat textHeight = 0.f;
    if (model.text.length > 0) {
        CGSize textLabelSize = [model.text boundingRectWithSize:CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds) - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Light" size:12]} context:nil].size;
        textHeight = textLabelSize.height + 10.f;
    }
    
    if (textHeight > ([UIFont fontWithName:@"PingFangSC-Light" size:12].lineHeight * 4 + 10)) {
        textHeight = ([UIFont fontWithName:@"PingFangSC-Light" size:12].lineHeight * 4 + 10);
    }
    
    CGFloat imageHeight = 0.f;
    if (model.imagePath.length > 0) {
        imageHeight = 140.f;
    }
    
    return 30.f + 8.f + imageHeight + textHeight;
}

- (void)initBaseViews
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentImageView.layer.masksToBounds = YES;
    self.conntentSecView.layer.cornerRadius = 10.f;
    self.conntentSecView.layer.masksToBounds = YES;
    
    self.contentBgView.layer.cornerRadius = 10.f;
    self.contentBgView.layer.masksToBounds = YES;
    
    [self.conntentSecView addSubview:self.effectView];
    [self.effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.conntentSecView);
    }];
    
    self.contentBgView.layer.borderColor = [[UIColor colorWithHex:0xB4BAC3] CGColor];
    self.contentBgView.layer.borderWidth = 0.5;
    self.editingAccessoryView.tintColor = [UIColor purpleColor];
    self.editingAccessoryView.backgroundColor = [UIColor purpleColor];
    self.weatherLabel.titleLabel.font = [UIFont mtWeatherFontWithFontSize:20];
}

#pragma mark - setter
- (void)setModel:(MTNoteModel *)model
{
    _model = model;
    self.contentLabel.text = model.text;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [[MTMediaFileManager sharedManager] getMediaFilePathWithAndSanBoxType:SANBOX_DOCUMNET_TYPE AndMediaType:FILE_IMAGEBATE_TYPE];
    NSString *beta_path = [NSString stringWithFormat:@"%@/%@",path,model.imagePath];
    if (![fileManager fileExistsAtPath:beta_path]) {
        NSString *originPath = [[MTMediaFileManager sharedManager] getMediaFilePathWithAndSanBoxType:SANBOX_DOCUMNET_TYPE AndMediaType:FILE_IMAGE_TYPE];
        NSString *imagePath = [NSString stringWithFormat:@"%@/%@",originPath,model.imagePath];
        UIImage *image = [UIImage compressImage:[[UIImage alloc] initWithContentsOfFile:imagePath] compressRatio:0.05];
        NSData *beta_data = nil;
        if (UIImagePNGRepresentation(image) == nil) {
            beta_data = UIImageJPEGRepresentation(image, 1.0);
        } else {
            beta_data = UIImagePNGRepresentation(image);
        }
        [fileManager createFileAtPath:beta_path contents:beta_data attributes:nil];
    }
    self.contentImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:beta_path]];
    self.imageViewHeightConstraint.constant = model.imagePath.length > 0 ? 140.f : 0.f;
    
    NSInteger index = model.indexRow % self.colors.count;
    self.topView.backgroundColor = self.colors[index];
    model.sectionColor = self.topView.backgroundColor;
    self.contentBgView.layer.borderColor = [self.topView.backgroundColor CGColor];
    NSString *time = [MTDateFormatManager formatToHumanReadableInfoWithTimeIntervalSince1970:model.noteId.longLongValue];
    [self.timeLabel setTitle:time forState:UIControlStateNormal];
    model.weather = model.weather.length ? model.weather : @"A";
    [self.weatherLabel setTitle:[NSString stringWithFormat:@" %@",model.weather] forState:UIControlStateNormal];
    [self.weatherLabel setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
}

#pragma mark - getter
- (UIVisualEffectView *)effectView
{
    if (!_effectView) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        _effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        _effectView.alpha = 0.8;
    }
    return _effectView;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
