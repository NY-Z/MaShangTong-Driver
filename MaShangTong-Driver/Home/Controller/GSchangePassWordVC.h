//
//  GSchangePassWordVC.h
//  MaShangTong
//
//  Created by q on 15/12/21.
//  Copyright © 2015年 NY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSchangePassWordVC : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *lastPassWordText;

@property (weak, nonatomic) IBOutlet UITextField *nowPassWordText1;
@property (weak, nonatomic) IBOutlet UITextField *nowPassWordText2;

@property (weak, nonatomic) IBOutlet UIButton *makeSureBtn;

- (IBAction)makeSureChangedPassWord:(id)sender;

@end
