//
//  ModefiedViewController.h
//  MaShangTong
//
//  Created by jeaner on 15/11/10.
//  Copyright © 2015年 NY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassengerModel.h"
#import "ActualPriceModel.h"

@interface ModefiedViewController : UIViewController

@property (nonatomic,strong) NSString *driverDistance;
@property (nonatomic,strong) NSString *price;
@property (nonatomic,strong) NSString *lowSpeedTime;
@property (nonatomic,strong) NSString *lowSpeedPrice;

@property (nonatomic,strong) DataModel *model;

@property (nonatomic,strong) ActualPriceModel *priceModel;

@end
