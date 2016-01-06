//
//  PickUpPassengerViewController.m
//  MaShangTong-Driver
//
//  Created by NY on 15/11/18.
//  Copyright © 2015年 jeaner. All rights reserved.
//

#import "PickUpPassengerViewController.h"
#import "SharedMapView.h"
#import "NavPointAnnotation.h"
#import "DriverCalloutAnnotation.h"
#import "DriverCalloutAnnotationView.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import "MANaviRoute.h"
#import "iflyMSC/IFlySpeechConstant.h"
#import "iflyMSC/IFlySpeechSynthesizer.h"
#import "iflyMSC/IFlySpeechSynthesizerDelegate.h"
#import "ModefiedViewController.h"
#import "ActualPriceModel.h"
#import "InputViewController.h"

@interface PickUpPassengerViewController () <MAMapViewDelegate,AMapNaviManagerDelegate,AMapSearchDelegate,AMapNaviViewControllerDelegate>
{
    BOOL _isLocationSuccess;
    AMapSearchAPI *_search;
    BOOL _isShowNavigation;
    BOOL _isCalculateStart;
    UILabel *distanceLabel; // 乘客上车后，车行驶距离
    UILabel *speedLabel;    // 乘客上车后，汽车的行驶速度
    NSString *price;
    
    UILabel *priceLabel;
    
    ActualPriceModel *actualPriceModel;
}
@property (nonatomic, strong) MAPolyline *polyline;
@property (nonatomic,strong) DriverCalloutAnnotation *diverAnnotation;
@property (nonatomic,strong) MAUserLocation *driverAnnotation;
@property (nonatomic) MANaviRoute * naviRoute;
@property (nonatomic,assign) NSInteger driveringTime;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) float distance;
@property (nonatomic,assign) NSInteger buttonState;
@property (nonatomic,strong) UIView *coverView;
@property (nonatomic,strong) UIView *appointBgView;
@property (nonatomic,strong) UIButton *confirmBtn;
@property (nonatomic,strong) UIView *billingBgView;
@property (nonatomic,strong) UIView *bottomBgView;
@property (nonatomic,strong) UIView *chargingBgView;

@property (nonatomic, strong) AMapNaviViewController *naviViewController;

@property (nonatomic, strong) AMapNaviPoint* startPoint;
@property (nonatomic, strong) AMapNaviPoint* endPoint;
@property (nonatomic,assign) NSInteger driverDistance;
// 用户定位
@property (nonatomic,strong) MAUserLocation *userLocation;

@end

@implementation PickUpPassengerViewController

- (void)initNaviRoute
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    AMapNaviPoint *startPoint = [AMapNaviPoint locationWithLatitude:delegate.driverCoordinate.latitude longitude:delegate.driverCoordinate.longitude];
    AMapNaviPoint *endPoint = [AMapNaviPoint locationWithLatitude:[[_model.origin_coordinates componentsSeparatedByString:@","][1] floatValue] longitude:[[_model.origin_coordinates componentsSeparatedByString:@","][0] floatValue]];
    
    NSArray *startPoints = @[startPoint];
    NSArray *endPoints   = @[endPoint];
    
    [self.naviManager calculateDriveRouteWithStartPoints:startPoints endPoints:endPoints wayPoints:nil drivingStrategy:0];
}

- (void)configPriginAndEndRoute
{
    AMapNaviPoint *startPoint = [AMapNaviPoint locationWithLatitude:[[_model.origin_coordinates componentsSeparatedByString:@","][1] floatValue] longitude:[[_model.origin_coordinates componentsSeparatedByString:@","][0] floatValue]];
    AMapNaviPoint *endPoint = [AMapNaviPoint locationWithLatitude:[[_model.end_coordinates componentsSeparatedByString:@","][1] floatValue] longitude:[[_model.end_coordinates componentsSeparatedByString:@","][0] floatValue]];
    
    NSArray *startPoints = @[startPoint];
    NSArray *endPoints   = @[endPoint];
    
    [self.naviManager calculateDriveRouteWithStartPoints:startPoints endPoints:endPoints wayPoints:nil drivingStrategy:0];
}

