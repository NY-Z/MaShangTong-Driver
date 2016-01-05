//
//  NYMyCommentModel.h
//  MaShangTong-Driver
//
//  Created by apple on 15/12/16.
//  Copyright © 2015年 jeaner. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol NYMyCommentInfoModel;
@interface NYMyCommentInfoModel : JSONModel

@property (nonatomic,strong) NSString <Optional> *add_time;
@property (nonatomic,strong) NSString <Optional> *content;
@property (nonatomic,strong) NSString <Optional> *head_image;
@property (nonatomic,strong) NSString <Optional> *stars;

@end

@interface NYMyCommentModel : JSONModel

@property (nonatomic,strong) NSString <Optional> *data;
@property (nonatomic,strong) NSMutableArray <Optional,NYMyCommentInfoModel> *info;
@property (nonatomic,strong) NSString <Optional> *status;

@end
