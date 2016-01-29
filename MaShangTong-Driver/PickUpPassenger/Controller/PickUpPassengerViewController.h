//
//  PickUpPassengerViewController.h
//  MaShangTong-Driver
//
//  Created by NY on 15/11/18.
//  Copyright © 2015年 jeaner. All rights reserved.
//

#import "BaseNaviViewController.h"
#import "PassengerModel.h"
//#import "CarRuleModel.h"
typedef enum{
    NotExit,//没有退出程序
    HadExit//退出程序重新进来
}IsHadExit;

@interface PickUpPassengerViewController : BaseNaviViewController

@property (nonatomic,strong) DataModel *model;
//@property (nonatomic,strong) CarRuleModel *carRuleModel;
@property (nonatomic,strong) RuleInfoModel *ruleInfoModel;

@property (nonatomic,strong) NSString *gonePrice;

//是否退出程序
@property (nonatomic,assign) IsHadExit isHadExit;
//退出程序之前的低速时间
@property (nonatomic,strong) NSString *low_time;
//退出之前行驶的距离
@property (nonatomic,strong) NSString *mileage;
//开始计费的时间（时间戳）
@property (nonatomic,strong) NSString *boardingTime;


@end
