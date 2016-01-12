//
//  NYDiscoverViewController.m
//  MaShangTong-Driver
//
//  Created by NY on 16/1/12.
//  Copyright © 2016年 NY. All rights reserved.
//

#import "NYDiscoverViewController.h"

@interface NYDiscoverViewController ()

@end

@implementation NYDiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configNavigationBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NAVIGATIONBAR_PROPERTY;
}

- (void)configNavigationBar
{
    self.navigationItem.title = @"发现";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:21],NSForegroundColorAttributeName:RGBColor(73, 185, 254, 1.f)}];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    leftBtn.size = CGSizeMake(22, 22);
    [leftBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
}

- (void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
