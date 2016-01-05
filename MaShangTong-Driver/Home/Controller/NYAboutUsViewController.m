//
//  NYAboutUsViewController.m
//  MaShangTong-Personal
//
//  Created by apple on 15/12/23.
//  Copyright © 2015年 jeaner. All rights reserved.
//

#import "NYAboutUsViewController.h"

@interface NYAboutUsViewController ()

@end

@implementation NYAboutUsViewController

- (void)configNavigationBar
{
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBarButtonItemClicked) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.size = CGSizeMake(44, 44);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    self.navigationItem.title = @"关于我们";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:21],NSForegroundColorAttributeName:RGBColor(73, 185, 254, 1.f)}];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configNavigationBar];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITextView *textView = [[UITextView alloc] init];
    textView.textAlignment = 0;
    textView.textColor = RGBColor(123, 123, 123, 1.f);
    textView.font = [UIFont systemFontOfSize:15];
    textView.text = @"    码尚通资本投资控股有限公司成立于2015年7月，经国家工商总局核准注册，注册资金5000万元，其经营范围主要从事实业投资、资产管理、企业管理、股权投资、金融信息技术与金融外包业务。\n    码尚通资本投资控股有限公司目前旗下控股两家全资子公司即中铁华夏新能源汽车服务（上海）有限公司、到位网络科技（上海）有限公司。\n    中铁华夏新能源汽车服务（上海）有限公司成立于2014年7月，注册资金1000万元，主要经营新能源汽车租赁、销售、维护，新能源汽车加电站设备的建设及服务。  \n    到位网络科技（上海）有限公司成立于2015年7月，注册资金3000万元，主要从事电子商务、新能源汽车网络预约租车接送、机动车驾驶服务。\n    旗下品牌：\n    码尚通—为消费者提供免费新能源汽车接送服务的互联网平台。\n    到  位—专注于高端VIP客户接送解决方案的互联网平台。\n“码尚通”新能源汽车免费接送网络平台：倡导“低碳出行、绿色生活”这一理念，旨在推广新能源汽车及应用为己任，为国家的节能减排做贡献，通过新能源汽车为载体连接人与企业，专注于为企业员工及消费者提供免费的接送服务，为企业降低员工出行成本，获得精准的目标客户及转换率，增强客户忠诚度及黏性度，为企业营销提供精准数据，同时也为消费者提供更多的价值服务。\n    “到位”新能源汽车接送网络平台：专注于为高端商旅VIP客户提供从“舱到门”（即飞机或高铁舱门到客户家门）的一站式接送服务，让高端的商旅人士尊享低碳出行的便捷效率。";
    textView.editable = NO;
    textView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:textView];

    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.bottom.equalTo(self.view).offset(-20);
    }];
}

- (void)leftBarButtonItemClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
