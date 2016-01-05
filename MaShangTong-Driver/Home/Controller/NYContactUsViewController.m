//
//  NYContactUsViewController.m
//  MaShangTong-Personal
//
//  Created by apple on 15/12/23.
//  Copyright © 2015年 jeaner. All rights reserved.
//

#import "NYContactUsViewController.h"

@interface NYContactUsViewController ()

@end

@implementation NYContactUsViewController

- (void)configNavigationBar
{
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBarButtonItemClicked) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.size = CGSizeMake(44, 44);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    self.navigationItem.title = @"联系我们";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:21],NSForegroundColorAttributeName:RGBColor(73, 185, 254, 1.f)}];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configNavigationBar];
    
    self.view.backgroundColor = [UIColor whiteColor];

    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SettingContractUs"]];
    [self.view addSubview:logo];
    [logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(50);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(150, 150));
    }];
    
    /*
     到位网络科技（上海）有限公司
     客服电话：4008-320-518
     邮箱：dw_mast@163.com
     网址：www.51mast.com
     地址：上海市嘉定区江桥镇鹤旋路99号
     */
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"到位网络科技（上海）有限公司";
    nameLabel.textAlignment = 1;
    nameLabel.textColor = RGBColor(123, 123, 123, 1.f);
    nameLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logo.mas_bottom).offset(20);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(28);
    }];
    
    UILabel *telLabel = [[UILabel alloc] init];
    telLabel.text = @"客服电话：4008-320-518";
    telLabel.textAlignment = 1;
    telLabel.textColor = RGBColor(123, 123, 123, 1.f);
    telLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:telLabel];
    [telLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).offset(10);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(28);
    }];
    
    UILabel *emailLabel = [[UILabel alloc] init];
    emailLabel.text = @"邮箱：dw_mast@163.com";
    emailLabel.textAlignment = 1;
    emailLabel.textColor = RGBColor(123, 123, 123, 1.f);
    emailLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:emailLabel];
    [emailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(telLabel.mas_bottom).offset(10);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(28);
    }];
    
    UILabel *webLabel = [[UILabel alloc] init];
    webLabel.text = @"网址：www.51mast.com";
    webLabel.textAlignment = 1;
    webLabel.textColor = RGBColor(123, 123, 123, 1.f);
    webLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:webLabel];
    [webLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(emailLabel.mas_bottom).offset(10);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(28);
    }];
    
    UILabel *addressLabel = [[UILabel alloc] init];
    addressLabel.text = @"地址：上海市嘉定区江桥镇鹤旋路99号";
    addressLabel.textAlignment = 1;
    addressLabel.textColor = RGBColor(123, 123, 123, 1.f);
    addressLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:addressLabel];
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(webLabel.mas_bottom).offset(10);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(28);
    }];
}

- (void)leftBarButtonItemClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end














