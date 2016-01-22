//
//  AddCardViewController.m
//  PPTravel
//
//  Created by mac on 26/1/24.
//  Copyright © 2026年 xinfu. All rights reserved.
//

#import "AddCardViewController.h"

#define color_systemOrange RGBColor(112, 191, 253, 1.f)

@interface AddCardViewController ()

@end

@implementation AddCardViewController

- (void)configNavigationBar
{
    self.navigationItem.title = @"添加银行卡";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:21],NSForegroundColorAttributeName:RGBColor(73, 185, 254, 1.f)}];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    backBtn.size = CGSizeMake(22, 22);
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = background_Color;
    [self.addBtn setBackgroundColor:color_systemOrange];
    self.addBtn.layer.cornerRadius = 5.f;
    
    [self configNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - 隐藏键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_nameText resignFirstResponder];
    [_phoneText resignFirstResponder];
    [_cardNum resignFirstResponder];
}
- (IBAction)addCard:(id)sender {
    if (![Helper isValidCardNumber:_cardNum.text]) {
        [MBProgressHUD showError:@"您的银行卡号有误"];
        return;
    }
    if (![Helper justMobile:_phoneText.text]) {
        [MBProgressHUD showError:@"请输入正确的手机号码"];
        return;
    }
    if (![Helper justNickname:_nameText.text]) {
        [MBProgressHUD showError:@"您的名字输入不正确"];
        return;
    }
    if (_cardType.text.length <= 2) {
        [MBProgressHUD showError:@"请输入银行卡类型"];
        return;
    }
    [MBProgressHUD showMessage:@"正在添加"];
    [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"OrderApi",@"add_bank"] params:@{@"user_id":[USER_DEFAULT objectForKey:@"user_id"],@"real_name":_nameText.text,@"car_num":_cardNum.text,@"bank_name":_cardType.text,@"mobile":_phoneText.text} success:^(id json) {
        @try {
            NSString *dataStr = [NSString stringWithFormat:@"%@",json[@"data"]];
            [MBProgressHUD hideHUD];
            if ([dataStr isEqualToString:@"0"]) {
                [MBProgressHUD showError:@"银行卡添加失败，请重试"];
                return ;
            } else {
                [MBProgressHUD showSuccess:@"添加成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"银行卡添加失败，请重试"];
    }];
    
}

- (void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
