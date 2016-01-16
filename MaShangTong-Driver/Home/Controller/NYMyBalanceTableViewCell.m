//
//  NYMyBalanceTableViewCell.m
//  MaShangTong-Driver
//
//  Created by apple on 15/12/16.
//  Copyright © 2015年 jeaner. All rights reserved.
//

#import "NYMyBalanceTableViewCell.h"
#import "NYMyBalanceModel.h"

@interface NYMyBalanceTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *balanceValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLAbel;
@property (nonatomic,strong) NSDateFormatter *dateFormatter;

@end

@implementation NYMyBalanceTableViewCell

- (NSDateFormatter *)dateFormatter
{
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyy-MM-dd HH:MM:ss";
    }
    return _dateFormatter;
}

- (void)configModel:(NYMyBalanceModel *)model
{
    _balanceValueLabel.text = model.money;
    _priceDetailLabel.text = model.log_info;
    _sourceLabel.text = model.pay_mobile;
    _dateLAbel.text = [self.dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:model.log_time.integerValue]];
}

@end
