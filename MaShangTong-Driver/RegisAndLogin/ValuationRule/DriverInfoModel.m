//
//  DriverInfoModel.m
//  MaShangTong-Driver
//
//  Created by apple on 15/12/13.
//  Copyright © 2015年 jeaner. All rights reserved.
//

#import "DriverInfoModel.h"

@implementation DriverInfoModel
/*
 @property (nonatomic,strong) NSString <Optional> *car_status;
 @property (nonatomic,strong) NSString <Optional> *mobile;
 @property (nonatomic,strong) NSString <Optional> *money;
 @property (nonatomic,strong) NSString <Optional> *user_id;
 @property (nonatomic,strong) NSString <Optional> *user_name;
 @property (nonatomic,strong) NSString <Optional> *license_plate;
 @property (nonatomic,strong) NSString <Optional> *snum;
 @property (nonatomic,strong) NSString <Optional> *byear;
 @property (nonatomic,strong) NSString <Optional> *city;
 @property (nonatomic,strong) NSString <Optional> *group_id;
 @property (nonatomic,strong) NSString <Optional> *head_image;
 @property (nonatomic,strong) NSString <Optional> *sex;
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.car_status = [aDecoder decodeObjectForKey:@"car_status"];
        self.mobile = [aDecoder decodeObjectForKey:@"mobile"];
        self.money = [aDecoder decodeObjectForKey:@"money"];
        self.user_id = [aDecoder decodeObjectForKey:@"user_id"];
        self.user_name = [aDecoder decodeObjectForKey:@"user_name"];
        self.license_plate = [aDecoder decodeObjectForKey:@"license_plate"];
        self.snum = [aDecoder decodeObjectForKey:@"snum"];
        self.byear = [aDecoder decodeObjectForKey:@"byear"];
        self.city = [aDecoder decodeObjectForKey:@"city"];
        self.group_id = [aDecoder decodeObjectForKey:@"group_id"];
        self.head_image = [aDecoder decodeObjectForKey:@"head_image"];
        self.sex = [aDecoder decodeObjectForKey:@"sex"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.car_status forKey:@"car_status"];
    [aCoder encodeObject:self.mobile forKey:@"mobile"];
    [aCoder encodeObject:self.money forKey:@"money"];
    [aCoder encodeObject:self.user_id forKey:@"user_id"];
    [aCoder encodeObject:self.user_name forKey:@"user_name"];
    [aCoder encodeObject:self.license_plate forKey:@"license_plate"];
    [aCoder encodeObject:self.snum forKey:@"snum"];
    [aCoder encodeObject:self.byear forKey:@"byear"];
    [aCoder encodeObject:self.city forKey:@"city"];
    [aCoder encodeObject:self.group_id forKey:@"group_id"];
    [aCoder encodeObject:self.head_image forKey:@"head_image"];
    [aCoder encodeObject:self.sex forKey:@"sex"];
}

@end
/*
 @property (nonatomic,strong) NSString <Optional> *car_status;
 @property (nonatomic,strong) NSString <Optional> *mobile;
 @property (nonatomic,strong) NSString <Optional> *money;
 @property (nonatomic,strong) NSString <Optional> *user_id;
 @property (nonatomic,strong) NSString <Optional> *user_name;
 */