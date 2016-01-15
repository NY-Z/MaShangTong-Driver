//
//  WithdrawingViewController.m
//  PPTravel
//
//  Created by mac on 26/1/24.
//  Copyright © 2026年 xinfu. All rights reserved.
//

#import "WithdrawingViewController.h"
#import "SelfCardViewController.h"

#define color_systemOrange RGBColor(112, 191, 253, 1.f)

@interface WithdrawingViewController ()

@property (weak, nonatomic) IBOutlet UITextField *balance;
@property (weak, nonatomic) IBOutlet UILabel *card;
- (IBAction)Done:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *Done;
@property (nonatomic,strong) NSMutableDictionary *transParams;

@end

@implementation WithdrawingViewController

- (NSDictionary *)transParams
{
    if (_transParams == nil) {
        _transParams = [NSDictionary dictionary];
    }
    return _transParams;
}

- (void)configNavigationBar
{
    self.navigationItem.title = @"提现";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:21],NSForegroundColorAttributeName:RGBColor(73, 185, 254, 1.f)}];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    backBtn.size = CGSizeMake(22, 22);
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}

- (void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = background_Color;
    [self.Done setBackgroundColor:color_systemOrange];

    [self.card setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tpg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCard)];
    [self.card addGestureRecognizer:tpg];
    
    [self configNavigationBar];
}

-(void)clickCard{
    SelfCardViewController *svc = [[SelfCardViewController alloc] init];
    svc.selectBankCard = ^(NSDictionary *params,NSString *text) {
        _card.text = text;
        _transParams = [params mutableCopy];
    };
    [self.navigationController pushViewController:svc animated:YES];
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
    [_balance resignFirstResponder];
}

- (IBAction)Done:(id)sender {
    [MBProgressHUD showMessage:@"请稍候"];
    [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"OrderApi",@"withDraw"] params:@{@"user_id":[USER_DEFAULT objectForKey:@"user_id"],@"money":_balance.text,@"bank_name":_transParams[@"bank_name"],@"bank_account":_transParams[@"car_num"],@"bank_user":_transParams[@"real_name"],@"bank_id":_transParams[@"bank_id"],@"mobile":_transParams[@"mobile"]} success:^(id json) {
        [MBProgressHUD hideHUD];
        NSString *dataStr = [NSString stringWithFormat:@"%@",json[@"data"]];
        if ([dataStr isEqualToString:@"1"]) {
            [MBProgressHUD showSuccess:@"已申请提现，请等待发放"];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [MBProgressHUD showError:@"提现失败"];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络错误，请重试"];
    }];
    
}

@end
