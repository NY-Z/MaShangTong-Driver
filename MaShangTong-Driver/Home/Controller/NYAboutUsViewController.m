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
    textView.text = @"    到位网络科技（上海）有限公司成立于2015年7月，注册资金3000万元，主要从事电子商务、新能源汽车网络预约租车出行、机动车驾驶服务。\n 旗下品牌：\n     码尚通—为消费者免费提供新能源汽车出行服务的互联网平台。\n    到位—专注于高端VIP客户出行解决方案的互联网平台。\n    “码尚通”新能源汽车免费出行服务互联网平台：倡导“低碳出行、绿色生活”这一理念，旨在推广新能源汽车及应用为己任，为国家的节能减排做贡献，通过新能源汽车为载体连接人与企业，专注于为企业员工及消费者提供免费的出行服务，为企业降低员工出行成本，获得精准的目标客户及转换率，增强客户忠诚度及黏性度，为企业营销提供精准数据，同时也为消费者提供更多的价值服务。\n    “码尚通”新能源汽车免费出行服务互联网平台，旨在为企业商户建立闭环式的服务体系，管控营运成本、提高各个环节的工作效率、提升自身服务品质，解决商户永远不知道消费者什么时候到店的被动等待痛点，让商户提前精准知道消费者什么时候到店都尽在掌握。\n    码尚通是国内唯一专注新能源汽车出行服务的互联网平台。\n    码尚通是国内唯一具有碳排放数据量化指标出行服务的互联网平台。\n    “到位”新能源汽车出行网络平台：专注于为高端商旅VIP客户提供从“舱到门”（即飞机或高铁舱门到客户家门）的一站式接送服务，让高端的商旅人士尊享低碳出行的便捷效率。";
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
