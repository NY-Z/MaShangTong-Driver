//
//  DriverInfoModel.h
//  MaShangTong-Driver
//
//  Created by apple on 15/12/13.
//  Copyright © 2015年 jeaner. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface DriverInfoModel : JSONModel <NSCoding>

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
@property (nonatomic,strong) NSString <Optional> *point;

@end
