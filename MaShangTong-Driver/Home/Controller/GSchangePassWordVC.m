//
//  GSchangePassWordVC.m
//  MaShangTong
//
//  Created by q on 15/12/21.
//  Copyright © 2015年 NY. All rights reserved.
//

#import "GSchangePassWordVC.h"
#import "AFNetworking.h"

@interface GSchangePassWordVC ()

@property (nonatomic,copy) NSString *resultsStr;

@end

@implementation GSchangePassWordVC

-(void)viewWillAppear:(BOOL)animated
{
    _lastPassWordText.text = nil;
    _nowPassWordText1.text = nil;
    _nowPassWordText2.text = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self dealNavicatonItens];
    
    _lastPassWordText.delegate = self;
    _nowPassWordText1.delegate = self;
    _nowPassWordText2.delegate = self;
    
}

#pragma mark - 设置NavicatonItens
-(void)dealNavicatonItens
{
    _makeSureBtn.layer.cornerRadius = 3.0f;
    _lastPassWordText.keyboardType = UIKeyboardTypeAlphabet;
    _nowPassWordText1.keyboardType = UIKeyboardTypeAlphabet;
    _nowPassWordText2.keyboardType = UIKeyboardTypeAlphabet;

    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    label.text = @"修改密码";
    label.textAlignment = 1;
    label.font = [UIFont systemFontOfSize:19];
    label.textColor = RGBColor(99, 193, 255, 1.f);
    
    self.navigationItem.titleView = label;
    
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    leftBtn.size = CGSizeMake(22, 22);
    [leftBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
}
//返回Btn的点击事件
-(void)backBtnClick
{
    [_lastPassWordText resignFirstResponder];
    [_nowPassWordText1 resignFirstResponder];
    [_nowPassWordText2 resignFirstResponder];

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextFiledDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(string.length >0){
        BOOL isSure = [self validateABC123:string];
        if (!isSure) {
            NYLog(@"格式不符合");
            UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"" message:@"只能包含数字、英文字母和符号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertV show];
            textField.text = nil;
        }
    }
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

//正则表达式 判断 英文和数字
- (BOOL) validateABC123:(NSString *)text
{
    NSString *textRegex = @"^[A-Z a-z 0-9]+$";
    NSPredicate *textTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",textRegex];
    return [textTest evaluateWithObject:text];
}

#pragma mark - 确定按钮的点击事件
- (IBAction)makeSureChangedPassWord:(id)sender {
    if (_lastPassWordText.text.length == 0) {
        UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"警告" message:@"原密码不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertV show];
        return;
    }
    if (_nowPassWordText1.text.length ==0 || _nowPassWordText2.text.length == 0) {
        UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"警告" message:@"新密码不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertV show];
        return;
    }
    else if (![_nowPassWordText1.text isEqual:_nowPassWordText2.text])
    {
        UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"" message:@"新密码两次输入不一致" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertV show];
        return;
    }
    else if(_nowPassWordText1.text.length<6 || _nowPassWordText1.text.length >20){
        UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"" message:@"新密码长度不符合标准" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertV show];
        return;
    }
    
    [self sendOrder];

    

}
#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if ([alertView.message isEqualToString:@"修改成功"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        _lastPassWordText.text = nil;
        _nowPassWordText1.text = nil;
        _nowPassWordText2.text = nil;
    }
}

-(void)sendOrder
{
    NSDictionary *param = [NSDictionary dictionaryWithObjects:@[[USER_DEFAULT objectForKey:@"user_id"],@"3",_lastPassWordText.text,_nowPassWordText1.text] forKeys:@[@"id",@"group_id",@"user_pwd",@"new_pwd"]];
    NSString *url = [NSString stringWithFormat:URL_HEADER,@"UserApi",@"modify_password"];
    
    if (![Helper justPassword:_lastPassWordText.text]) {
        [MBProgressHUD showError:@"原密码输入错误"];
        return;
    }
    if (![Helper justPassword:_nowPassWordText1.text]) {
        [MBProgressHUD showError:@"新密码格式错误"];
        return;
    }
    if (![_nowPassWordText1.text isEqualToString:_nowPassWordText2.text]) {
        [MBProgressHUD showError:@"两次密码不一致"];
        return;
    }
    [MBProgressHUD showMessage:@"修改中"];
    [DownloadManager post:url params:param success:^(id json) {
        @try {
            [MBProgressHUD hideHUD];
            NSString *dataStr = [NSString stringWithFormat:@"%@",json[@"data"]];
            if ([dataStr isEqualToString:@"1"]) {
                [MBProgressHUD showSuccess:@"密码修改成功"];
                [self.navigationController popViewControllerAnimated:YES];
                return ;
            } else {
                [MBProgressHUD showSuccess:json[@"info"]];
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    } failure:^(NSError *error) {
        
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
@end
