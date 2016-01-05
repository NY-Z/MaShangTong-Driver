//
//  MyUtil.h
//  LimitFree_1513
//
//  Created by gaokunpeng on 15/9/14.
//  Copyright (c) 2015年 gaokunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MyUtil : NSObject

//创建标签的方法
+ (UILabel *)createLabelFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor textAlignment:(NSTextAlignment)textAlignment numberOfLines:(NSInteger)numberOfLines;

+ (UILabel *)createLabelFrame:(CGRect)frame text:(NSString *)text color:(UIColor *)textColor;

//创建按钮的方法
+ (UIButton *)createBtnFrame:(CGRect)frame title:(NSString *)title bgImageName:(NSString *)bgImageName target:(id)target action:(SEL)action;

//创建图片视图的方法
+ (UIImageView *)createImageViewFrame:(CGRect)frame imageName:(NSString *)imageName;

//类型的英文转化成中文
+ (NSString *)transferCateName:(NSString *)name;


@end
