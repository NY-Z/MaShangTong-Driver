//
//  PersonInfoCell.h
//  MaShangTong
//
//  Created by niliu1h  on 15/10/17.
//  Copyright (c) 2015年 NY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonInfoCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier indexPath:(NSIndexPath *)indexPath;

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIImageView *headerView;
@property (nonatomic,strong) UILabel *subTitleLabel;

@property (nonatomic,assign) NSInteger row;

@end
