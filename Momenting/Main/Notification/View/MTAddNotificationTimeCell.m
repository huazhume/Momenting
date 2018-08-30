//
//  MTAddNotificationTimeCell.m
//  Momenting
//
//  Created by xiaobai zhang on 2018/8/27.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import "MTAddNotificationTimeCell.h"

@interface MTAddNotificationTimeCell ()
<UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (strong, nonatomic) NSMutableArray *hours;

@property (strong, nonatomic) NSMutableArray *minutes;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation MTAddNotificationTimeCell

+ (CGFloat)heightForCell
{
    return 160.f;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initBaseViews];
    // Initialization code
}

#pragma mark - initBaseViews
- (void)initBaseViews
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.pickerView.tintColor = [UIColor colorWithHex:0xEFF5FF];
    
    for (int i = 0; i < 24; i ++) {
        [self.hours addObject:[NSNumber numberWithInteger:i]];
    }
    
    for (int i = 0; i < 60; i ++) {
        [self.minutes addObject:[NSNumber numberWithInteger:i]];
    }
    [self.pickerView reloadAllComponents];
    
    
    NSString *time = [[NSDateFormatter my_getHHmmFormatter] stringFromDate:[NSDate date]];
    NSArray *times = [time componentsSeparatedByString:@":"];
    if (times.count < 2) {
        return;
    }
    NSInteger hour = ((NSString *)times[0]).integerValue;
    NSInteger minute = ((NSString *)times[1]).integerValue;
    [self.pickerView selectRow:hour inComponent:0 animated:NO];
    [self.pickerView selectRow:minute inComponent:1 animated:NO];
    
    self.titleLabel.text = Localized(@"addNotificationTime");
}

#pragma mark - pickerView delegate & dataSource
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return SCREEN_WIDTH / 2.0;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.hours.count;
    } else {
        return self.minutes.count;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40.f;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    //设置分割线的颜色
    for (UIView *singleLine in pickerView.subviews) {
        if (singleLine.frame.size.height < 1) {
            singleLine.backgroundColor = [UIColor clearColor];
        }
    }
    NSArray *colors = @[[UIColor colorWithHex:0x96B46C],[UIColor colorWithHex:0xE48370],[UIColor colorWithHex:0xC496C5],[UIColor colorWithHex:0x79B47C],[UIColor colorWithHex:0xA299CE],[UIColor colorWithHex:0xA2AEBB] ];
    UILabel *genderLabel = [UILabel new];
    genderLabel.textAlignment = NSTextAlignmentCenter;
    NSNumber *number = nil;
    if (component == 0) {
        number = self.hours[row];
    } else {
        number = self.minutes[row];
    }
    genderLabel.text = [NSString stringWithFormat:@"%02d",number.intValue];
    genderLabel.font = [UIFont systemFontOfSize:15];
    genderLabel.textColor = [UIColor colorWithHex:0x333333];
    return genderLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    NSString *time = nil;
    if (row == 0) {
        time =  [NSString stringWithFormat:@"%02ld",((NSString *)self.hours[row]).integerValue];
    } else {
        time =  [NSString stringWithFormat:@"%02ld",((NSString *)self.minutes[row]).integerValue];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(notificationTime: withIsHour:)]) {
        [self.delegate notificationTime:time withIsHour:component == 0];
    }
}


#pragma mark - getter
- (NSMutableArray *)hours
{
    if (!_hours) {
        _hours = [NSMutableArray array];
    }
    return _hours;
}

- (NSMutableArray *)minutes
{
    if (!_minutes) {
        _minutes = [NSMutableArray array];
    }
    return _minutes;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
