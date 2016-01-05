//
//  AppDelegate.h
//  MaShangTong-Driver
//
//  Created by jeaner on 15/11/11.
//  Copyright © 2015年 jeaner. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AMapNaviKit/MAMapKit.h>

#import "ValuationRuleModel.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,assign) CLLocationCoordinate2D driverCoordinate;

@property (nonatomic,strong) NSString *driverSpeed;

@end

