//
//  ValuationRuleModel.m
//  MaShangTong-Driver
//
//  Created by NY on 15/11/25.
//  Copyright © 2015年 jeaner. All rights reserved.
//

#import "ValuationRuleModel.h"

@implementation ValuationRuleModel
/*
 @property (nonatomic,strong) NSString <Optional> *car_type_id;
 @property (nonatomic,strong) NSString <Optional> *long_mileage;
 @property (nonatomic,strong) NSString <Optional> *low_speed;
 @property (nonatomic,strong) NSString <Optional> *mileage;
 @property (nonatomic,strong) NSString <Optional> *night;
 @property (nonatomic,strong) NSString <Optional> *rule_type;
 @property (nonatomic,strong) NSString <Optional> *step;
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        /*self.name = [aDecoder decodeObjectForKey:@"name"];*/
        /*Student * stu1 = [NSKeyedUnarchiver unarchiveObjectWithData:stuD];//读取归档数据,调用initWithCoder*/
        self.car_type_id = [aDecoder decodeObjectForKey:@"car_type_id"];
        self.long_mileage = [aDecoder decodeObjectForKey:@"long_mileage"];
        self.low_speed = [aDecoder decodeObjectForKey:@"low_speed"];
        self.mileage = [aDecoder decodeObjectForKey:@"mileage"];
        self.night = [aDecoder decodeObjectForKey:@"night"];
        self.rule_type = [aDecoder decodeObjectForKey:@"rule_type"];
        self.step = [aDecoder decodeObjectForKey:@"step"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    /* [aCoder encodeObject:self.name forKey:@"name"];*/
    /*NSData * stuD = [NSKeyedArchiver archivedDataWithRootObject:stu];//归档,调用encodeWithCoder方法*/
    [aCoder encodeObject:self.car_type_id forKey:@"car_type_id"];
    [aCoder encodeObject:self.long_mileage forKey:@"long_mileage"];
    [aCoder encodeObject:self.low_speed forKey:@"low_speed"];
    [aCoder encodeObject:self.mileage forKey:@"mileage"];
    [aCoder encodeObject:self.night forKey:@"night"];
    [aCoder encodeObject:self.rule_type forKey:@"rule_type"];
    [aCoder encodeObject:self.step forKey:@"step"];
}

@end
