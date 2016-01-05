//
//  SettingTableViewCell.m
//  MaShangTong
//
//  Created by niliu1h  on 15/10/22.
//  Copyright (c) 2015年 NY. All rights reserved.
//

#import "SettingTableViewCell.h"
#import "Masonry.h"
#import "KLSwitch.h"

@implementation SettingTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _leftTitleLabel = [[UILabel alloc] init];
        _leftTitleLabel.textColor = RGBColor(159, 159, 159, 1.f);
        _leftTitleLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_leftTitleLabel];
        [_leftTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(26);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(130, 30));
        }];
        
        _rightSwitch = [[KLSwitch alloc] initWithFrame:CGRectMake(0, 6, 50, 20)];
        [_rightSwitch setOn:YES];
        [self.contentView addSubview:_rightSwitch];
        [_rightSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-10);
            make.size.mas_equalTo(CGSizeMake(51, 31));
            make.top.equalTo(self.contentView).offset(6);
        }];
        _rightSwitch.onTintColor = RGBColor(98, 190, 254, 1.f);
        _rightSwitch.hidden = YES;
    }
    return self;
}

@end
