//
//  NYMyBalanceModel.h
//  MaShangTong-Driver
//
//  Created by apple on 15/12/16.
//  Copyright © 2015年 jeaner. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface NYMyBalanceModel : JSONModel

@property (nonatomic,strong) NSString <Optional> *action_type;
@property (nonatomic,strong) NSString <Optional> *log_info;
@property (nonatomic,strong) NSString <Optional> *log_time;
@property (nonatomic,strong) NSString <Optional> *money;

@end
/*
 {
 "action_type" = 2;
 "log_info" = "\U5145\U503c\U91d1\U989d\U4e3a1.01";
 "log_time" = 1447761128;
 money = "1.01";
 }
 */