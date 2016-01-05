//
//  PersonCenterViewController.h
//  MaShangTong
//
//  Created by niliu1h  on 15/10/17.
//  Copyright (c) 2015年 NY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonCenterViewController : UIViewController

@property (nonatomic,strong) void (^tableViewCellSelected) (NSInteger celId,NSString *cellTitle);
@property (nonatomic,strong) void (^tableHeaderViewClicked) ();
@property (nonatomic,strong) void (^logOutBtnClicked) ();

@end
