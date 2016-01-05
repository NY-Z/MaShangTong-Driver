//
//  PassengerModel.h
//  MaShangTong-Driver
//
//  Created by NY on 15/11/18.
//  Copyright © 2015年 jeaner. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DataModel;

@interface DataModel : JSONModel

@property (nonatomic,copy) NSString <Optional> *boarding_time;
@property (nonatomic,copy) NSString <Optional> *car_id;
@property (nonatomic,copy) NSString <Optional> *car_type_id;
@property (nonatomic,copy) NSString <Optional> *create_time;
@property (nonatomic,copy) NSString <Optional> *driver_id;
@property (nonatomic,copy) NSString <Optional> *duration_times;
@property (nonatomic,copy) NSString <Optional> *end_name;
@property (nonatomic,copy) NSString <Optional> *end_coordinates;
@property (nonatomic,copy) NSString <Optional> *end_time;
@property (nonatomic,copy) NSString <Optional> *flight_number;
@property (nonatomic,copy) NSString <Optional> *leave_message;
@property (nonatomic,copy) NSString <Optional> *mobile_phone;
@property (nonatomic,copy) NSString <Optional> *orders_time;
@property (nonatomic,copy) NSString <Optional> *origin_coordinates;
@property (nonatomic,copy) NSString <Optional> *origin_name;
@property (nonatomic,copy) NSString <Optional> *pay_time;
@property (nonatomic,copy) NSString <Optional> *reserva_type;
@property (nonatomic,copy) NSString <Optional> *reservation_time;
@property (nonatomic,copy) NSString <Optional> *reservation_type;
@property (nonatomic,copy) NSString <Optional> *route_status;
@property (nonatomic,copy) NSString <Optional> *route_id;
@property (nonatomic,copy) NSString <Optional> *user_id;

@end

@interface PassengerModel : JSONModel

@property (nonatomic,copy) NSArray <Optional,DataModel> *data;
@property (nonatomic,copy) NSString <Optional> *info;
@property (nonatomic,copy) NSString <Optional> *status;

@end
