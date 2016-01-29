 //
//  NYCalculateSpecialCarPrice.m
//  MaShangTong-Personal
//
//  Created by NY on 16/1/13.
//  Copyright © 2016年 jeaner. All rights reserved.
//

#import "NYCalculateSpecialCarPrice.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import "PassengerModel.h"

@interface NYCalculateSpecialCarPrice ()


@property (nonatomic,strong) NSDateFormatter *formatter;



@end

static    BOOL addGonePrice = NO;
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

- (NSDictionary *)calculatePriceWithParams:(NSDictionary *)params
{
    float speed = [[NSString stringWithFormat:@"%@",params[@"distance"]] floatValue];
    _distance += speed;
    _price += speed*_model.mileage.floatValue/1000;
    
    if (params[@"gonePrice"] && !addGonePrice) {
        _price += [params[@"gonePrice"] floatValue];
        addGonePrice = !addGonePrice;
    }
    
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
             @"mileage_price":[NSString stringWithFormat:@"%f",_price-_model.step.floatValue-_lowSpeedPrice],
             @"low_time":[NSString stringWithFormat:@"%li",_lowSpeedTime],
             @"low_price":[NSString stringWithFormat:@"%f",_lowSpeedPrice],
             @"far_mileage":[NSString stringWithFormat:@"%f",_longDistance],
             @"far_price":[NSString stringWithFormat:@"%f",_longPrice],
             @"night_price":[NSString stringWithFormat:@"%f",_nightPrice],
             @"carbon_emission":[NSString stringWithFormat:@"%f",_distance*0.00013]};
}
-(NSDictionary *)calculatePriceByLocationWithParams:(NSDictionary *)params
{
    //根据传过来的坐标信息，获取到是实际的距离。
    MAMapPoint lastPoint = MAMapPointForCoordinate(CLLocationCoordinate2DMake([params[@"last_latitude"] doubleValue], [params[@"last_longitude"] doubleValue]));
    MAMapPoint nowPoint = MAMapPointForCoordinate(CLLocationCoordinate2DMake([params[@"now_latitude"] doubleValue], [params[@"now_longitude"] doubleValue]));
    
    CLLocationDistance distance = MAMetersBetweenMapPoints(lastPoint, nowPoint);
    
    double speed = distance;
    
    _distance = _distance + distance;
    
    _price += distance*_model.mileage.floatValue/1000;
    
    if (params[@"gonePrice"] && !addGonePrice) {
        NSString *str = [NSString stringWithFormat:@"%@",params[@"gonePrice"]];
        CGFloat num = [str floatValue];;
        _price += num;
        addGonePrice = !addGonePrice;
    }
    
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
    NSLog(@"距离：%f,低速时间：%ld,价格:%f",_distance,_lowSpeedTime,_price);
    
    return @{@"total_price":[NSString stringWithFormat:@"%f",_price],
             @"mileage":[NSString stringWithFormat:@"%f",_distance/1000],
             @"mileage_price":[NSString stringWithFormat:@"%f",_distance * [_model.mileage floatValue]],
             @"low_time":[NSString stringWithFormat:@"%li",_lowSpeedTime],
             @"low_price":[NSString stringWithFormat:@"%f",_lowSpeedPrice],
             @"far_mileage":[NSString stringWithFormat:@"%f",_longDistance],
             @"far_price":[NSString stringWithFormat:@"%f",_longPrice],
             @"night_price":[NSString stringWithFormat:@"%f",_nightPrice],
             @"carbon_emission":[NSString stringWithFormat:@"%f",_distance*0.00013]};
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
