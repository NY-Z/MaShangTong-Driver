//
//  PersonInfoCell.m
//  MaShangTong
//
//  Created by niliu1h  on 15/10/17.
//  Copyright (c) 2015年 NY. All rights reserved.
//

#import "PersonInfoCell.h"
#import "Masonry.h"

@implementation PersonInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier indexPath:(NSIndexPath *)indexPath
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configSubviewsWithIndexPath:indexPath];
    }
    return self;
}

- (void)configSubviewsWithIndexPath:(NSIndexPath *)indexPath
{
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:13];
    _titleLabel.textColor = RGBColor(118, 118, 118, 1.f);
    [self.contentView addSubview:_titleLabel];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(30);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    
    _subTitleLabel = [[UILabel alloc] init];
    _subTitleLabel.textColor = RGBColor(193, 193, 193, 1.f);
    _subTitleLabel.font = [UIFont systemFontOfSize:14];
    _subTitleLabel.textAlignment = 2;
    [self.contentView addSubview:_subTitleLabel];
    
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-40);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    
    _headerView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.headerView];
    
    if (indexPath.row == 0) {
        _headerView = [[UIImageView alloc] init];
        _headerView.layer.cornerRadius = 20;
        [self.contentView addSubview:self.headerView];
        
        [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(-40);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
    }
}

- (void)setRow:(NSInteger)row
{
    if (row == 0) {
        _headerView.hidden = YES;
    }
}

@end