- (void)configNavBar
{
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    self.navigationItem.title = @"去接乘客";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:21],NSForegroundColorAttributeName:RGBColor(73, 185, 254, 1.f)}];
}

- (void)initPassengerView
{
    UIView *passengerBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    passengerBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:passengerBgView];
    
    UIImageView *sourceImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    sourceImageView.frame = CGRectMake(40, 8, 15, 15);
    [passengerBgView addSubview:sourceImageView];
    UILabel *sourceLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, SCREEN_WIDTH-80-60 , 30)];
    sourceLabel.text = _model.origin_name;
    sourceLabel.textAlignment = 0;
    sourceLabel.textColor = RGBColor(149, 149, 149, 1.f);
    sourceLabel.font = [UIFont systemFontOfSize:14];
    [passengerBgView addSubview:sourceLabel];
    
    UIImageView *destinationImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    destinationImageView.frame = CGRectMake(40, 38, 15, 15);
    [passengerBgView addSubview:destinationImageView];
    UILabel *destinationLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 30, SCREEN_WIDTH-80-60, 30)];
    destinationLabel.text = _model.end_name;
    destinationLabel.textAlignment = 0;
    destinationLabel.textColor = RGBColor(149, 149, 149, 1.f);
    destinationLabel.font = [UIFont systemFontOfSize:14];
    [passengerBgView addSubview:destinationLabel];
    
    UIImageView *telImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dail"]];
    telImageView.frame = CGRectMake(SCREEN_WIDTH-70, 10, 45, 45);
    [passengerBgView addSubview:telImageView];
    UITapGestureRecognizer *telGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(telGesture:)];
    telImageView.userInteractionEnabled = YES;
    [telImageView addGestureRecognizer:telGesture];
}

- (void)initPassengerLocation
{
    NavPointAnnotation *passengerLocation = [[NavPointAnnotation alloc] init];
    [passengerLocation setCoordinate:CLLocationCoordinate2DMake([[_model.origin_coordinates componentsSeparatedByString:@","][1] floatValue], [[_model.origin_coordinates componentsSeparatedByString:@","][0] floatValue])];
    passengerLocation.navPointType = NavPointAnnotationStart;
    passengerLocation.title = @"乘客位置";
    [self.mapView addAnnotation:passengerLocation];
}

