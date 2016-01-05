//
//  DriverJoinInViewController.m
//  MaShangTong
//
//  Created by NY on 15/10/29.
//  Copyright © 2015年 NY. All rights reserved.
//

#import "DriverJoinInViewController.h"
#import "DetailInfoViewController.h"

@interface DriverJoinInViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendSmsBtn;
@property (weak, nonatomic) IBOutlet UITextField *returnSmsTextField;
@property (weak, nonatomic) IBOutlet UIButton *joinInBtn;

@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (nonatomic,strong) NSString *verification;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) NSInteger time;

@end

@implementation DriverJoinInViewController

- (void)setXibViews{
    self.sendSmsBtn.layer.borderColor = RGBColor(144, 199, 254, 1.f).CGColor;
    self.sendSmsBtn.layer.borderWidth = 1.f;
    self.sendSmsBtn.layer.cornerRadius = 3.f;
    
    self.numberTextField.layer.borderWidth = 1.f;
    self.numberTextField.layer.borderColor = RGBColor(144, 199, 254, 1.f).CGColor;
    self.numberTextField.layer.cornerRadius = 3.f;
    self.numberTextField.clipsToBounds = YES;
    self.numberTextField.delegate = self;
    self.numberTextField.keyboardType = UIKeyboardTypePhonePad;
    
    self.returnSmsTextField.layer.borderColor = RGBColor(144, 199, 254, 1.f).CGColor;
    self.returnSmsTextField.layer.borderWidth = 1.f;
    self.returnSmsTextField.layer.cornerRadius = 3.f;
    self.returnSmsTextField.clipsToBounds = YES;
    self.returnSmsTextField.delegate = self;
    
    self.codeTextField.layer.borderWidth = 1.f;
    self.codeTextField.layer.borderColor = RGBColor(144, 199, 254, 1.f).CGColor;
    self.codeTextField.layer.cornerRadius = 3.f;
    self.codeTextField.clipsToBounds = YES;
    self.codeTextField.delegate = self;
    self.codeTextField.secureTextEntry = YES;
}

- (void)setNavigationBar
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.text = @"司机加盟";
    titleLabel.textAlignment = 1;
    titleLabel.textColor = RGBColor(112, 187, 254, 1.f);
    titleLabel.font = [UIFont systemFontOfSize:16];
    self.navigationItem.titleView = titleLabel;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:RGBColor(199, 199, 199, 1.f) forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [backBtn setImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
    backBtn.size = CGSizeMake(54, 44);
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}

- (void)initTimer
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerUpdate) userInfo:nil repeats:YES];
    } else {
        [_timer setFireDate:[NSDate distantPast]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _time = 60;
    _verification = @"";
    [self setXibViews];
    [self setNavigationBar];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect rect = [textField convertRect:textField.frame toView:nil];
    
    CGFloat offSet = SCREEN_HEIGHT-(CGRectGetMaxY(rect)+216);
    NSLog(@"%f",SCREEN_HEIGHT);
    NSLog(@"%f",CGRectGetMaxY(rect)+216);
    NSLog(@"%f",offSet);
    if (offSet <= -50) {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.y = offSet+216;
        }];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.view.frame.origin.y != 0) {
        
        [UIView animateWithDuration:0.3 animations:^{
            self.view.y = 64;
        }];
        
    }
}

#pragma mark - Touch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.numberTextField resignFirstResponder];
    [self.returnSmsTextField resignFirstResponder];
    [self.codeTextField resignFirstResponder];
}

#pragma mark - Action
- (IBAction)sendSmsBtnClicked:(UIButton *)sender {
    
    [_numberTextField resignFirstResponder];
    [_returnSmsTextField resignFirstResponder];
    [_codeTextField resignFirstResponder];
    
    if (![Helper justMobile:_numberTextField.text]) {
        [MBProgressHUD showError:@"请输入正确的手机号"];
        return;
    }
    
    _verification = @"";
    for(int i=0; i<6; i++)
    {
        _verification = [_verification stringByAppendingFormat:@"%i",(arc4random() % 9)];
    }
    
    UIButton *btn = (UIButton *)sender;
    [btn setTitle:@"验证码已发送" forState:UIControlStateNormal];
    btn.enabled = NO;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"码尚通" forKey:@"name"];
    [params setValue:@"码尚通" forKey:@"sign"];
    [params setValue:@"6C572C72EE1CA257886E65C7E5F3" forKey:@"pwd"];
    [params setValue:[NSString stringWithFormat:@"您的验证码为%@切勿泄露给他人，有效期为60秒",_verification] forKey:@"content"];
    [params setValue:_numberTextField.text forKey:@"mobile"];
    [params setValue:@"pt" forKey:@"type"];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:@"http://sms.1xinxi.cn/asmx/smsservice.aspx" parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NYLog(@"%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        [self initTimer];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}

- (IBAction)quickJoinInBTnClicked:(UIButton *)sender {
    
    NSLog(@"%@",_verification);
    
    if (![_returnSmsTextField.text isEqualToString:_verification]) {
        [MBProgressHUD showError:@"短信验证码错误"];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (![Helper justMobile:_numberTextField.text]) {
        [MBProgressHUD showMessage:@"请输入正确的手机号"];
        return;
    }
    [params setValue:_numberTextField.text forKey:@"mobile"];
    if (![Helper justPassword:_codeTextField.text]) {
        [MBProgressHUD showError:@"您的密码格式不正确"];
        return;
    }
    [params setValue:_codeTextField.text forKey:@"pwd"];
    [params setValue:@"3" forKey:@"group_id"];
    [DownloadManager post:@"http://112.124.115.81/m.php?m=UserApi&a=register" params:params success:^(id json) {
        
        NSLog(@"%@",json);
        NSString *resultStr = json[@"result"];
        if ([resultStr isEqualToString:@"1"]) {
            
            [MBProgressHUD showSuccess:@"注册成功 请继续填写您的详细信息"];
            DetailInfoViewController *detailInfo = [[DetailInfoViewController alloc] init];
            detailInfo.userId = json[@"user_id"];
            [self.navigationController pushViewController:detailInfo animated:YES];
            
            
        } else if ([resultStr isEqualToString:@"0"]) {
            
            [MBProgressHUD showError:@"注册失败，请重新注册"];
            return ;
            
        } else if ([resultStr isEqualToString:@"-1"]) {
            
            [MBProgressHUD showError:@"该手机号码已注册"];
            return;
        }
        
    } failure:^(NSError *error) {
        
        NSLog(@"%@",error.localizedDescription);
        [MBProgressHUD showError:@"网络错误"];
    }];
    
    /*
     {
     data = 0;
     info = "\U8be5\U7528\U6237\U540d\U4e0d\U5b58\U5728";
     status = 1;
     }
     */
    
}

- (void)backBtnClicked:(UIButton *)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Timer
- (void)timerUpdate
{
    _time--;
    [_sendSmsBtn setTitle:[NSString stringWithFormat:@"%lis后重新发送",(long)_time] forState:UIControlStateNormal];
    _sendSmsBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    if (_time == 0) {
        _time = 60;
        _sendSmsBtn.enabled = YES;
        [_sendSmsBtn setTitle:@"重新发送" forState:UIControlStateNormal];
        [_timer setFireDate:[NSDate distantFuture]];
    }
}

@end
