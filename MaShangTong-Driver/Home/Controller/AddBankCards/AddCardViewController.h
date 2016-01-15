//
//  AddCardViewController.h
//  PPTravel
//
//  Created by mac on 26/1/24.
//  Copyright © 2026年 xinfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddCardViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *cardNum;
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
- (IBAction)addCard:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *cardType;

@end
