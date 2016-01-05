//
//  SettingTableViewCell.h
//  MaShangTong
//
//  Created by niliu1h  on 15/10/22.
//  Copyright (c) 2015年 NY. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KLSwitch;
@interface SettingTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *leftTitleLabel;
@property (nonatomic,strong) KLSwitch *rightSwitch;

@end