- (void)initBottomView
{
    _bottomBgView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-64-55, SCREEN_WIDTH, 55)];
    _bottomBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomBgView];
    
    _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_confirmBtn setTitle:@"到达约定地点" forState:UIControlStateNormal];
    [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_confirmBtn setBackgroundColor:RGBColor(84, 175, 255, 1.f)];
    [_confirmBtn addTarget:self action:@selector(bottomBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    _confirmBtn.size = CGSizeMake(150, 30);
    _confirmBtn.center = _bottomBgView.center;
    _confirmBtn.layer.cornerRadius = 3.f;
    [self.view addSubview:_confirmBtn];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.mapView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    [self.view sendSubviewToBack:self.mapView];
    self.mapView.showsUserLocation = YES;
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [self.mapView setCenterCoordinate:delegate.driverCoordinate];
    [self.mapView setZoomLevel:14 animated:YES];
    
    [_timer setFireDate:[NSDate distantPast]];
}

- (void)initCoverView
{
    _coverView = [[UIView alloc] initWithFrame:self.view.bounds];
    _coverView.backgroundColor = [UIColor blackColor];
    _coverView.alpha = 0.3;
    [self.view addSubview:_coverView];
    _coverView.hidden = YES;
}

- (void)initAppointmenetBgView
{   // 440*360
    _appointBgView = [[UIView alloc] init];
    _appointBgView.backgroundColor = [UIColor whiteColor];
    _appointBgView.size = CGSizeMake(220, 180);
    _appointBgView.center = CGPointMake(self.view.centerX, self.view.centerY-64);
    [self.view addSubview:_appointBgView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"appointment"]];
    imageView.size = CGSizeMake(45, 45);
    imageView.x = 110-45/2;
    imageView.y = 23;
    [_appointBgView addSubview:imageView];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+8, _appointBgView.width, 11)];
    label1.text = @"你确定已到约定地点了吗？";
    label1.textColor = RGBColor(78, 78, 78, 1.f);
    label1.font = [UIFont systemFontOfSize:14];
    label1.textAlignment = 1;
    [_appointBgView addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label1.frame)+5, _appointBgView.width, 8)];
    label2.text = @"未到达约定地点会有被投诉危险";
    label2.textAlignment = 1;
    label2.textColor = RGBColor(180, 180, 180, 1.f);
    label2.font = [UIFont systemFontOfSize:10];
    [_appointBgView addSubview:label2];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [leftBtn setTitleColor:RGBColor(146, 146, 146, 1.f) forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    leftBtn.layer.borderColor = RGBColor(146, 146, 146, 1.f).CGColor;
    leftBtn.layer.borderWidth = 1.f;
    leftBtn.frame = CGRectMake(22, CGRectGetMaxY(label2.frame)+32, 80, 22);
    [leftBtn addTarget:self action:@selector(appointmentLeftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_appointBgView addSubview:leftBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn setBackgroundColor:RGBColor(84, 175, 255, 1.f)];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    rightBtn.frame = CGRectMake(120, CGRectGetMaxY(label2.frame)+32, 80, 22);
    [rightBtn addTarget:self action:@selector(appointmentRightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_appointBgView addSubview:rightBtn];
    
    _appointBgView.hidden = YES;
}

- (void)initBillingBgView
{
    _billingBgView = [[UIView alloc] init];
    _billingBgView.backgroundColor = [UIColor whiteColor];
    _billingBgView.size = CGSizeMake(220, 160);
    _billingBgView.center = CGPointMake(SCREEN_WIDTH/2, self.view.centerY-64);
    [self.view addSubview:_billingBgView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"appointment"]];
    imageView.size = CGSizeMake(45, 45);
    imageView.x = 110-45/2;
    imageView.y = 23;
    [_billingBgView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+8, _billingBgView.width, 11)];
    label.text = @"您确定乘客已经上车，开始计费吗？";
    label.textColor = RGBColor(78, 78, 78, 1.f);
    label.font = [UIFont systemFontOfSize:13];
    label.textAlignment = 1;
    [_billingBgView addSubview:label];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [leftBtn setTitleColor:RGBColor(146, 146, 146, 1.f) forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    leftBtn.layer.borderColor = RGBColor(146, 146, 146, 1.f).CGColor;
    leftBtn.layer.borderWidth = 1.f;
    leftBtn.frame = CGRectMake(22, CGRectGetMaxY(label.frame)+32, 80, 22);
    leftBtn.tag = 300;
    [leftBtn addTarget:self action:@selector(billingLeftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_billingBgView addSubview:leftBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.tag = 200;
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn setBackgroundColor:RGBColor(84, 175, 255, 1.f)];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    rightBtn.frame = CGRectMake(120, CGRectGetMaxY(label.frame)+32, 80, 22);
    [rightBtn addTarget:self action:@selector(billingRightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_billingBgView addSubview:rightBtn];
    
    _billingBgView.hidden = YES;
}

- (void)initChargingBgView
{
    _chargingBgView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-64-95, SCREEN_WIDTH, 95)];
    _chargingBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_chargingBgView];
    
    priceLabel = [[UILabel alloc] init];
    priceLabel.text = @"   元";
    priceLabel.frame = CGRectMake(106, 0, 80, 40);
    priceLabel.font = [UIFont systemFontOfSize:13];
    [_chargingBgView addSubview:priceLabel];
    
    distanceLabel = [[UILabel alloc] init];
    distanceLabel.text = @"里程0公里";
    distanceLabel.textAlignment = 0;
    distanceLabel.textColor = RGBColor(131, 131, 131, 1.f);
    distanceLabel.font = [UIFont systemFontOfSize:11];
    distanceLabel.frame = CGRectMake(CGRectGetMaxX(priceLabel.frame), priceLabel.y, 200, 20);
    [_chargingBgView addSubview:distanceLabel];
    
    speedLabel = [[UILabel alloc] init];
    speedLabel.text = @"低速0分钟";
    speedLabel.textAlignment = 0;
    speedLabel.textColor = RGBColor(131, 131, 131, 1.f);
    speedLabel.font = [UIFont systemFontOfSize:11];
    speedLabel.frame = CGRectMake(CGRectGetMaxX(priceLabel.frame), CGRectGetMaxY(distanceLabel.frame), distanceLabel.width, distanceLabel.height);
    [_chargingBgView addSubview:speedLabel];
    
    UIButton *chargingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [chargingBtn setTitle:@"结束计费" forState:UIControlStateNormal];
    chargingBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [chargingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [chargingBtn setBackgroundColor:RGBColor(84, 175, 255, 1.f)];
    chargingBtn.size = CGSizeMake(150, 30);
    chargingBtn.center = CGPointMake(_chargingBgView.centerX, 65);
    [chargingBtn addTarget:self action:@selector(chargingBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [_chargingBgView addSubview:chargingBtn];
    chargingBtn.layer.cornerRadius = 3.f;
    
    _chargingBgView.hidden = YES;
}

- (void)initScatteredView
{
    UIImageView *locationImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dingweizhongxin"]];
    locationImageView.backgroundColor = [UIColor whiteColor];
    locationImageView.contentMode = UIViewContentModeCenter;
    [self.view addSubview:locationImageView];
    [locationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(12);
        make.bottom.equalTo(_chargingBgView.mas_top).offset(-62);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    UITapGestureRecognizer *locationGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(locationControl)];
    locationImageView.userInteractionEnabled = YES;
    [locationImageView addGestureRecognizer:locationGesture];
    
    UIImageView *changeEndingImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zhongdianxiugai"]];
    changeEndingImageView.backgroundColor = [UIColor whiteColor];
    changeEndingImageView.contentMode = UIViewContentModeCenter;
    [self.view addSubview:changeEndingImageView];
    [changeEndingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_chargingBgView.mas_top).offset(-95);
        make.right.equalTo(self.view).offset(-12);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    UITapGestureRecognizer *changeEndingGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeEndingControl)];
    changeEndingImageView.userInteractionEnabled = YES;
    [changeEndingImageView addGestureRecognizer:changeEndingGesture];
    
    UIImageView *navigationImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navigation"]];
    navigationImageView.backgroundColor = [UIColor whiteColor];
    navigationImageView.contentMode = UIViewContentModeCenter;
    [self.view addSubview:navigationImageView];
    [navigationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(changeEndingImageView);
        make.bottom.equalTo(changeEndingImageView.mas_top).offset(-12);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    UITapGestureRecognizer *navigationGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(navigationControl)];
    navigationImageView.userInteractionEnabled = YES;
    [navigationImageView addGestureRecognizer:navigationGesture];
    
    UIImageView *roadConditionImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lukuang"]];
    roadConditionImageView.backgroundColor = [UIColor whiteColor];
    roadConditionImageView.contentMode = UIViewContentModeCenter;
    [self.view addSubview:roadConditionImageView];
    [roadConditionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(changeEndingImageView);
        make.bottom.equalTo(navigationImageView.mas_top).offset(-12);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    UITapGestureRecognizer *roadConditionGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(roadConditionControl)];
    roadConditionImageView.userInteractionEnabled = YES;
    [roadConditionImageView addGestureRecognizer:roadConditionGesture];
}

- (void)initNaviViewController
{
    if (_naviViewController == nil)
    {
        _naviViewController = [[AMapNaviViewController alloc] initWithMapView:self.mapView delegate:self];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_timer setFireDate:[NSDate distantFuture]];
    [self clearMapView];
}

#pragma mark - ViewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    _isLocationSuccess = NO;
    _buttonState = 0;
    _isShowNavigation = 0;
    _isCalculateStart = 0;
    [self configNavBar];
    [self initNaviRoute];
    [self initPassengerLocation];
    [self initDriveringTime];
    [self initNaviViewController];
    [self initPassengerView];
    [self initBottomView];
    [self initChargingBgView];
    [self initScatteredView];
    [self initCoverView];
    [self initBillingBgView];
    [self initAppointmenetBgView];
}

