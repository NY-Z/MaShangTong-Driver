//
//  DriverRegisViewController.m
//  MaShangTong
//
//  Created by NY on 15/10/29.
//  Copyright © 2015年 NY. All rights reserved.
//

#import "DriverRegisViewController.h"
#import "DriverJoinInViewController.h"
#import "HomeDriverViewController.h"
#import "DriverInfoModel.h"
#import "NYForgetPasswordViewController.h"
#import "NYDriverDelegateViewController.h"

@interface DriverRegisViewController ()
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *dealBtn;
- (IBAction)delegateBtnClicked:(id)sender;

@end

@implementation DriverRegisViewController

- (void)setNavigationBar
{
    self.navigationItem.title = @"欢迎";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:21],NSForegroundColorAttributeName:RGBColor(73, 185, 254, 1.f)}];
    
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.layer.borderColor = RGBColor(84, 175, 255, 1.f).CGColor;
    self.passwordTextField.layer.borderWidth = 1.f;
    self.passwordTextField.layer.cornerRadius = 3.f;
    self.numberTextField.keyboardType = UIKeyboardTypePhonePad;
    self.numberTextField.layer.borderColor = RGBColor(84, 175, 255, 1.f).CGColor;
    self.numberTextField.layer.cornerRadius = 3.f;
    self.numberTextField.layer.borderWidth = 1.f;
    self.loginBtn.layer.cornerRadius = 5.f;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}

- (IBAction)forgetPassWord:(UIButton *)sender {
    
    
    NYForgetPasswordViewController *forget = [[NYForgetPasswordViewController alloc] init];
    [self.navigationController pushViewController:forget animated:YES];
    
}

- (IBAction)joinInBtn:(UIButton *)sender {
    
    DriverJoinInViewController *driverJoinIn = [[DriverJoinInViewController alloc] init];
    [self.navigationController pushViewController:driverJoinIn animated:YES];
    
}
- (IBAction)loginBtn:(UIButton *)sender {
    
    if (!_dealBtn.selected) {
        [MBProgressHUD showError:@"请同意《服务标准及违约责任约定》"];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (![Helper justMobile:_numberTextField.text]) {
        [MBProgressHUD showError:@"请输入正确的手机号"];
        return;
    }
    [params setValue:_numberTextField.text forKey:@"mobile"];
    if (![Helper justPassword:_passwordTextField.text]) {
        [MBProgressHUD showError:@"密码格式错误"];
        return;
    }
    [params setValue:_passwordTextField.text forKey:@"user_pwd"];
    [params setValue:@"3" forKey:@"group_id"];
    [MBProgressHUD showMessage:@"正在登陆"];

    [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"UserApi",@"login"] params:params success:^(id json) {
        @try {
            NYLog(@"%@",json);
            [MBProgressHUD hideHUD];
            
            NSString *dataStr = json[@"data"];
            
            if ([dataStr isEqualToString:@"1"]) {
                [MBProgressHUD showSuccess:@"登陆成功"];
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    [USER_DEFAULT setValue:json[@"user_id"] forKey:@"user_id"];
                    [USER_DEFAULT setValue:@"1" forKey:@"isLogin"];
                    DriverInfoModel *driverInfo = [[DriverInfoModel alloc] initWithDictionary:json[@"info"][@"user_info"] error:nil];
                    driverInfo.license_plate = json[@"info"][@"license_plate"];
                    driverInfo.snum = json[@"info"][@"snum"];
                    driverInfo.point = json[@"info"][@"point"];
                    [USER_DEFAULT setObject:[NSKeyedArchiver archivedDataWithRootObject:driverInfo] forKey:@"user_info"];
                    [USER_DEFAULT synchronize];
                });
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationController pushViewController:[[HomeDriverViewController alloc] init] animated:YES];
                });
            } else if ([dataStr isEqualToString:@"0"]){
                [MBProgressHUD showError:@"密码错误,请重新输入密码"];
                return ;
            } else if ([dataStr isEqualToString:@"-1"]) {
                [MBProgressHUD showError:@"该用户不存在"];
                return;
            } else if ([dataStr isEqualToString:@"2"]) {
                [MBProgressHUD showError:@"该用户已注册其他客户端"];
                return;
            }

        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络错误"];
        NYLog(@"%@",error.localizedDescription);
        
    }];
    
}

- (IBAction)agreeConversation:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
}

#pragma mark - Touch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [_numberTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
}

- (IBAction)delegateBtnClicked:(id)sender {
    
    NYDriverDelegateViewController *delegate = [[NYDriverDelegateViewController alloc] init];
    [self.navigationController pushViewController:delegate animated:YES];
}
@end
