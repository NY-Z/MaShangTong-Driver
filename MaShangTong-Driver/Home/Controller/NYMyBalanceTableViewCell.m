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

@end

@implementation NYMyBalanceTableViewCell

- (void)configModel:(NYMyBalanceModel *)model
{
    _balanceValueLabel.text = model.money;
    _priceDetailLabel.text = model.log_info;
    _sourceLabel.text = model.action_type;
    _dateLAbel.text = model.log_time;
}

@end
