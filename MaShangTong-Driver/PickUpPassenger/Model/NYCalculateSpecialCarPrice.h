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

+ (instancetype)sharedPrice;

- (NSDictionary *)calculatePriceWithParams:(NSDictionary *)params;

@end