- (void)initDriveringTime
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(calculateTimeAndDistance) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:UITrackingRunLoopMode];
        _driveringTime = 0;
    }
}

- (void)calculateTimeAndDistance
{
    _driveringTime++;
    AMapDrivingRouteSearchRequest *request = [[AMapDrivingRouteSearchRequest alloc] init];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    request.origin = [AMapGeoPoint locationWithLatitude:delegate.driverCoordinate.latitude longitude:delegate.driverCoordinate.longitude];
    request.destination = [AMapGeoPoint locationWithLatitude:[[_model.origin_coordinates componentsSeparatedByString:@","][1] floatValue] longitude:[[_model.origin_coordinates componentsSeparatedByString:@","][0] floatValue]];
    request.strategy = 0;//结合交通实际情况
    request.requireExtension = YES;
    if (!_search) {
        _search = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
    }
    [_search AMapDrivingRouteSearch:request];
    
    for (id ann in self.mapView.annotations) {
        if ([ann isKindOfClass:[MAUserLocation class]]) {
            MAUserLocation *userLocation = (MAUserLocation *)ann;
            NSString *annTitle = [NSString stringWithFormat:@"剩余%.2f公里 已行驶%ld:%ld",((float)_distance)/1000,(long)_driveringTime/60,(long)_driveringTime%60];
            userLocation.title = annTitle;
        }
    }
    
    CLLocationSpeed speed = _userLocation.location.speed;
//    NYLog(@"%f",speed);
    if (speed == -1) {
        speed = 0;
    }
    if (_isCalculateStart) {
        NSString *isLowSpeed = @"0";
        if (speed <= 3.4) {
            isLowSpeed = @"1";
        }
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:[NSString stringWithFormat:@"%.0f",speed] forKey:@"distance"];
        [params setValue:_model.route_id forKey:@"route_id"];
        [params setValue:@"3" forKey:@"route_status"];
        [params setValue:isLowSpeed forKey:@"time"];
        
        [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"OrderApi",@"speed_price"] params:params success:^(id json) {
            @try {
                NYLog(@"%@",json);
                if (!json) {
                    return ;
                }
                actualPriceModel = [[ActualPriceModel alloc] initWithDictionary:json[@"info"] error:nil];
                distanceLabel.text = [NSString stringWithFormat:@"里程%.2f公里",[actualPriceModel.mileage floatValue]];
                speedLabel.text = [NSString stringWithFormat:@"低速%li分钟",(long)[actualPriceModel.low_time integerValue]];
                price = [NSString stringWithFormat:@"%.2f",[actualPriceModel.total_price floatValue]];
                NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:price];
                [attri addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:22],NSForegroundColorAttributeName : RGBColor(44, 44, 44, 1.f)} range:NSMakeRange(0, price.length)];
                priceLabel.attributedText = attri;
            }
            @catch (NSException *exception) {
                
            }
            @finally {
                
            }
        } failure:^(NSError *error) {
            //                NYLog(@"%@",error.localizedDescription);
        }];
    }
}

