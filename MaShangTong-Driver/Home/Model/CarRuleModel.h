//
//  CarRuleModel.h
//  MaShangTong-Driver
//
//  Created by NY on 16/1/14.
//  Copyright © 2016年 NY. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface CarRuleModel : JSONModel

@property (nonatomic,strong) NSString <Optional> *airport_name;
@property (nonatomic,strong) NSString <Optional> *car_type_id;
@property (nonatomic,strong) NSString <Optional> *contain_mileage;
@property (nonatomic,strong) NSString <Optional> *high_low_speed;
@property (nonatomic,strong) NSString <Optional> *id;
@property (nonatomic,strong) NSString <Optional> *long_mileage;
@property (nonatomic,strong) NSString <Optional> *low_speed;
@property (nonatomic,strong) NSString <Optional> *mileage;
@property (nonatomic,strong) NSString <Optional> *night;
@property (nonatomic,strong) NSString <Optional> *once_price;
@property (nonatomic,strong) NSString <Optional> *over_mileage_money;
@property (nonatomic,strong) NSString <Optional> *over_time_money;
@property (nonatomic,strong) NSString <Optional> *rule_type;
@property (nonatomic,strong) NSString <Optional> *step;
@property (nonatomic,strong) NSString <Optional> *times;

@end
