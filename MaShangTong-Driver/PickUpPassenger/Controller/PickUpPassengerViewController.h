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

@interface PickUpPassengerViewController : BaseNaviViewController

@property (nonatomic,strong) DataModel *model;
//@property (nonatomic,strong) CarRuleModel *carRuleModel;
@property (nonatomic,strong) RuleInfoModel *ruleInfoModel;

@end