- (void)calculatePassengerRoute
{
    NSArray *startPoints = @[_startPoint];
    NSArray *endPoints   = @[_endPoint];
    
    [self.naviManager calculateDriveRouteWithStartPoints:startPoints endPoints:endPoints wayPoints:nil drivingStrategy:0];
}

#pragma mark - MAMapViewDelegate
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.driverCoordinate = userLocation.coordinate;
    _userLocation = userLocation;
    
    if(updatingLocation) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                _isLocationSuccess = YES;
                MACoordinateRegion region = MACoordinateRegionMake(CLLocationCoordinate2DMake(userLocation.coordinate.latitude,userLocation.coordinate.longitude), MACoordinateSpanMake(.0025f,.0025f));
                [self.mapView setRegion:region animated:YES];
                
                MAMapRect rect = MAMapRectForCoordinateRegion(region);
                [self.mapView setVisibleMapRect:rect animated:YES];
            });
        });
        NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
        NSString *locationStr = [NSString stringWithFormat:@"%f,%f",userLocation.coordinate.longitude,userLocation.coordinate.latitude];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:userId forKey:@"user_id"];
        [params setValue:locationStr forKey:@"location"];
        [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"OrderApi",@"dri_address"] params:params success:^(id json) {
        } failure:^(NSError *error) {
        }];
    }
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    NSLog(@"%@",[annotation class]);
    if ([annotation isKindOfClass:[MAUserLocation class]]) {
        static NSString *anIde = @"PointAnnotation";
        MAAnnotationView *view = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:anIde];
        if (!view) {
            view = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:anIde];
            view.image = [UIImage imageNamed:@"sijidingwei"];
            view.draggable = YES;
            view.canShowCallout = YES;
            view.centerOffset = CGPointMake(0, 0);
            view.selected = YES;
        }
        MAUserLocation *ann = (MAUserLocation *)view.annotation;
        _driverAnnotation = ann;
        ann.title = @"剩余00.00km 已行驶00:00";
        return view;
    }
    else {
        static NSString *anIde = @"NaviAnnotation";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:anIde];
        if (!annotationView) {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:anIde];
            annotationView.centerOffset = CGPointMake(0, 0);
            annotationView.canShowCallout = YES;
        }
        annotationView.image = [UIImage imageNamed:@"dingwei"];
        annotationView.animatesDrop = YES;
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    id annotation = view.annotation;
    if ([annotation isKindOfClass:[MAUserLocation class]]) {
        NYLog(@"%@",annotation);
    }
}

