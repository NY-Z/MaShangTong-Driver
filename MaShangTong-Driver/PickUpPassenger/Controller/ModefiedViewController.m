//
//  ModefiedViewController.m
//  MaShangTong
//
//  Created by jeaner on 15/11/10.
//  Copyright © 2015年 NY. All rights reserved.
//

#import "ModefiedViewController.h"
#import "WaitForPayViewController.h"
#import "ActualPriceModel.h"
#import "NYChangePriceView.h"

@interface ModefiedViewController () 

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *stepLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (nonatomic,strong) UIView *confirmBgView;
@property (nonatomic,strong) UIView *coverView;
- (IBAction)waitForPayBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *distancePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *lowSpeedTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *lowSpeedPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *longMileagePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *nightDrivePriceLabel;



@end

@implementation ModefiedViewController

- (void)setNavigationBar
{
    self.navigationItem.title = @"修改账单";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:21],NSForegroundColorAttributeName:RGBColor(84, 175, 254, 1.f)}];
    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.size = CGSizeMake(66, 44);
//    [btn setTitle:@"清除修改" forState:UIControlStateNormal];
//    [btn setTitleColor:RGBColor(200, 200, 200, 1.f) forState:UIControlStateNormal];
//    btn.titleLabel.font = [UIFont systemFontOfSize:12];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.size = CGSizeMake(44, 44);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
}

- (void)backBtnClicked:(UIButton *)btn
{
    [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
}

- (void)initCoverView
{
    _coverView = [[UIView alloc] initWithFrame:self.view.bounds];
    _coverView.backgroundColor = [UIColor blackColor];
    _coverView.alpha = 0.3;
    [self.view addSubview:_coverView];
    _coverView.hidden = YES;
}

- (void)configConfirmView
{
    _confirmBgView = [[UIView alloc] init];
    _confirmBgView.backgroundColor = [UIColor whiteColor];
    _confirmBgView.size = CGSizeMake(220, 160);
    _confirmBgView.center = CGPointMake(SCREEN_WIDTH/2, self.view.centerY-64);
    [self.view addSubview:_confirmBgView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"appointment"]];
    imageView.size = CGSizeMake(45, 45);
    imageView.x = 110-45/2;
    imageView.y = 23;
    [_confirmBgView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+8, _confirmBgView.width, 22)];
    label.text = @"请您确认费用无误，并且提示乘客先付款后下车";
    label.textColor = RGBColor(78, 78, 78, 1.f);
    label.font = [UIFont systemFontOfSize:11];
    label.textAlignment = 1;
    [_confirmBgView addSubview:label];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [leftBtn setTitleColor:RGBColor(146, 146, 146, 1.f) forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    leftBtn.layer.borderColor = RGBColor(146, 146, 146, 1.f).CGColor;
    leftBtn.layer.borderWidth = 1.f;
    leftBtn.frame = CGRectMake(22, CGRectGetMaxY(label.frame)+32, 80, 22);
    [leftBtn addTarget:self action:@selector(appointmentLeftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_confirmBgView addSubview:leftBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.tag = 200;
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn setBackgroundColor:RGBColor(84, 175, 255, 1.f)];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    rightBtn.frame = CGRectMake(120, CGRectGetMaxY(label.frame)+32, 80, 22);
    [rightBtn addTarget:self action:@selector(appointmentRightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_confirmBgView addSubview:rightBtn];
    
    _confirmBgView.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBar];
    [self configPrice];
    [self initCoverView];
    [self configConfirmView];
}

- (void)configPrice
{
    _priceLabel.text = [NSString stringWithFormat:@"%.1f元",[self.priceModel.total_price floatValue]];
    _stepLabel.text = [NSString stringWithFormat:@"%@元",self.priceModel.start_price];
    _distanceLabel.text = [NSString stringWithFormat:@"里程%.1fkm",[self.priceModel.mileage floatValue]];
    _distancePriceLabel.text = [NSString stringWithFormat:@"%.1f元",[self.priceModel.mileage_price floatValue]*1.5];
    _lowSpeedTimeLabel.text = [NSString stringWithFormat:@"低速%.1f分钟",[self.priceModel.low_time floatValue]];
    _lowSpeedPriceLabel.text = [NSString stringWithFormat:@"%.1f元",[self.priceModel.low_price floatValue]];
    _longMileagePriceLabel.text = [NSString stringWithFormat:@"%.1f元",[self.priceModel.far_price floatValue]];
    _nightDrivePriceLabel.text = [NSString stringWithFormat:@"%.1f元",[self.priceModel.night_price floatValue]];
    for (NSInteger i = 0; i < 4; i++) {
        NYChangePriceView *change = [[NYChangePriceView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_nightDrivePriceLabel.frame)+45*(i+1), SCREEN_WIDTH, 45)];
        [self.view addSubview:change];
    }
}

#pragma mark - Action
- (void)appointmentLeftBtnClicked:(UIButton *)btn
{
    [_confirmBgView setHidden:YES];
    [_coverView setHidden:YES];
}

- (void)appointmentRightBtnClicked:(UIButton *)btn
{
    [_confirmBgView setHidden:YES];
    [_coverView setHidden:YES];
    
    [DownloadManager post:@"http://112.124.115.81/m.php?m=OrderApi&a=boarding" params:@{@"route_id":_model.route_id,@"route_status":@"5"} success:^(id json) {
        NSString *resultStr = [NSString stringWithFormat:@"%@",json[@"result"]];
        if ([resultStr isEqualToString:@"1"]) {
            WaitForPayViewController *waitForPay = [[WaitForPayViewController alloc] init];
            waitForPay.model = self.model;
            waitForPay.price = _priceLabel.text;
            [self.navigationController pushViewController:waitForPay animated:YES];
        } else {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"请重新确认价格"];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请重新确认价格"];
    }];
}

- (IBAction)waitForPayBtnClicked:(id)sender {
    _coverView.hidden = NO;
    _confirmBgView.hidden = NO;
}
@end
