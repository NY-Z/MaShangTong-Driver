//
//  NYInvitationViewController.m
//  MaShangTong-Driver
//
//  Created by apple on 15/12/19.
//  Copyright © 2015年 jeaner. All rights reserved.
//

#import "NYInvitationViewController.h"

@interface NYInvitationViewController ()

- (IBAction)confirmBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@end

@implementation NYInvitationViewController

- (void)configNavigationBar
{
    self.navigationItem.title = @"邀请加盟";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:21],NSForegroundColorAttributeName:RGBColor(73, 185, 254, 1.f)}];
    NAVIGATIONITEM_BACKBARBUTTONITEM;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configNavigationBar];
    [self handleTheWeidget];
}

- (void)handleTheWeidget
{
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
}

#pragma mark - Action
- (void)leftBarButtonItemClicked:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)confirmBtnClicked:(id)sender {
    [self sendSMS];
    if (![Helper justMobile:_mobileTextField.text]) {
        [MBProgressHUD showError:@"请输入正确的手机号"];
        return;
    }
    if (![Helper justNickname:_nameTextField.text]) {
        [MBProgressHUD showError:@"请输入正确的姓名"];
        return;
    }
    [MBProgressHUD showMessage:@"请稍候"];
    [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"UserApi",@"user_recomment"] params:@{@"mobile":_mobileTextField.text,@"group_id":@"3"} success:^(id json) {
        @try {
            [MBProgressHUD hideHUD];
            NSString *dataStr = [NSString stringWithFormat:@"%@",json[@"data"]];
            if ([dataStr isEqualToString:@"0"]) {
                [MBProgressHUD showError:json[@"info"]];
                return ;
            } else if ([dataStr isEqualToString:@"1"]) {
                [MBProgressHUD showSuccess:json[@"info"]];
            } else {
                [MBProgressHUD showError:@"网络错误"];
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络错误，请重试"];
    }];
}

- (void)sendSMS
{
    // 【码尚通】［码尚通］（邀请人姓名）邀请您加入码尚通司机，让我们低碳出行，绿色生活！赶快点击加入吧，（www.51mast.com）.退订回复TD
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"码尚通" forKey:@"name"];
    [params setValue:@"码尚通" forKey:@"sign"];
    [params setValue:@"6C572C72EE1CA257886E65C7E5F3" forKey:@"pwd"];
    [params setValue:[NSString stringWithFormat:@"（%@）邀请您加入码尚通司机，让我们低碳出行，绿色生活！赶快点击加入吧，（）退订回复TD",_nameTextField.text] forKey:@"content"];
    [params setValue:@"18752008629" forKey:@"mobile"];
    [params setValue:@"pt" forKey:@"type"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:@"http://sms.1xinxi.cn/asmx/smsservice.aspx" parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUD];
        NYLog(@"%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        [MBProgressHUD showSuccess:@"短信发送成功"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

@end
