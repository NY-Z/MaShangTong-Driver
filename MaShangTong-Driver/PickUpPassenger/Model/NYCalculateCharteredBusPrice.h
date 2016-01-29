//
//  NYCalculateCharteredBusPrice.h
//  MaShangTong-Personal
//
//  Created by NY on 16/1/13.
//  Copyright © 2016年 jeaner. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RuleInfoModel;

@interface NYCalculateCharteredBusPrice : NSObject

@property (nonatomic,strong) RuleInfoModel *rule;

+ (instancetype)shareCharteredBusPrice;
- (NSArray *)calculatePriceWithSpeed:(CLLocationSpeed)speed andGonePrice:(NSString *)mileage andBordingTime:(NSString *)boardingTime;

@end
