//
//  NYCalculateSpecialCarPrice.m
//  MaShangTong-Personal
//
//  Created by NY on 16/1/13.
//  Copyright © 2016年 jeaner. All rights reserved.
//

#import "NYCalculateSpecialCarPrice.h"

#import "PassengerModel.h"

@interface NYCalculateSpecialCarPrice ()

//@property (nonatomic,assign) float long_mileage;
//@property (nonatomic,assign) float low_speed;
//@property (nonatomic,assign) float mileage;
//@property (nonatomic,assign) float night;
//@property (nonatomic,assign) float step;
//@property (nonatomic,assign) float highLowSpeed;

@property (nonatomic,strong) NSDateFormatter *formatter;

@property (nonatomic,assign) float distance;
@property (nonatomic,assign) float price;
@property (nonatomic,assign) NSInteger lowSpeedTime;
@property (nonatomic,assign) float lowSpeedPrice;
@property (nonatomic,assign) float longDistance;
@property (nonatomic,assign) float longPrice;
@property (nonatomic,assign) float nightPrice;

@end

@implementation NYCalculateSpecialCarPrice

- (NSDateFormatter *)formatter
{
    if (_formatter == nil) {
        _formatter = [[NSDateFormatter alloc] init];
        _formatter.dateFormat = @"HH";
    }
    return _formatter;
}

+ (instancetype)sharedPrice
{
    static NYCalculateSpecialCarPrice *price = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        price = [[NYCalculateSpecialCarPrice alloc] init];
    });
    return price;
}

- (void)setModel:(RuleInfoModel *)model
{
    _model = model;
    
    _price = model.step.floatValue;
}

/*
 total_price：总价
 start_price：起步价
 mileage：总里程
 mileage_price：总里程价
 low_time：低速时间
 low_price：低速价格
 far_mileage：远途里程
 far_price：远途价
 night_price：夜间费
 */

- (NSDictionary *)calculatePriceWithParams:(NSDictionary *)params
{
    float speed = [[NSString stringWithFormat:@"%@",params[@"distance"]] floatValue];
    _distance += speed;
    _price += speed*_model.mileage.floatValue/1000;
    
    if (speed <= 3.333334) {
        _lowSpeedTime++;
        if ([self isRushHour]) {
            _price += _model.high_low_speed.floatValue/60;
            _lowSpeedPrice += _model.high_low_speed.floatValue/60;
        } else {
            _price += _model.low_speed.floatValue/60;
            _lowSpeedPrice += _model.low_speed.floatValue/60;
        }
    } else {
        if (_distance >= 10000) {
            _price += _model.long_mileage.floatValue/1000;
            _longDistance = _distance - 10000;
            _longPrice = _longDistance*_model.long_mileage.floatValue/1000;
        }
        if ([self isNightDrive]) {
            _price += _model.night.floatValue/1000;
            _nightPrice += _model.night.floatValue/1000;
        }
    }
    
    return @{@"total_price":[NSString stringWithFormat:@"%f",_price],
             @"mileage":[NSString stringWithFormat:@"%f",_distance/1000],
             @"mileage_price":[NSString stringWithFormat:@"%f",_price-_model.step.floatValue],
             @"low_time":[NSString stringWithFormat:@"%li",_lowSpeedTime],
             @"low_price":[NSString stringWithFormat:@"%f",_lowSpeedPrice],
             @"far_mileage":[NSString stringWithFormat:@"%f",_longDistance],
             @"far_price":[NSString stringWithFormat:@"%f",_longPrice],
             @"night_price":[NSString stringWithFormat:@"%f",_nightPrice]};
}

// 是否是高峰期
- (BOOL)isRushHour
{
    NSDate *currentDate = [NSDate date];
    NSInteger currentHour = [_formatter stringFromDate:currentDate].integerValue;
    if ( (currentHour >= 7&&currentHour < 10) || (currentHour >= 17&&currentHour < 19) ) {
        return YES;
    }
    return NO;
}

// 是否为夜间行驶
- (BOOL)isNightDrive
{
    NSDate *currentDate = [NSDate date];
    NSInteger currentHour = [_formatter stringFromDate:currentDate].integerValue;
    if (currentHour >= 23 && currentHour< 5) {
        return YES;
    }
    return NO;
}

@end
