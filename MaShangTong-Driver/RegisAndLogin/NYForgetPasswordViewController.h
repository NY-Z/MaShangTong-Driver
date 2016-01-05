//
//  NYForgetPasswordViewController.h
//  MaShangTong-Personal
//
//  Created by apple on 15/12/22.
//  Copyright © 2015年 jeaner. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger ,ForgetPasswordType) {
    ForgetPasswordTypeCompany = 2,
    ForgetPasswordTypePerson =3,
};

@interface NYForgetPasswordViewController : UIViewController

@property (nonatomic,assign) ForgetPasswordType type;

@end
