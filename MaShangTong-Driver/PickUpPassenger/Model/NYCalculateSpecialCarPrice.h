//
//  NYCalculateSpecialCarPrice.h
//  MaShangTong-Personal
//
//  Created by NY on 16/1/13.
//  Copyright © 2016年 jeaner. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RuleInfoModel;

@interface NYCalculateSpecialCarPrice : NSObject

@property (nonatomic,strong) RuleInfoModel *model;


@property (nonatomic,assign) float distance;
@property (nonatomic,assign) float price;
@property (nonatomic,assign) NSInteger lowSpeedTime;
@property (nonatomic,assign) float lowSpeedPrice;
@property (nonatomic,assign) float longDistance;
@property (nonatomic,assign) float longPrice;
@property (nonatomic,assign) float nightPrice;

+ (instancetype)sharedPrice;

- (NSDictionary *)calculatePriceWithParams:(NSDictionary *)params;

@end