#pragma mark - AMapNaviManagerDelegate
- (void)naviManager:(AMapNaviManager *)naviManager onCalculateRouteFailure:(NSError *)error
{
    NYLog(@"%@",error.localizedDescription);
    [MBProgressHUD showError:@"路径规划失败"];
}

- (void)naviManagerOnCalculateRouteSuccess:(AMapNaviManager *)naviManager
{
    if (_isShowNavigation) {
        [self.naviManager presentNaviViewController:self.naviViewController animated:YES];
    } else {
        [self showRouteWithNaviRoute:[[naviManager naviRoute] copy]];
    }
}

- (void)showRouteWithNaviRoute:(AMapNaviRoute *)naviRoute
{
    if (naviRoute == nil)
    {
        return;
    }
    if (_polyline)
    {
        [self.mapView removeOverlay:_polyline];
        self.polyline = nil;
    }
    
    NSUInteger coordianteCount = [naviRoute.routeCoordinates count];
    CLLocationCoordinate2D coordinates[coordianteCount];
    for (int i = 0; i < coordianteCount; i++)
    {
        AMapNaviPoint *aCoordinate = [naviRoute.routeCoordinates objectAtIndex:i];
        coordinates[i] = CLLocationCoordinate2DMake(aCoordinate.latitude, aCoordinate.longitude);
    }
    
    _polyline = [MAPolyline polylineWithCoordinates:coordinates count:coordianteCount];
    [self.mapView addOverlay:_polyline];
}

- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineView *polylineView = [[MAPolylineView alloc] initWithPolyline:(MAPolyline *)overlay];
        
        polylineView.lineWidth   = 5.0f;
        polylineView.strokeColor = [UIColor redColor];
        
        return polylineView;
    }
    return nil;
}

#pragma mark - AMapSearchAPIDelegate
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
{
    if(response.route == nil)
    {
        return;
    }
    MANaviAnnotationType type = MANaviAnnotationTypeDrive;
    
    AMapPath *path = response.route.paths[0];
    self.naviRoute = [MANaviRoute naviRouteForPath:path withNaviType:type];
    
    _distance = path.distance;
    
    for (id ann in self.mapView.annotations) {
        if ([ann isKindOfClass:[MAUserLocation class]]) {
            MAUserLocation *userLocation = (MAUserLocation *)ann;
            NSString *annTitle = [NSString stringWithFormat:@"剩余%.2f公里 已行驶%ld:%ld",((float)_distance)/1000,(long)_driveringTime/60,(long)_driveringTime%60];
            userLocation.title = annTitle;
        }
    }
}

#pragma mark - AMapNaviManager Delegate

- (void)naviManager:(AMapNaviManager *)naviManager didPresentNaviViewController:(UIViewController *)naviViewController
{
    [self.naviManager startGPSNavi];
}

