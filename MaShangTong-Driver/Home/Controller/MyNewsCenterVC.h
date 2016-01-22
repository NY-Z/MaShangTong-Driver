//
//  MyNewsCenterVC.h
//  MaShangTong
//
//  Created by q on 15/12/10.
//  Copyright © 2015年 NY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyNewsCenterVC : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain) UITableView *tableView;

//储存数据的array
@property (nonatomic,copy) NSArray *newsDataAry;

@property (nonatomic,copy) NSMutableArray *hightAry;

@end
