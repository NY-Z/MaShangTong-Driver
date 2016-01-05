//
//  NYForgetPasswordViewController.m
//  MaShangTong-Personal
//
//  Created by apple on 15/12/22.
//  Copyright © 2015年 jeaner. All rights reserved.
//

#import "NYForgetPasswordViewController.h"
#import "AFNetworking.h"

@interface NYForgetPasswordViewController ()
{
    NSString *_random;
    NSTimer *_timer;
    NSInteger _time;
}
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendVerificationCodeBtn;
- (IBAction)sendVerificationCodeBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
- (IBAction)confirmBtnClicked:(id)sender;

@end

@implementation NYForgetPasswordViewController

- (void)configNavigationBar
{
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"忘记密码";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:21],NSForegroundColorAttributeName:RGBColor(73, 185, 254, 1.f)}];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBarButtonItemClicked) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.size = CGSizeMake(44, 44);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _time = 60;
    [self configNavigationBar];
    [self handleTheWeidget];
}

- (void)handleTheWeidget
{
    _mobileTextField.layer.borderColor = RGBColor(84, 175, 255, 1.f).CGColor;
    _mobileTextField.layer.borderWidth = 1.f;
    _mobileTextField.layer.cornerRadius = 3.f;
    _mobileTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    _verificationCodeTextField.layer.borderColor = RGBColor(84, 175, 255, 1.f).CGColor;
    _verificationCodeTextField.layer.borderWidth = 1.f;
    _verificationCodeTextField.layer.cornerRadius = 3.f;
    _verificationCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    _passwordTextField.layer.borderColor = RGBColor(84, 175, 255, 1.f).CGColor;
    _passwordTextField.layer.borderWidth = 1.f;
    _passwordTextField.layer.cornerRadius = 3.f;
    _passwordTextField.secureTextEntry = YES;
    
    _confirmTextField.layer.borderColor = RGBColor(84, 175, 255, 1.f).CGColor;
    _confirmTextField.layer.borderWidth = 1.f;
    _confirmTextField.layer.cornerRadius = 3.f;
    _confirmTextField.secureTextEntry = YES;
    
    _sendVerificationCodeBtn.layer.borderColor = RGBColor(84, 175, 255, 1.f).CGColor;
    _sendVerificationCodeBtn.layer.borderWidth = 1.f;
    _sendVerificationCodeBtn.layer.cornerRadius = 3.f;
    
    _confirmBtn.layer.borderColor = RGBColor(84, 175, 255, 1.f).CGColor;
    _confirmBtn.layer.borderWidth = 1.f;
    _confirmBtn.layer.cornerRadius = 3.f;
}

- (IBAction)sendVerificationCodeBtnClicked:(id)sender {
    
    if (![Helper justMobile:_mobileTextField.text]) {
        [MBProgressHUD showSuccess:@"请输入正确的手机号"];
        return;
    }
    
    _random = @"";
    for(int i=0; i<6; i++)
    {
        _random = [_random stringByAppendingFormat:@"%i",(arc4random() % 9)];
    }
    NYLog(@"%@",_random);
    UIButton *btn = (UIButton *)sender;
    [btn setTitle:@"验证码已发送" forState:UIControlStateNormal];
    btn.enabled = NO;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"码尚通" forKey:@"name"];
    [params setValue:@"码尚通" forKey:@"sign"];
    [params setValue:@"6C572C72EE1CA257886E65C7E5F3" forKey:@"pwd"];
    [params setValue:[NSString stringWithFormat:@"您的验证码为%@切勿泄露给他人，有效期为60秒",_random] forKey:@"content"];
    [params setValue:_mobileTextField.text forKey:@"mobile"];
    [params setValue:@"pt" forKey:@"type"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:@"http://sms.1xinxi.cn/asmx/smsservice.aspx" parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self initTimer];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)initTimer
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerUpdate) userInfo:nil repeats:YES];
    } else {
        [_timer setFireDate:[NSDate distantPast]];
    }
}

- (void)timerUpdate
{
    _time--;
    [_sendVerificationCodeBtn setTitle:[NSString stringWithFormat:@"%lis后重新发送",(long)_time] forState:UIControlStateNormal];
    _sendVerificationCodeBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    if (_time == 0) {
        _time = 60;
        _sendVerificationCodeBtn.enabled = YES;
        [_sendVerificationCodeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
        [_timer setFireDate:[NSDate distantFuture]];
    }
}

- (IBAction)confirmBtnClicked:(id)sender
{
    BOOL isVerification = [_verificationCodeTextField.text isEqualToString:_random];
    if (!isVerification) {
        [MBProgressHUD showError:@"您的验证码错误"];
        return;
    }
    BOOL isSame = [_passwordTextField.text isEqualToString:_confirmTextField.text];
    if (!isSame) {
        [MBProgressHUD showSuccess:@"您的密码不匹配"];
        return;
    }
    self.type = ForgetPasswordTypeCompany;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:_mobileTextField.text forKey:@"mobile"];
    [params setValue:@"3" forKey:@"group_id"];
    [params setValue:_confirmTextField.text forKey:@"password"];
    [MBProgressHUD showMessage:@"正在修改"];
    [DownloadManager post:@"http://112.124.115.81/m.php?m=UserApi&a=forget_password" params:params success:^(id json) {
        
        @try {
            NSString *dataStr = [NSString stringWithFormat:@"%@",json[@"data"]];
            [MBProgressHUD hideHUD];
            if ([dataStr isEqualToString:@"1"]) {
                [MBProgressHUD showSuccess:@"密码修改成功，请重新登录"];
            } else if ([dataStr isEqualToString:@"0"]) {
                [MBProgressHUD showSuccess:@"密码修改失败，请重试"];
            } else {
                [MBProgressHUD showError:@"该账户不存在，请注册"];
            }
        }
        @catch (NSException *exception) {
            [MBProgressHUD showSuccess:@"密码修改失败，请重试"];
        }
        @finally {
            
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)leftBarButtonItemClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
