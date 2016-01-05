//
//  NYMyVoucherModel.h
//  MaShangTong-Driver
//
//  Created by apple on 15/12/16.
//  Copyright © 2015年 jeaner. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface NYMyVoucherModel : JSONModel

@property (nonatomic,strong) NSString <Optional> *id;
@property (nonatomic,strong) NSString <Optional> *name;
@property (nonatomic,strong) NSString <Optional> *price;
@property (nonatomic,strong) NSString <Optional> *shop_id;
@property (nonatomic,strong) NSString <Optional> *ticket_id;
@property (nonatomic,strong) NSString <Optional> *time;
@property (nonatomic,strong) NSString <Optional> *user_id;

@end
/*
 {
 id = 19;
 name = "专车券";
 price = 10;
 "shop_id" = 2;
 "ticket_id" = 2;
 time = "2016-2-21";
 "user_id" = 97;
 }
 */