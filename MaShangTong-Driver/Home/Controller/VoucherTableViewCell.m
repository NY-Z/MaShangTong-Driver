//
//  VoucherTableViewCell.m
//  MaShangTong-Driver
//
//  Created by apple on 15/12/16.
//  Copyright © 2015年 jeaner. All rights reserved.
//

#import "VoucherTableViewCell.h"
#import "NYMyVoucherModel.h"

@interface VoucherTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *voucherValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *sourceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation VoucherTableViewCell

- (void)configModel:(NYMyVoucherModel *)model
{
    _voucherValueLabel.text = model.price;
    _sourceNameLabel.text = model.name;
    _dateLabel.text = model.time;
}

@end
