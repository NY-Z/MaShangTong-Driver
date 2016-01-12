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
@property (weak, nonatomic) IBOutlet UITextField *cardholderTextField;
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
    
    self.cardholderTextField.layer.cornerRadius = 3.f;
    self.cardholderTextField.layer.borderColor = RGBColor(109, 187, 248, 1.f).CGColor;
    self.cardholderTextField.layer.borderWidth = 1.f;
    
    self.confirmBtn.layer.cornerRadius = 5.f;
}

- (IBAction)confirmBtnClicked:(id)sender {
    if (![Helper isValidCardNumber:_accountLabel.text]) {
        [MBProgressHUD showError:@"请输入正确的银行卡账号"];
        return;
    }
    if ([_nameLabel.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"请输入您的银行卡类型"];
        return;
    }
    if (![Helper justNickname:_cardholderTextField.text]) {
        [MBProgressHUD showError:@"请输入持卡人姓名"];
        return;
    }
    [MBProgressHUD showMessage:@"提现中"];
    NSDictionary *params = @{@"user_id":[USER_DEFAULT objectForKey:@"user_id"],@"money":_priceLabel.text,@"bank_name":_nameLabel.text,@"bank_account":_accountLabel.text,@"bank_user":_cardholderTextField.text};
    [DownloadManager post:@"http://112.124.115.81/m.php?m=OrderApi&a=withDraw" params:params success:^(id json) {
        @try {
            NSString *dataStr = [NSString stringWithFormat:@"%@",json[@"data"]];
            if ([dataStr isEqualToString:@"0"]) {
                [MBProgressHUD showError:@"提现失败，请重试"];
                return ;
            }
            [MBProgressHUD showSuccess:@"提现成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"提现失败，请重试"];
    }];
    
}

- (void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
