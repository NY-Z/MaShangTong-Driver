//
//  NYCalculateCharteredBusPrice.m
//  MaShangTong-Personal
//
//  Created by NY on 16/1/13.
//  Copyright © 2016年 jeaner. All rights reserved.
//

#import "NYCalculateCharteredBusPrice.h"
#import "PassengerModel.h"

@interface NYCalculateCharteredBusPrice ()
{
    float _distance;
    NSInteger _totalTime;
    float _totalPrice;
    NSInteger _distanceOver;
    NSInteger _timeOver;
    NSInteger _distanceFlag;
    NSInteger _timeFlag;
}

@property (nonatomic,assign) float containMileage;
@end

@implementation NYCalculateCharteredBusPrice

+ (instancetype)shareCharteredBusPrice
{
    static NYCalculateCharteredBusPrice *price = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        price = [[NYCalculateCharteredBusPrice alloc] init];
    });
    return price;
}

- (void)setRule:(RuleInfoModel *)rule
{
    _rule = rule;
    _totalPrice = rule.once_price.floatValue;
    _totalTime = 0;
    _distance = 0;
    _containMileage = _rule.contain_mileage.floatValue*1000;
    _timeFlag = 0;
    _distanceFlag = 0;
}

- (NSArray *)calculatePriceWithSpeed:(CLLocationSpeed)speed
{
    _totalTime++;
    _distance += speed;
    if (_distanceFlag > _timeFlag) {
        _totalPrice += (((long)_distance/1000)+1-_containMileage)*(_rule.over_mileage_money.floatValue);
        return @[[NSString stringWithFormat:@"%.0f",_totalPrice],[NSString stringWithFormat:@"%.0f",_distance]];
    } else if (_distanceFlag < _timeFlag){
        _totalPrice += (_totalTime/3600-_rule.times.integerValue+1)*(_rule.over_time_money.floatValue);
        return @[[NSString stringWithFormat:@"%.0f",_totalPrice],[NSString stringWithFormat:@"%.0f",_distance]];
    }
    if (_distance > _containMileage)
    {
        _totalPrice += (((long)_distance/1000)+1-_containMileage)*(_rule.over_mileage_money.floatValue);
        _distanceFlag++;
        return @[[NSString stringWithFormat:@"%.0f",_totalPrice],[NSString stringWithFormat:@"%.0f",_distance]];
    }
    else if (_totalTime > _rule.times.integerValue*3600 && _timeFlag == 1)
    {
        _totalPrice += (_totalTime/3600-_rule.times.integerValue+1)*(_rule.over_time_money.floatValue);
        _timeFlag++;
        return @[[NSString stringWithFormat:@"%.0f",_totalPrice],[NSString stringWithFormat:@"%.0f",_distance]];
    }
    return @[[NSString stringWithFormat:@"%.0f",_totalPrice],[NSString stringWithFormat:@"%.0f",_distance],[NSString stringWithFormat:@"%.0f",_distance*0.00013]];
}

@end
