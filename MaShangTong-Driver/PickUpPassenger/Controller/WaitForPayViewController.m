//
//  WaitForPayViewController.m
//  MaShangTong-Driver
//
//  Created by NY on 15/11/25.
//  Copyright © 2015年 jeaner. All rights reserved.
//

#import "WaitForPayViewController.h"
#import "HomeDriverViewController.h"

@interface WaitForPayViewController ()
{
    UIButton *restBtn;
    UIButton *getPayBtn;
}
@property (nonatomic,strong) UIView *topBgView;
@property (nonatomic,strong) UILabel *waitForPayLabel;
@property (nonatomic,strong) UILabel *totalPriceLabel;

@end

@implementation WaitForPayViewController
- (void)setNavigationBar
{
    self.navigationItem.title = @"服务中";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:21],NSForegroundColorAttributeName:RGBColor(73, 185, 254, 1.f)}];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.size = CGSizeMake(66, 44);
    [btn setTitle:@"投诉" forState:UIControlStateNormal];
    [btn setTitleColor:RGBColor(200, 200, 200, 1.f) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:0 target:nil action:nil];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:0 target:nil action:nil];
}

- (void)configViews
{
    _topBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    _topBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_topBgView];
    
    UIImageView *sourceImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dingwei2"]];
    sourceImageView.frame = CGRectMake(40, 8, 15, 15);
    [_topBgView addSubview:sourceImageView];
    UILabel *sourceLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, SCREEN_WIDTH-80-60 , 30)];
    sourceLabel.text = _model.origin_name;
    sourceLabel.textAlignment = 0;
    sourceLabel.textColor = RGBColor(149, 149, 149, 1.f);
    sourceLabel.font = [UIFont systemFontOfSize:14];
    [_topBgView addSubview:sourceLabel];
    
    UIImageView *destinationImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dingwei1"]];
    destinationImageView.frame = CGRectMake(40, 38, 15, 15);
    [_topBgView addSubview:destinationImageView];
    UILabel *destinationLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 30, SCREEN_WIDTH-80-60, 30)];
    destinationLabel.text = _model.end_name;
    destinationLabel.textAlignment = 0;
    destinationLabel.textColor = RGBColor(149, 149, 149, 1.f);
    destinationLabel.font = [UIFont systemFontOfSize:14];
    [_topBgView addSubview:destinationLabel];
    
    UIImageView *telImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dail"]];
    telImageView.frame = CGRectMake(SCREEN_WIDTH-70, 10, 45, 45);
    [_topBgView addSubview:telImageView];
    UITapGestureRecognizer *telGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(telGesture:)];
    telImageView.userInteractionEnabled = YES;
    [telImageView addGestureRecognizer:telGesture];
}

- (void)configPriceViews
{
    _waitForPayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 153, SCREEN_WIDTH, 15)];
    _waitForPayLabel.text = @"等待支付";
    _waitForPayLabel.font = [UIFont systemFontOfSize:11];
    _waitForPayLabel.textAlignment = 1;
    _waitForPayLabel.textColor = [UIColor redColor];
    [self.view addSubview:_waitForPayLabel];
    
    _totalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_waitForPayLabel.frame), SCREEN_WIDTH, 32)];
    _totalPriceLabel.text = self.price;
    _totalPriceLabel.textAlignment = 1;
    _totalPriceLabel.textColor = [UIColor blackColor];
    [self.view addSubview:_totalPriceLabel];
    
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_totalPriceLabel.frame), SCREEN_WIDTH, 15)];
    detailLabel.text = @"查看详情";
    detailLabel.textAlignment = 1;
    detailLabel.textColor = RGBColor(123, 123, 123, 1.f);
    detailLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:detailLabel];
    
    restBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [restBtn setTitle:@"休息" forState:UIControlStateNormal];
    [restBtn setTitleColor:RGBColor(123, 123, 123, 1.f) forState:UIControlStateNormal];
    restBtn.enabled = NO;
    restBtn.frame = CGRectMake(30, SCREEN_HEIGHT-27-30-64, 93, 30);
    [self.view addSubview:restBtn];
    restBtn.layer.borderColor = [UIColor blackColor].CGColor;
    [restBtn addTarget:self action:@selector(restBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    restBtn.layer.borderWidth = 1.f;
    
    getPayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [getPayBtn setTitle:@"完成，继续接单" forState:UIControlStateNormal];
    [getPayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [getPayBtn setBackgroundColor:RGBColor(123, 123, 123, 1.f)];
    getPayBtn.enabled = NO;
    getPayBtn.frame = CGRectMake(CGRectGetMaxX(restBtn.frame)+10, SCREEN_HEIGHT-27-30-64, SCREEN_WIDTH-133-30, 32);
    [getPayBtn addTarget:self action:@selector(completeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getPayBtn];
    getPayBtn.layer.cornerRadius = 3.f;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigationBar];
    [self configViews];
    [self configPriceViews];
    [self deductMoney];
}

- (void)deductMoney
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:_model.route_id forKey:@"route_id"];
    
    [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"OrderApi",@"near_cars"] params:params success:^(id json) {
        
        NYLog(@"%@",json);
        NSString *routeStatus = [NSString stringWithFormat:@"%@",json[@"data"][@"route_status"]];
        if ([routeStatus isEqualToString:@"6"]) {
            _waitForPayLabel.text = @"支付完成";
            _waitForPayLabel.textColor = [UIColor blackColor];
            [restBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            restBtn.enabled = YES;
            [getPayBtn setBackgroundColor:RGBColor(99, 190, 255, 1.f)];
            getPayBtn.enabled = YES;
            return;
        }
        else {
            [self deductMoney];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络错误"];
    }];
}

#pragma mark - Gesture
- (void)telGesture:(UITapGestureRecognizer *)tap
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:_model.mobile_phone message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_model.mobile_phone]]];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Action
- (void)restBtnClicked:(UIButton *)btn
{
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[HomeDriverViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}

- (void)completeBtnClicked:(UIButton *)btn
{
    for (UIViewController *vc in self.navigationController.viewControllers) {
    if ([vc isKindOfClass:[HomeDriverViewController class]]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ContinueListenTheOrders" object:nil];
        [self.navigationController popToViewController:vc animated:YES];
    }
}
}

- (void)dealloc
{
    NYLog(@"%s",__FUNCTION__);
}
@end
