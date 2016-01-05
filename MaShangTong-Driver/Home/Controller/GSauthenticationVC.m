//
//  GSauthenticationVC.m
//  MaShangTong
//
//  Created by q on 15/12/24.
//  Copyright © 2015年 NY. All rights reserved.
//

#import "GSauthenticationVC.h"

@interface GSauthenticationVC ()

@end

@implementation GSauthenticationVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self dealNavicatonItens];
    _btn.layer.cornerRadius = 3.0f;
}
#pragma mark - 设置NavicatonItens
-(void)dealNavicatonItens
{
    self.navigationItem.title = @"实名认证";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:RGBColor(99, 193, 255, 1.f)}];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    leftBtn.size = CGSizeMake(22, 22);
    [leftBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
}
//返回Btn的点击事件
-(void)backBtnClick
{
    [_nameTextFiled resignFirstResponder];
    [_numTextFiled resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UITextFiledDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}




- (IBAction)send:(id)sender {
    [_nameTextFiled resignFirstResponder];
    [_numTextFiled resignFirstResponder];
    
    NSLog(@"实名认证");
    if (_numTextFiled.text.length != 18) {
        [MBProgressHUD showError:@"省份证号有误，请重新输入"];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [_nameTextFiled resignFirstResponder];
    [_numTextFiled resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
