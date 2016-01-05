//
//  InputViewController.h
//  MaShangTong
//
//  Created by niliu1h  on 15/10/21.
//  Copyright (c) 2015年 NY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface InputViewController : UIViewController

@property (nonatomic,strong) NSString *textFieldText;

@property (nonatomic,strong) void (^changeDestination) (AMapTip *p);

@end
