//
//  MyNewsCenterVC.h
//  MaShangTong
//
//  Created by q on 15/12/10.
//  Copyright © 2015年 NY. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyNewsTableViewCell;

@interface MyNewsCenterVC : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain) UITableView *tableView;
//@property (nonatomic,retain) MyNewsTableViewCell *cell;

//储存数据的array
@property (nonatomic,copy) NSArray *newsDataAry;



@end
