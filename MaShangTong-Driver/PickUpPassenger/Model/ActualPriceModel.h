//
//  ActualPriceModel.h
//  MaShangTong-Driver
//
//  Created by apple on 15/12/17.
//  Copyright © 2015年 jeaner. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ActualPriceModel : JSONModel

@property (nonatomic,strong) NSString <Optional> *far_mileage;
@property (nonatomic,strong) NSString <Optional> *far_price;
@property (nonatomic,strong) NSString <Optional> *low_price;
@property (nonatomic,strong) NSString <Optional> *low_time;
@property (nonatomic,strong) NSString <Optional> *mileage;
@property (nonatomic,strong) NSString <Optional> *mileage_price;
@property (nonatomic,strong) NSString <Optional> *night_mileage;
@property (nonatomic,strong) NSString <Optional> *night_price;
@property (nonatomic,strong) NSString <Optional> *start_price;
@property (nonatomic,strong) NSString <Optional> *total_price;

@end
/*
 {
 data = 1;
 info =     {
 "far_mileage" = 0;
 "far_price" = 0;
 "low_price" = "0.02";
 "low_time" = "0.0333333333334";
 mileage = "0.006";
 "mileage_price" = "0.012";
 "night_mileage" = "<null>";
 "night_price" = 0;
 "start_price" = 18;
 "total_price" = "18.032";
 };
 }
 */