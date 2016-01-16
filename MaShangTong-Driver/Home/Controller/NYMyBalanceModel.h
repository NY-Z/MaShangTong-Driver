//
//  NYMyBalanceModel.h
//  MaShangTong-Driver
//
//  Created by apple on 15/12/16.
//  Copyright © 2015年 jeaner. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface NYMyBalanceModel : JSONModel

@property (nonatomic,strong) NSString <Optional> *log_info; // 来源
@property (nonatomic,strong) NSString <Optional> *log_time; // 时间
@property (nonatomic,strong) NSString <Optional> *money; // 价格 （未去券值）
@property (nonatomic,strong) NSString <Optional> *last_money; // 最终付钱(除去券值)
@property (nonatomic,strong) NSString <Optional> *pay_mobile; // 手机号
@property (nonatomic,strong) NSString <Optional> *ticket_id; // 券的id

@end
/*
 {
 "action_type" = 2;
 "log_info" = "\U5145\U503c\U91d1\U989d\U4e3a1.01";
 "log_time" = 1447761128;
 money = "1.01";
 }
 */