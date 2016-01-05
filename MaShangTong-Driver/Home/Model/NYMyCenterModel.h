//
//  NYMyCenterModel.h
//  MaShangTong-Driver
//
//  Created by NY on 15/12/28.
//  Copyright © 2015年 NY. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface NYMyCenterModel : JSONModel

@property (nonatomic,strong) NSString <Optional> *content;
@property (nonatomic,strong) NSString <Optional> *group_id;
@property (nonatomic,strong) NSString <Optional> *msg_id;
@property (nonatomic,strong) NSString <Optional> *status;
@property (nonatomic,strong) NSString <Optional> *time;
@property (nonatomic,strong) NSString <Optional> *title;

@end
