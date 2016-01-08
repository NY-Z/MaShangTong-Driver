//
//  NYWithdrawViewController.m
//  MaShangTong-Driver
//
//  Created by NY on 16/1/8.
//  Copyright © 2016年 NY. All rights reserved.
//

#import "NYWithdrawViewController.h"

@interface NYWithdrawViewController ()
@property (weak, nonatomic) IBOutlet UITextField *priceLabel;
@property (weak, nonatomic) IBOutlet UITextField *accountLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
- (IBAction)confirmBtnClicked:(id)sender;
@end

@implementation NYWithdrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"提现";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:21],NSForegroundColorAttributeName:RGBColor(73, 185, 254, 1.f)}];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    backBtn.size = CGSizeMake(22, 22);
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    [self handleTheWeidget];
    
}

- (void)handleTheWeidget
{
    self.priceLabel.layer.borderColor = RGBColor(109, 187, 248, 1.f).CGColor;
    self.priceLabel.layer.borderWidth = 1.f;
    self.priceLabel.layer.cornerRadius = 3.f;
    
    self.accountLabel.layer.cornerRadius = 3.f;
    self.accountLabel.layer.borderWidth = 1.f;
    self.accountLabel.layer.borderColor = RGBColor(109, 187, 248, 1.f).CGColor;
    
    self.nameLabel.layer.cornerRadius = 3.f;
    self.nameLabel.layer.borderColor = RGBColor(109, 187, 248, 1.f).CGColor;
    self.nameLabel.layer.borderWidth = 1.f;
    
    self.confirmBtn.layer.cornerRadius = 5.f;
}

- (IBAction)confirmBtnClicked:(id)sender {
}

- (void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
