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
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@end

@implementation ModefiedViewController

- (void)setNavigationBar
{
//    self.navigationItem.title = @"修改账单";
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:21],NSForegroundColorAttributeName:RGBColor(73, 185, 254, 1.f)}];

    UILabel *navTitleLabel = [[UILabel alloc] init];
    navTitleLabel.size = CGSizeMake(200, 22);
    navTitleLabel.font = [UIFont systemFontOfSize:21];
    navTitleLabel.text = @"修改账单";
    navTitleLabel.textColor = RGBColor(73, 185, 254, 1.f);
    navTitleLabel.textAlignment = 1;
    self.navigationItem.titleView = navTitleLabel;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.size = CGSizeMake(66, 44);
    [btn setTitle:@"清除修改" forState:UIControlStateNormal];
    [btn setTitleColor:RGBColor(180, 180, 180, 1.f) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn addTarget:self action:@selector(clearBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
//    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [leftBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
//    [leftBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    leftBtn.size = CGSizeMake(44, 44);
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
}

- (void)backBtnClicked:(UIButton *)btn
{
    [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
}

- (void)initCoverView
{
    NSArray *titleArr = @[@"高速费",@"路桥费",@"停车费",@"其他费用"];
    for (NSInteger i = 0; i < 4; i++) {
        NYChangePriceView *change = [[NYChangePriceView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_nightDrivePriceLabel.frame)+45*(i+1), SCREEN_WIDTH, 45) title:titleArr[i]];
        change.tag = 1000+i;
        [self.view addSubview:change];
    }
    
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
    _confirmBgView.size = CGSizeMake(220, 170);
    _confirmBgView.center = CGPointMake(SCREEN_WIDTH/2, self.view.centerY-64);
    _confirmBgView.layer.cornerRadius = 10.f;
    [self.view addSubview:_confirmBgView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"appointment"]];
    imageView.size = CGSizeMake(45, 45);
    imageView.x = 110-45/2;
    imageView.y = 23;
    [_confirmBgView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(imageView.frame)+8, _confirmBgView.width-20, 44)];
    label.text = @"请您确认费用无误，并且提示乘客先付款后下车";
    label.textColor = RGBColor(78, 78, 78, 1.f);
    label.font = [UIFont systemFontOfSize:11];
    label.textAlignment = 1;
    label.numberOfLines = 0;
    [_confirmBgView addSubview:label];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [leftBtn setTitleColor:RGBColor(146, 146, 146, 1.f) forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    leftBtn.layer.borderColor = RGBColor(146, 146, 146, 1.f).CGColor;
    leftBtn.layer.borderWidth = 1.f;
    leftBtn.frame = CGRectMake(22, CGRectGetMaxY(label.frame)+12, 80, 22);
    [leftBtn addTarget:self action:@selector(appointmentLeftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.layer.cornerRadius = 5;
    [_confirmBgView addSubview:leftBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.tag = 200;
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn setBackgroundColor:RGBColor(84, 175, 255, 1.f)];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    rightBtn.frame = CGRectMake(120, CGRectGetMaxY(label.frame)+12, 80, 22);
    [rightBtn addTarget:self action:@selector(appointmentRightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.layer.cornerRadius = 5;
    [_confirmBgView addSubview:rightBtn];
    
    _confirmBgView.hidden = YES;
}

- (void)handleTheWeidget
{
    self.confirmBtn.layer.cornerRadius = 5;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBar];
    [self handleTheWeidget];
    [self configPrice];
    [self initCoverView];
    [self configConfirmView];
}

- (void)configPrice
{
    [MBProgressHUD showMessage:@"请稍候"];
    [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"OrderApi",@"check_bill"] params:@{@"route_id":_model.route_id} success:^(id json) {

        @try {
            [MBProgressHUD hideHUD];
            NSString *dataStr = [NSString stringWithFormat:@"%@",json[@"data"]];
            if ([dataStr isEqualToString:@"1"]) {
                self.priceModel = [[ActualPriceModel alloc] initWithDictionary:json[@"info"] error:nil];
                _priceLabel.text = [NSString stringWithFormat:@"%.0f元",[self.priceModel.total_price floatValue]];
                _stepLabel.text = [NSString stringWithFormat:@"%.2f元",[self.priceModel.start_price floatValue]];
                _distanceLabel.text = [NSString stringWithFormat:@"里程%.2fkm",[self.priceModel.mileage floatValue]];
                _distancePriceLabel.text = [NSString stringWithFormat:@"%.2f元",[self.priceModel.mileage_price floatValue]*1.5];
                _lowSpeedTimeLabel.text = [NSString stringWithFormat:@"低速%.2f分钟",[self.priceModel.low_time floatValue]/60];
                _lowSpeedPriceLabel.text = [NSString stringWithFormat:@"%.2f元",[self.priceModel.low_price floatValue]];
                _longMileagePriceLabel.text = [NSString stringWithFormat:@"%.2f元",[self.priceModel.far_price floatValue]];
                _nightDrivePriceLabel.text = [NSString stringWithFormat:@"%.2f元",[self.priceModel.night_price floatValue]];
            } else {
                [self configPrice];
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        NYLog(@"%@",error.localizedDescription);
    }];
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
    [MBProgressHUD showMessage:@"请稍候"];
    
    NSMutableArray *tempArr = [NSMutableArray array];
    for (NSInteger i = 0; i < 4; i++) {
        NYChangePriceView *change = (NYChangePriceView *)[self.view viewWithTag:1000+i];
        if (change.price == 0) {
            continue;
        }
        [tempArr addObject:[NSString stringWithFormat:@"%li",change.price]];
    }
    NYLog(@"%@",tempArr);
    
    if (tempArr.count == 0) {
        [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"OrderApi",@"boarding"] params:@{@"route_id":_model.route_id,@"route_status":@"5"} success:^(id json) {
            @try {
                NSString *resultStr = [NSString stringWithFormat:@"%@",json[@"result"]];
                [MBProgressHUD hideHUD];
                if ([resultStr isEqualToString:@"1"]) {
                    [MBProgressHUD showSuccess:@"确认成功"];
                    
                    WaitForPayViewController *waitForPay = [[WaitForPayViewController alloc] init];
                    waitForPay.model = self.model;
                    waitForPay.price = [_priceLabel.text substringToIndex:_priceLabel.text.length-1];
                    [self.navigationController pushViewController:waitForPay animated:YES];
                } else {
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showError:@"请重新确认价格"];
                }
            }
            @catch (NSException *exception) {
                
            }
            @finally {
                
            }
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"请重新确认价格"];
        }];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (tempArr[0]) {
        [params setValue:tempArr[0] forKey:@"highway_fee"];
    }
    if (tempArr[1]) {
        [params setValue:tempArr[1] forKey:@"road_roll"];
    }
    if (tempArr[2]) {
        [params setValue:tempArr[2] forKey:@"parking_fee"];
    }
    if (tempArr[3]) {
        [params setValue:tempArr[3] forKey:@"other_fee"];
    }
    [params setValue:_model.route_id forKey:@"route_id"];
    [params setValue:@"5" forKey:@"route_status"];
    
    [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"OrderApi",@"update_bill"] params:params success:^(id json) {
        @try {
            NYLog(@"%@",json);
            [MBProgressHUD hideHUD];
            NSString *dataStr = [NSString stringWithFormat:@"%@",json[@"data"]];
            if ([dataStr isEqualToString:@"0"]) {
                [MBProgressHUD showError:json[@"info"]];
                return ;
            } else {
                WaitForPayViewController *waitForPay = [[WaitForPayViewController alloc] init];
                waitForPay.model = self.model;
                waitForPay.price = [NSString stringWithFormat:@"%@",json[@"info"]];
                [self.navigationController pushViewController:waitForPay animated:YES];
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        NYLog(@"%@",error.localizedDescription);
    }];
}

#pragma mark - Action
- (void)clearBtnClicked
{
    for (NSInteger i = 0; i < 4; i++) {
        NYChangePriceView *change = (NYChangePriceView *)[self.view viewWithTag:1000+i];
        [change changePrice:0];
    }
}

- (IBAction)waitForPayBtnClicked:(id)sender {
    _coverView.hidden = NO;
    _confirmBgView.hidden = NO;
}
@end