#pragma mark - AManNaviViewController Delegate
- (void)naviViewControllerCloseButtonClicked:(AMapNaviViewController *)naviViewController
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self.iFlySpeechSynthesizer stopSpeaking];
    });
    
    [self.naviManager stopNavi];
    _isShowNavigation = 0;
    [self.naviManager dismissNaviViewControllerAnimated:YES];
    
    self.mapView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    [self.view sendSubviewToBack:self.mapView];
    self.mapView.showsUserLocation = YES;
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [self.mapView setCenterCoordinate:delegate.driverCoordinate];
    [self.mapView setZoomLevel:14 animated:YES];
}

- (void)naviViewControllerMoreButtonClicked:(AMapNaviViewController *)naviViewController
{
    if (self.naviViewController.viewShowMode == AMapNaviViewShowModeCarNorthDirection)
    {
        self.naviViewController.viewShowMode = AMapNaviViewShowModeMapNorthDirection;
    }
    else
    {
        self.naviViewController.viewShowMode = AMapNaviViewShowModeCarNorthDirection;
    }
}

- (void)naviViewControllerTurnIndicatorViewTapped:(AMapNaviViewController *)naviViewController
{
    [self.naviManager readNaviInfoManual];
}

#pragma mark - dealloc
- (void)dealloc
{
    [_timer setFireDate:[NSDate distantFuture]];
    [_timer invalidate];
    _timer = nil;
}

#pragma mark - Action
- (void)backBtnClicked:(UIButton *)btn
{
    [_timer setFireDate:[NSDate distantFuture]];
    _timer = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)bottomBtnClicked:(UIButton *)btn
{
    if (_buttonState == 0) {
        
        _appointBgView.hidden = NO;
        _coverView.hidden = NO;
        _buttonState = 1;
        
    } else if (_buttonState == 1) {
        
        _billingBgView.hidden = NO;
        _coverView.hidden = NO;
        _buttonState = 2;
        
    } else if (_buttonState == 2) {
        
        
        
    }
}

// 预约地点
- (void)appointmentLeftBtnClicked:(UIButton *)btn
{
    _appointBgView.hidden = YES;
    _coverView.hidden = YES;
    _buttonState = 0;
}

// 预约地点
- (void)appointmentRightBtnClicked:(UIButton *)btn
{
    [MBProgressHUD showMessage:@"请稍候"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:_model.route_id forKey:@"route_id"];
    
    [params setValue:@"2" forKey:@"route_status"];
    
    [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"OrderApi",@"boarding"] params:params success:^(id json) {
        NSString *resultStr = [NSString stringWithFormat:@"%@",json[@"result"]];
        if ([resultStr isEqualToString:@"1"]) {
            [_confirmBtn setTitle:@"开始计费" forState:UIControlStateNormal];
            _appointBgView.hidden = YES;
            _coverView.hidden = YES;
            _buttonState = 1;
            [MBProgressHUD hideHUD];
            _isCalculateStart = 1;
            return ;
        } else if ([resultStr isEqualToString:@"0"]) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"请重新确认您已到达预约地点"];
            return;
        }
        NSLog(@"%@",json);
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络错误"];
        NSLog(@"%@",error.localizedDescription);
        
    }];
}

// 确定上车
- (void)billingLeftBtnClicked:(UIButton *)btn
{
    _billingBgView.hidden = YES;
    _coverView.hidden = YES;
    _buttonState = 1;
}

// 确定上车
- (void)billingRightBtnClicked:(UIButton *)btn
{
    [MBProgressHUD showMessage:@"请稍候"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:_model.route_id forKey:@"route_id"];
    [params setValue:@"3" forKey:@"route_status"];
    [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"OrderApi",@"boarding"] params:params success:^(id json) {
        
        NSString *resultStr = [NSString stringWithFormat:@"%@",json[@"result"]];
        if ([resultStr isEqualToString:@"1"]) {
            _billingBgView.hidden = YES;
            _coverView.hidden = YES;
            _chargingBgView.hidden = NO;
            _bottomBgView.hidden = YES;
            _buttonState = 2;
            _isCalculateStart = 0;
            [MBProgressHUD hideHUD];
            return ;
        } else if ([resultStr isEqualToString:@"0"]) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"请重新确认开始计费"];
            return ;
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络错误"];
    }];
}

