//
//  ValuationRuleModel.h
//  MaShangTong-Driver
//
//  Created by NY on 15/11/25.
//  Copyright © 2015年 jeaner. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ValuationRuleModel : JSONModel <NSCoding>

@property (nonatomic,strong) NSString <Optional> *car_type_id;
@property (nonatomic,strong) NSString <Optional> *high_low_speed;
@property (nonatomic,strong) NSString <Optional> *long_mileage;
@property (nonatomic,strong) NSString <Optional> *low_speed;
@property (nonatomic,strong) NSString <Optional> *mileage;
@property (nonatomic,strong) NSString <Optional> *night;
@property (nonatomic,strong) NSString <Optional> *rule_type;
@property (nonatomic,strong) NSString <Optional> *step;

@end
