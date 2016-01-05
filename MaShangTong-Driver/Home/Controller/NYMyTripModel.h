//
//  NYMyTripModel.h
//  MaShangTong-Driver
//
//  Created by apple on 15/12/16.
//  Copyright © 2015年 jeaner. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol NYMyTripDetaileModel;
@interface NYMyTripDetaileModel : JSONModel

@property (nonatomic,strong) NSString <Optional>*car_type_id;
@property (nonatomic,strong) NSString <Optional>*carbon_emission;
@property (nonatomic,strong) NSString <Optional>*end_name;
@property (nonatomic,strong) NSString <Optional>*origin_name;
@property (nonatomic,strong) NSString <Optional>*route_id;
@property (nonatomic,strong) NSString <Optional>*trip_distance;

@end

@interface NYMYTripInfoModel : JSONModel

@property (nonatomic,strong) NSString <Optional>*num1;
@property (nonatomic,strong) NSString <Optional>*distance;
@property (nonatomic,strong) NSMutableArray <Optional,NYMyTripDetaileModel>*detaile;
@property (nonatomic,strong) NSString <Optional>*carbon_emission;

@end

@interface NYMyTripModel : JSONModel

@property (nonatomic,strong) NSString <Optional>*data;
@property (nonatomic,strong) NYMYTripInfoModel <Optional>*info;
@property (nonatomic,strong) NSString <Optional>*status;

@end