- (void)chargingBtnClicked
{
    [MBProgressHUD showMessage:@"请稍候"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:_model.route_id forKey:@"route_id"];
    [params setValue:@"4" forKey:@"route_status"];
    [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"OrderApi",@"boarding"] params:params success:^(id json) {
        
        NSString *resultStr = [NSString stringWithFormat:@"%@",json[@"result"]];
        if ([resultStr isEqualToString:@"1"]) {
            ModefiedViewController *modefied = [[ModefiedViewController alloc] init];
//            modefied.driverDistance = distanceLabel.text;
//            modefied.price = price;
            modefied.model = self.model;
//            modefied.priceModel = actualPriceModel;
            [_timer setFireDate:[NSDate distantFuture]];
            [self.navigationController pushViewController:modefied animated:YES];
            [MBProgressHUD hideHUD];
            return ;
        } else if ([resultStr isEqualToString:@"0"]) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"请重新确认结束计费"];
            return;
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络错误"];
    }];

}

#pragma mark - UITapGestureRecognizer
- (void)locationControl
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [self.mapView setCenterCoordinate:delegate.driverCoordinate animated:YES];
}

- (void)roadConditionControl
{
    self.mapView.showTraffic = !self.mapView.showTraffic;
}

- (void)navigationControl
{
    _isShowNavigation = 1;
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (_buttonState == 0) {
        
        _startPoint = [AMapNaviPoint locationWithLatitude:delegate.driverCoordinate.latitude longitude:delegate.driverCoordinate.longitude];
        _endPoint = [AMapNaviPoint locationWithLatitude:[[_model.origin_coordinates componentsSeparatedByString:@","][1] floatValue] longitude:[[_model.origin_coordinates componentsSeparatedByString:@","][0] floatValue]];
        
    } else if (_buttonState == 2) {
        
        _startPoint = [AMapNaviPoint locationWithLatitude:[[_model.origin_coordinates componentsSeparatedByString:@","][1] floatValue] longitude:[[_model.origin_coordinates componentsSeparatedByString:@","][0] floatValue]];
        _endPoint = [AMapNaviPoint locationWithLatitude:[[_model.end_coordinates componentsSeparatedByString:@","][1] floatValue] longitude:[[_model.end_coordinates componentsSeparatedByString:@","][0] floatValue]];
    }
    [self calculatePassengerRoute];
}

- (void)changeEndingControl
{
    InputViewController *input = [[InputViewController alloc] init];
    input.changeDestination = ^(AMapTip *p){
        [MBProgressHUD showMessage:@"重点修改中，请稍候"];
        NSString *endCoordinates = [NSString stringWithFormat:@"%f,%f",p.location.latitude,p.location.longitude];
        [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"orderApi",@"destination"] params:@{@"route_id":_model.route_id,@"end_name":p.name,@"end_coordinates":endCoordinates} success:^(id json) {
            [MBProgressHUD hideHUD];
            NSString *dataStr = [NSString stringWithFormat:@"%@",json[@"data"]];
            if ([dataStr isEqualToString:@"0"]) {
                [MBProgressHUD showError:json[@"info"]];
                
                AMapNaviPoint *startPoint = [AMapNaviPoint locationWithLatitude:[[_model.origin_coordinates componentsSeparatedByString:@","][1] floatValue] longitude:[[_model.origin_coordinates componentsSeparatedByString:@","][0] floatValue]];
                AMapNaviPoint *endPoint = [AMapNaviPoint locationWithLatitude:p.location.latitude longitude:p.location.longitude];
                NSArray *startPoints = @[startPoint];
                NSArray *endPoints   = @[endPoint];
                
                [self.naviManager calculateDriveRouteWithStartPoints:startPoints endPoints:endPoints wayPoints:nil drivingStrategy:0];
                
                return ;
            } else if ([dataStr isEqualToString:@"1"]) {
                [MBProgressHUD showSuccess:json[@"info"]];
                
                
                
                
            } else {
                [MBProgressHUD showError:@"网络错误"];
            }
            
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"网络错误"];
            NSLog(@"%@",error.localizedDescription);
        }];
    };
    [self presentViewController:input animated:YES completion:nil];
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

@end
