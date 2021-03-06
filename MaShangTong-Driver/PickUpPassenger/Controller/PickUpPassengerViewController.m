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
#import "NYCalculateSpecialCarPrice.h"
#import "NYCalculateCharteredBusPrice.h"
#import "InputViewController.h"
#import "HomeDriverViewController.h"

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
    
    CLLocationCoordinate2D lastPoint;//上一秒的坐标经纬度
    CLLocationCoordinate2D nowPoint;//下一秒的坐标经纬度
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
@property (nonatomic,assign) float driverDistance;
// 用户定位
@property (nonatomic,strong) MAUserLocation *userLocation;
// 专车 计价
@property (nonatomic,strong) NYCalculateSpecialCarPrice *calculateSpecialCar;
@property (nonatomic,strong) NYCalculateCharteredBusPrice *calculateCharteredBus;

@end

//重新进入程序后，判断是否已经记录退出前坐标经纬度
static BOOL isHadRecord = NO;
@implementation PickUpPassengerViewController

- (NYCalculateSpecialCarPrice *)calculateSpecialCar
{
    if (_calculateSpecialCar == nil) {
        _calculateSpecialCar = [NYCalculateSpecialCarPrice sharedPrice];
        _calculateSpecialCar.model = _ruleInfoModel;
    }
    return _calculateSpecialCar;
}

- (NYCalculateCharteredBusPrice *)calculateCharteredBus
{
    if (_calculateCharteredBus == nil) {
        _calculateCharteredBus = [NYCalculateCharteredBusPrice shareCharteredBusPrice];
        _calculateCharteredBus.rule = _ruleInfoModel;
    }
    return _calculateCharteredBus;
}
#pragma mark - 路线规划，根据终点
-(void)routePlanWithCllocation:(CLLocation *)location andEndPoint:(NSString *)endPointStr
{
    AMapNaviPoint *startPoint = [AMapNaviPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    AMapNaviPoint *endPoints = [AMapNaviPoint locationWithLatitude:[[endPointStr componentsSeparatedByString:@","][1] floatValue]  longitude:[[endPointStr componentsSeparatedByString:@","][0] floatValue]];
    
    NSArray *startPointAry = @[startPoint];
    NSArray *endPointsAry = @[endPoints];
    
    [self.naviManager calculateDriveRouteWithStartPoints:startPointAry endPoints:endPointsAry wayPoints:nil drivingStrategy:2];
}

- (void)initNaviRoute
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    AMapNaviPoint *startPoint = [AMapNaviPoint locationWithLatitude:delegate.driverCoordinate.latitude longitude:delegate.driverCoordinate.longitude];
    AMapNaviPoint *endPoint = [AMapNaviPoint locationWithLatitude:[[_model.origin_coordinates componentsSeparatedByString:@","][1] floatValue] longitude:[[_model.origin_coordinates componentsSeparatedByString:@","][0] floatValue]];
    
    NSArray *startPoints = @[startPoint];
    NSArray *endPoints   = @[endPoint];
    
    [self.naviManager calculateDriveRouteWithStartPoints:startPoints endPoints:endPoints wayPoints:nil drivingStrategy:2];
}

- (void)configPriginAndEndRoute
{
    AMapNaviPoint *startPoint = [AMapNaviPoint locationWithLatitude:[[_model.origin_coordinates componentsSeparatedByString:@","][1] floatValue] longitude:[[_model.origin_coordinates componentsSeparatedByString:@","][0] floatValue]];
    AMapNaviPoint *endPoint = [AMapNaviPoint locationWithLatitude:[[_model.end_coordinates componentsSeparatedByString:@","][1] floatValue] longitude:[[_model.end_coordinates componentsSeparatedByString:@","][0] floatValue]];
    
    NSArray *startPoints = @[startPoint];
    NSArray *endPoints   = @[endPoint];
    
    [self.naviManager calculateDriveRouteWithStartPoints:startPoints endPoints:endPoints wayPoints:nil drivingStrategy:2];
}

- (void)configNavBar
{
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    UILabel *navTitleLabel = [[UILabel alloc] init];
    navTitleLabel.size = CGSizeMake(200, 22);
    navTitleLabel.font = [UIFont systemFontOfSize:21];
    navTitleLabel.text = @"去接乘客";
    navTitleLabel.textColor = RGBColor(73, 185, 254, 1.f);
    navTitleLabel.textAlignment = 1;
    self.navigationItem.titleView = navTitleLabel;
    
    //    self.navigationItem.title = @"去接乘客";
    //    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:21],NSForegroundColorAttributeName:RGBColor(73, 185, 254, 1.f)}];
}

- (void)initPassengerView
{
    UIView *passengerBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    passengerBgView.backgroundColor = [UIColor whiteColor];
    passengerBgView.tag = 2000;
    passengerBgView.clipsToBounds = YES;
    [self.view addSubview:passengerBgView];
    
    UIImageView *sourceImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dingwei2"]];
    sourceImageView.frame = CGRectMake(40, 8, 15, 15);
    [passengerBgView addSubview:sourceImageView];
    UILabel *sourceLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, SCREEN_WIDTH-80-60 , 30)];
    sourceLabel.text = _model.origin_name;
    sourceLabel.textAlignment = 0;
    sourceLabel.textColor = RGBColor(149, 149, 149, 1.f);
    sourceLabel.font = [UIFont systemFontOfSize:14];
    [passengerBgView addSubview:sourceLabel];
    
    UIImageView *destinationImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dingwei1"]];
    destinationImageView.frame = CGRectMake(40, 38, 15, 15);
    [passengerBgView addSubview:destinationImageView];
    UILabel *destinationLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 30, SCREEN_WIDTH-80-60, 30)];
    destinationLabel.text = _model.end_name;
    destinationLabel.textAlignment = 0;
    destinationLabel.textColor = RGBColor(149, 149, 149, 1.f);
    destinationLabel.font = [UIFont systemFontOfSize:14];
    destinationLabel.tag = 2001;
    [passengerBgView addSubview:destinationLabel];
    
    UIImageView *telImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dail"]];
    telImageView.frame = CGRectMake(SCREEN_WIDTH-70, 10, 45, 45);
    [passengerBgView addSubview:telImageView];
    UITapGestureRecognizer *telGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(telGesture:)];
    telImageView.userInteractionEnabled = YES;
    [telImageView addGestureRecognizer:telGesture];
    
    if (![_model.leave_message isEqualToString:@"请输入备注"] || [_model.leave_message isEqualToString:@""]) {
        UIImageView *pullDownImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gengduo"]];
        pullDownImageView.frame = CGRectMake(SCREEN_WIDTH/2-18, 60, 18, 18);
        [passengerBgView addSubview:pullDownImageView];
        pullDownImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *pullDownTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pullDownTaped:)];
        [pullDownImageView addGestureRecognizer:pullDownTap];
        passengerBgView.height += 18;
        
        NSString *leaveMessage = [NSString stringWithFormat:@"乘客备注：%@",_model.leave_message];
        NSInteger height = [Helper heightOfString:leaveMessage font:[UIFont systemFontOfSize:16] width:SCREEN_WIDTH-100];
        //        passengerBgView.height += (height+6);
        UILabel *leaveMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(telImageView.frame)+12, SCREEN_WIDTH-60, height)];
        pullDownImageView.tag = height;
        leaveMessageLabel.numberOfLines = 0;
        leaveMessageLabel.text = leaveMessage;
        leaveMessageLabel.textAlignment = 0;
        leaveMessageLabel.textColor = RGBColor(128, 128, 128, 1.f);
        leaveMessageLabel.font = [UIFont systemFontOfSize:16];
        [passengerBgView addSubview:leaveMessageLabel];
    }
}

- (void)initPassengerLocation
{
    NavPointAnnotation *passengerLocation = [[NavPointAnnotation alloc] init];
    [passengerLocation setCoordinate:CLLocationCoordinate2DMake([[_model.origin_coordinates componentsSeparatedByString:@","][1] doubleValue], [[_model.origin_coordinates componentsSeparatedByString:@","][0] doubleValue])];
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
    _appointBgView.layer.cornerRadius = 10.f;
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
    leftBtn.layer.cornerRadius = 5.f;
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn setBackgroundColor:RGBColor(84, 175, 255, 1.f)];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    rightBtn.frame = CGRectMake(120, CGRectGetMaxY(label2.frame)+32, 80, 22);
    [rightBtn addTarget:self action:@selector(appointmentRightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_appointBgView addSubview:rightBtn];
    rightBtn.layer.cornerRadius = 5.f;
    
    _appointBgView.hidden = YES;
}

- (void)initBillingBgView
{
    _billingBgView = [[UIView alloc] init];
    _billingBgView.backgroundColor = [UIColor whiteColor];
    _billingBgView.size = CGSizeMake(220, 160);
    _billingBgView.center = CGPointMake(SCREEN_WIDTH/2, self.view.centerY-64);
    _billingBgView.layer.cornerRadius = 10.f;
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
    leftBtn.layer.cornerRadius = 5.f;
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
    rightBtn.layer.cornerRadius = 5.f;
    
    _billingBgView.hidden = YES;
}

- (void)initChargingBgView
{
    _chargingBgView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-64-95, SCREEN_WIDTH, 95)];
    _chargingBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_chargingBgView];
    
    priceLabel = [[UILabel alloc] init];
    priceLabel.text = @"   元";
    priceLabel.frame = CGRectMake(0, 0, 186, 40);
    priceLabel.font = [UIFont systemFontOfSize:13];
    priceLabel.textAlignment = 2;
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
    chargingBtn.layer.cornerRadius = 5.f;
    
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
    
    if (self.ruleInfoModel.rule_type.integerValue == 2) {
        navigationImageView.hidden = YES;
    }
    
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
#pragma mark - 清空上一单的数据
-(void)clearCalculateSpecialCarData{

    self.calculateSpecialCar.distance = 0;
//    self.calculateSpecialCar.price = 0;
    self.calculateSpecialCar.lowSpeedTime = 0;
    self.calculateSpecialCar.lowSpeedPrice = 0;
    self.calculateSpecialCar.longDistance = 0;
    self.calculateSpecialCar.longPrice = 0;
    self.calculateSpecialCar.nightPrice = 0;
}

#pragma mark - ViewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    @autoreleasepool {
        if(self.calculateSpecialCar){
            [self clearCalculateSpecialCarData];
        }
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
        
        [self judgeOrderState];
    }
}
#pragma mark - 判断订单状态
-(void)judgeOrderState
{
    switch ([_model.route_status integerValue]) {
            //已经结单
        case 1:
            
            break;
            //到达约定地点
        case 2:{
            [_confirmBtn setTitle:@"开始计费" forState:UIControlStateNormal];
            _appointBgView.hidden = YES;
            _coverView.hidden = YES;
            _buttonState = 1;
            _isCalculateStart = 0;
        }
            break;
            //开始计费
        case 3:{
            _billingBgView.hidden = YES;
            _coverView.hidden = YES;
            _chargingBgView.hidden = NO;
            _bottomBgView.hidden = YES;
            _buttonState = 2;
            _isCalculateStart = 1;
            
            
        }
            break;
            //结束计费
        case 4:{
            _isCalculateStart = 0;
            ModefiedViewController *modefied = [[ModefiedViewController alloc] init];
            modefied.model = self.model;
            [_timer setFireDate:[NSDate distantFuture]];
            [self.navigationController pushViewController:modefied animated:YES];
        }
            break;
            
        default:
            break;
    }
}
- (void)initDriveringTime
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(calculateTimeAndDistance) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
        _driveringTime = 0;
    }
}

- (void)calculateTimeAndDistance
{
    _driveringTime++;
    if (_driveringTime%14 == 0) {
        AMapDrivingRouteSearchRequest *request = [[AMapDrivingRouteSearchRequest alloc] init];
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        request.origin = [AMapGeoPoint locationWithLatitude:delegate.driverCoordinate.latitude longitude:delegate.driverCoordinate.longitude];
        
        if(!_isCalculateStart){//如果没有开始计费，那么就按照用户的起点坐标规划路线
            request.destination = [AMapGeoPoint locationWithLatitude:[[_model.origin_coordinates componentsSeparatedByString:@","][1] floatValue] longitude:[[_model.origin_coordinates componentsSeparatedByString:@","][0] floatValue]];
        }
        else{//如果开始规划路线了，那么就按照用户的终点坐标规划路线（若修改终点之后，则model的终点坐标是自改后的）
            request.destination = [AMapGeoPoint locationWithLatitude:[[_model.end_coordinates componentsSeparatedByString:@","][1] floatValue] longitude:[[_model.end_coordinates componentsSeparatedByString:@","][0] floatValue]];
        }
        request.strategy = 0;//结合交通实际情况
        request.requireExtension = YES;
        if (!_search) {
            _search = [[AMapSearchAPI alloc] init];
            _search.delegate = self;
        }
        [_search AMapDrivingRouteSearch:request];
    }
    
    for (id ann in self.mapView.annotations) {
        if ([ann isKindOfClass:[MAUserLocation class]]) {
            MAUserLocation *userLocation = (MAUserLocation *)ann;
            NSInteger minute = (long)_driveringTime/60;
            NSInteger second = (long)_driveringTime%60;
            NSMutableString *minuteStr = [NSMutableString stringWithFormat:@"%ld",minute];
            NSMutableString *secondStr = [NSMutableString stringWithFormat:@"%ld",second];
            if (minuteStr.length == 1) {
                minuteStr = [NSMutableString stringWithFormat:@"0%@",minuteStr];
            }
            if (secondStr.length == 1) {
                secondStr = [NSMutableString stringWithFormat:@"0%@",secondStr];
            }
            _distance += [_mileage floatValue];
            NSString *annTitle = [NSString stringWithFormat:@"剩余%.2f公里 已行驶%@:%@",((float)_distance )/1000,minuteStr,secondStr];
            userLocation.title = annTitle;
        }
    }

    if (_isHadExit == HadExit && !isHadRecord) {//如果退出过程序，那么上一秒的坐标经纬度就是请求道服务器的坐标(上一秒坐标从服务器获取)
        NSDictionary *parmas = [NSDictionary dictionaryWithObject:_model.route_id forKey:@"route_id"];
        [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"OrderApi",@"driver_location"] params:parmas success:^(id json) {
            @try {
                NSString *str = [NSString stringWithFormat:@"%@",json[@"data"]];
                if([str isEqualToString:@"1"]){
                    NSArray *ary = [json[@"info"][@"user_location"] componentsSeparatedByString:@","];
                    lastPoint = CLLocationCoordinate2DMake([ary[1] doubleValue], [ary[0] doubleValue]);
                    isHadRecord = YES;
                }
            } @catch (NSException *exception) {
                
            } @finally {
                
            }
        } failure:^(NSError *error) {
            
        }];
    }
    else{//如果没有退出过程序，那么就是正常计费，上一秒坐标经纬度是上一秒定位到的坐标
        if(nowPoint.latitude != 0){
            lastPoint = nowPoint;
        }
    }
    
    if(_userLocation.location){
        nowPoint = _userLocation.location.coordinate;
    }
    else{
        return;
    }
    
    CLLocationSpeed speed = _userLocation.location.speed;
    if (speed == -1) {
        speed = 0;
    }
    if (_isCalculateStart) {
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:[NSString stringWithFormat:@"%.0f",speed] forKey:@"distance"];
        [params setValue:_model.route_id forKey:@"route_id"];
        [params setValue:@"3" forKey:@"route_status"];

        if(_gonePrice){
            [params setValue:_gonePrice forKey:@"gonePrice"];
        }
        //记录上一秒和当前一秒的经纬度。
        [params setValue:[NSString stringWithFormat:@"%f",lastPoint.latitude] forKey:@"last_latitude"];
        [params setValue:[NSString stringWithFormat:@"%f",lastPoint.longitude] forKey:@"last_longitude"];
        [params setValue:[NSString stringWithFormat:@"%f",nowPoint.latitude] forKey:@"now_latitude"];
        [params setValue:[NSString stringWithFormat:@"%f",nowPoint.longitude] forKey:@"now_longitude"];
        
        [params setValue:isLowSpeed forKey:@"time"];
        [params setValue:_gonePrice forKey:@"gonePrice"];
        
        switch (self.ruleInfoModel.rule_type.integerValue) {
            case 1:
            {
<<<<<<< Updated upstream
//                NSMutableDictionary *priceDic = [[self.calculateSpecialCar calculatePriceWithParams:params] mutableCopy];
<<<<<<< HEAD
                if(lastPoint.latitude != 0 && nowPoint.latitude != 0){//上一秒和这一秒的坐标都不为0时，开始计价
                    NSMutableDictionary *priceDic = [[self.calculateSpecialCar calculatePriceByLocationWithParams:params] mutableCopy];
                    
                    distanceLabel.text = [NSString stringWithFormat:@"里程%.2f公里",[priceDic[@"mileage"] floatValue]];
                    if (_isHadExit == HadExit) {//如果是退出程序重新启动，低速时间要加上之前的低速时间
                        [priceDic setValue:[NSString stringWithFormat:@"%ld",[priceDic[@"low_time"] integerValue] + [_low_time integerValue]] forKey:@"low_time"];
                        speedLabel.text = [NSString stringWithFormat:@"低速%li分钟",[priceDic[@"low_time"] integerValue]/60];
                    }else{
                        speedLabel.text = [NSString stringWithFormat:@"低速%li分钟",[priceDic[@"low_time"] integerValue]/60];
                    }
                    price = [NSString stringWithFormat:@"%.0f元",[priceDic[@"total_price"] floatValue]];
                    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:price];
                    [attri addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:22],NSForegroundColorAttributeName : RGBColor(44, 44, 44, 1.f)} range:NSMakeRange(0, price.length-1)];
                    priceLabel.attributedText = attri;
                    [priceDic setObject:_model.route_id forKey:@"route_id"];
                    [priceDic setObject:_ruleInfoModel.step forKey:@"start_price"];
                    if (_driveringTime%60 == 0) {
                        NSLog(@"%@",priceDic);
                        [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"OrderApi",@"billing"] params:priceDic success:^(id json) {
                            NSLog(@"%@",json);
                        } failure:^(NSError *error) {
                            
                        }];
                    }
=======
                NSMutableDictionary *priceDic = [[self.calculateSpecialCar calculatePriceByLocationWithParams:params] mutableCopy];
                distanceLabel.text = [NSString stringWithFormat:@"里程%.2f公里",[priceDic[@"mileage"] floatValue]];
                if (_isHadExit == HadExit) {//如果是退出程序重新启动，低速时间要加上之前的低速时间
                    [priceDic setValue:[NSString stringWithFormat:@"%ld",[priceDic[@"low_time"] integerValue] + [_low_time integerValue]] forKey:@"low_time"];
                    speedLabel.text = [NSString stringWithFormat:@"低速%li分钟",[priceDic[@"low_time"] integerValue]/60];
                }else{
                    speedLabel.text = [NSString stringWithFormat:@"低速%li分钟",[priceDic[@"low_time"] integerValue]/60];
                }
=======
                NSMutableDictionary *priceDic = [[self.calculateSpecialCar calculatePriceWithParams:params] mutableCopy];
                distanceLabel.text = [NSString stringWithFormat:@"里程%.0f公里",[priceDic[@"mileage"] floatValue]];
                speedLabel.text = [NSString stringWithFormat:@"低速%li分钟",[priceDic[@"low_time"] integerValue]/60];
>>>>>>> Stashed changes
                price = [NSString stringWithFormat:@"%.0f元",[priceDic[@"total_price"] floatValue]];
                NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:price];
                [attri addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:22],NSForegroundColorAttributeName : RGBColor(44, 44, 44, 1.f)} range:NSMakeRange(0, price.length-1)];
                priceLabel.attributedText = attri;
                [priceDic setObject:_model.route_id forKey:@"route_id"];
                [priceDic setObject:_ruleInfoModel.step forKey:@"start_price"];
                if (_driveringTime%60 == 0) {
                    NSLog(@"%@",priceDic);
                    [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"OrderApi",@"billing"] params:priceDic success:^(id json) {
                        NSLog(@"%@",json);
                    } failure:^(NSError *error) {
                        
                    }];
>>>>>>> origin/master
                }
                break;
            }
            case 2:
            {
                speedLabel.hidden = YES;
<<<<<<< Updated upstream
                
                //将每秒根据经纬度定位到的距离按照速度传给计价规则
                MAMapPoint point1 = MAMapPointMake(lastPoint.longitude, lastPoint.latitude);
                MAMapPoint point2 = MAMapPointMake(nowPoint.longitude, nowPoint.latitude);
                CLLocationDistance distance = MAMetersBetweenMapPoints(point1, point2);
                speed = distance;
                NSArray *priceArr = [self.calculateCharteredBus calculatePriceWithSpeed:speed andGonePrice:_mileage andBordingTime:_boardingTime];
                distanceLabel.text = [NSString stringWithFormat:@"里程%.2f公里",[priceArr[1] floatValue]];
=======
<<<<<<< HEAD
                NSArray *priceArr = [self.calculateCharteredBus calculatePriceWithSpeed:speed];
                distanceLabel.text = [NSString stringWithFormat:@"里程%.0f公里",[priceArr[1] floatValue]];
=======
                NSArray *priceArr = [self.calculateCharteredBus calculatePriceWithSpeed:speed andGonePrice:_gonePrice];
                distanceLabel.text = [NSString stringWithFormat:@"里程%.2f公里",[priceArr[1] floatValue]];
>>>>>>> origin/master
>>>>>>> Stashed changes
                price = [NSString stringWithFormat:@"%.0f元",[priceArr[0] floatValue]];
                NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:price];
                [attri addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:22],NSForegroundColorAttributeName : RGBColor(44, 44, 44, 1.f)} range:NSMakeRange(0, price.length-1)];
                priceLabel.attributedText = attri;
                if (_driveringTime%60 == 0) {
                    [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"OrderApi",@"billing"] params:@{@"route_id":_model.route_id,@"total_price":priceArr[0],@"mileage":priceArr[1],@"carbon_emission":priceArr[2]} success:^(id json) {
                    } failure:^(NSError *error) {
                    }];
                }
                break;
            }
            case 3:
            {
                _driverDistance += speed;
                speedLabel.hidden = YES;
                price = [NSString stringWithFormat:@"%.0f元",_ruleInfoModel.once_price.floatValue];
                NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:price];
                [attri addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:22],NSForegroundColorAttributeName : RGBColor(44, 44, 44, 1.f)} range:NSMakeRange(0, price.length-1)];
                priceLabel.attributedText = attri;
                if (_driveringTime%60 == 0) {
                    [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"OrderApi",@"billing"] params:@{@"route_id":_model.route_id,@"total_price":_ruleInfoModel.once_price,@"mileage":[NSString stringWithFormat:@"%f",_driverDistance],@"carbon_emission":[NSString stringWithFormat:@"%f",_driverDistance*0.00013]} success:^(id json) {
                        
                    } failure:^(NSError *error) {
                        
                    }];
                }
                break;
            }
            case 4:
            {
                _driverDistance += speed;
                speedLabel.hidden = YES;
                price = [NSString stringWithFormat:@"%.0f元",_ruleInfoModel.once_price.floatValue];
                NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:price];
                [attri addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:22],NSForegroundColorAttributeName : RGBColor(44, 44, 44, 1.f)} range:NSMakeRange(0, price.length-1)];
                priceLabel.attributedText = attri;
                if (_driveringTime%60 == 0) {
                    [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"OrderApi",@"billing"] params:@{@"route_id":_model.route_id,@"total_price":_ruleInfoModel.once_price,@"mileage":[NSString stringWithFormat:@"%f",_driverDistance],@"carbon_emission":[NSString stringWithFormat:@"%f",_driverDistance*0.00013]} success:^(id json) {
                        
                    } failure:^(NSError *error) {
                        
                    }];
                }
                break;
            }
            default:
                break;
        }
        
        //        [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"OrderApi",@"speed_price"] params:params success:^(id json) {
        //            @try {
        //                NYLog(@"%@",json);
        //                if (!json) {
        //                    return ;
        //                }
        //                actualPriceModel = [[ActualPriceModel alloc] initWithDictionary:json[@"info"] error:nil];
        //                distanceLabel.text = [NSString stringWithFormat:@"里程%.2f公里",[actualPriceModel.mileage floatValue]];
        //                speedLabel.text = [NSString stringWithFormat:@"低速%li分钟",(long)[actualPriceModel.low_time integerValue]];
        //                price = [NSString stringWithFormat:@"%.2f",[actualPriceModel.total_price floatValue]];
        //                NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:price];
        //                [attri addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:22],NSForegroundColorAttributeName : RGBColor(44, 44, 44, 1.f)} range:NSMakeRange(0, price.length)];
        //                priceLabel.attributedText = attri;
        //            }
        //            @catch (NSException *exception) {
        //
        //            }
        //            @finally {
        //
        //            }
        //        } failure:^(NSError *error) {
        //
        //        }];
    } else {
        if (_driveringTime % 10 == 0) {
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setValue:_model.route_id forKey:@"route_id"];
            [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"OrderApi",@"near_cars"] params:params success:^(id json) {
                
                @try {
                    NYLog(@"%@",json);
                    NSString *routeStatus = [NSString stringWithFormat:@"%@",json[@"data"][@"route_status"]];
                    if ([routeStatus isEqualToString:@"-1"]) {
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"乘客已取消订单" message:nil preferredStyle:UIAlertControllerStyleAlert];
                        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                            [_timer setFireDate:[NSDate distantFuture]];
//                            [_timer invalidate];
//                            _timer = nil;
                            for (UIViewController *vc in self.navigationController.viewControllers) {
                                if ([vc isKindOfClass:[HomeDriverViewController class]]) {
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ContinueListenTheOrders" object:nil];
                                    [self.navigationController popToViewController:vc animated:YES];
                                }
                            }
                        }]];
                        [self presentViewController:alert animated:YES completion:nil];
                    }
                }
                @catch (NSException *exception) {
                    
                }
                @finally {
                    
                }
                
            } failure:^(NSError *error) {
                
            }];
        }
    }
}

- (void)calculatePassengerRoute
{
    if (_startPoint && _endPoint) {
        NSArray *startPoints = @[_startPoint];
        NSArray *endPoints   = @[_endPoint];
        
        [self.naviManager calculateDriveRouteWithStartPoints:startPoints endPoints:endPoints wayPoints:nil drivingStrategy:2];
    } else {
        [MBProgressHUD showError:@"导航失败，请稍后重试"];
    }
}

#pragma mark - MAMapViewDelegate
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.driverCoordinate = userLocation.coordinate;
    _userLocation = userLocation;
    [mapView setSelectedAnnotations:@[userLocation]];
    [self.mapView setCenterCoordinate:userLocation.coordinate animated:YES];
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
        if (_driveringTime % 10 == 0) {
            
            //根据终点路线规划
            if(!_isCalculateStart){//开始计费之前，路线规划按照乘客的下单起点规划
                [self routePlanWithCllocation:userLocation.location andEndPoint:_model.origin_coordinates];
            }
            else{//开始计费之后，路线规划按照下单终点规划
                [self routePlanWithCllocation:userLocation.location andEndPoint:_model.end_coordinates];
            }
            
            [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"OrderApi",@"dri_address"] params:params success:^(id json) {
            } failure:^(NSError *error) {
            }];
        }
    }
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    NYLog(@"%@",[annotation class]);
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
    
    NSInteger distance = 0;
    for (AMapStep *step in path.steps) {
        distance += step.distance;
    }
    _distance = distance;
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
    [MBProgressHUD showError:@"您已停止导航！"];
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
        
        @try {
            NSString *resultStr = [NSString stringWithFormat:@"%@",json[@"result"]];
            if ([resultStr isEqualToString:@"1"]) {
                [_confirmBtn setTitle:@"开始计费" forState:UIControlStateNormal];
                _appointBgView.hidden = YES;
                _coverView.hidden = YES;
                _buttonState = 1;
                [MBProgressHUD hideHUD];
                _isCalculateStart = 0;
                return ;
            } else if ([resultStr isEqualToString:@"0"]) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"请重新确认您已到达预约地点"];
                return;
            }
            NYLog(@"%@",json);
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络错误"];
        NYLog(@"%@",error.localizedDescription);
        
    }];
}

// 开始计费
- (void)billingLeftBtnClicked:(UIButton *)btn
{
    _billingBgView.hidden = YES;
    _coverView.hidden = YES;
    _buttonState = 1;
}

// 开始计费
- (void)billingRightBtnClicked:(UIButton *)btn
{
    [MBProgressHUD showMessage:@"请稍候"];
    //开始计费之后，移除客户的定位大头针
#warning 移除客户的大头针
    switch (self.ruleInfoModel.rule_type.integerValue) {
        case 1:
        {
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setObject:_model.route_id forKey:@"route_id"];
            [params setObject:_ruleInfoModel.step forKey:@"start_price"];
            [params setObject:@"3" forKey:@"route_status"];
            [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"OrderApi",@"billing"] params:params success:^(id json) {
                [MBProgressHUD hideHUD];
                @try {
                    NSString *dataStr = [NSString stringWithFormat:@"%@",json[@"data"]];
                    if ([dataStr isEqualToString:@"1"]) {
                        _billingBgView.hidden = YES;
                        _coverView.hidden = YES;
                        _chargingBgView.hidden = NO;
                        _bottomBgView.hidden = YES;
                        _buttonState = 2;
                        _isCalculateStart = 1;
                    } else {
                        [MBProgressHUD showError:@"请重新确认开始计费"];
                    }
                } @catch (NSException *exception) {
                    
                } @finally {
                    
                }
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"网络错误"];
            }];
            
            break;
        }
        case 2:
        {
<<<<<<< Updated upstream
            NSArray *priceArr = [self.calculateCharteredBus calculatePriceWithSpeed:0 andGonePrice:_gonePrice andBordingTime:_boardingTime];
=======
            NSArray *priceArr = [self.calculateCharteredBus calculatePriceWithSpeed:0 andGonePrice:_gonePrice];
>>>>>>> Stashed changes
            [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"OrderApi",@"billing"] params:@{@"route_id":_model.route_id,@"total_price":priceArr[0],@"mileage":priceArr[1],@"route_status":@"3",@"carbon_emission":priceArr[2]} success:^(id json) {
                [MBProgressHUD hideHUD];
                @try {
                    NSString *dataStr = [NSString stringWithFormat:@"%@",json[@"data"]];
                    if ([dataStr isEqualToString:@"1"]) {
                        _billingBgView.hidden = YES;
                        _coverView.hidden = YES;
                        _chargingBgView.hidden = NO;
                        _bottomBgView.hidden = YES;
                        _buttonState = 2;
                        _isCalculateStart = 1;
                    } else {
                        [MBProgressHUD showError:@"请重新确认开始计费"];
                    }
                } @catch (NSException *exception) {
                    
                } @finally {
                    
                }
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"网络错误"];
            }];
            break;
        }
        case 3:
        {
            [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"OrderApi",@"billing"] params:@{@"route_id":_model.route_id,@"total_price":_ruleInfoModel.once_price,@"route_status":@"3",@"mileage":[NSString stringWithFormat:@"%f",_driverDistance],@"carbon_emission":[NSString stringWithFormat:@"%f",_driverDistance*0.00013]} success:^(id json) {
                [MBProgressHUD hideHUD];
                @try {
                    NSString *dataStr = [NSString stringWithFormat:@"%@",json[@"data"]];
                    if ([dataStr isEqualToString:@"1"]) {
                        _billingBgView.hidden = YES;
                        _coverView.hidden = YES;
                        _chargingBgView.hidden = NO;
                        _bottomBgView.hidden = YES;
                        _buttonState = 2;
                        _isCalculateStart = 1;
                    } else {
                        [MBProgressHUD showError:@"请重新确认开始计费"];
                    }
                } @catch (NSException *exception) {
                    
                } @finally {
                    
                }
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"网络错误"];
            }];
            break;
        }
        case 4:
        {
            [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"OrderApi",@"billing"] params:@{@"route_id":_model.route_id,@"total_price":_ruleInfoModel.once_price,@"route_status":@"3",@"mileage":[NSString stringWithFormat:@"%f",_driverDistance],@"carbon_emission":[NSString stringWithFormat:@"%f",_driverDistance*0.00013]} success:^(id json) {
                [MBProgressHUD hideHUD];
                @try {
                    NSString *dataStr = [NSString stringWithFormat:@"%@",json[@"data"]];
                    if ([dataStr isEqualToString:@"1"]) {
                        _billingBgView.hidden = YES;
                        _coverView.hidden = YES;
                        _chargingBgView.hidden = NO;
                        _bottomBgView.hidden = YES;
                        _buttonState = 2;
                        _isCalculateStart = 1;
                    } else {
                        [MBProgressHUD showError:@"请重新确认开始计费"];
                    }
                } @catch (NSException *exception) {
                    
                } @finally {
                    
                }
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"网络错误"];
            }];
            break;
        }
        default:
            break;
    }
    //    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //    [params setValue:_model.route_id forKey:@"route_id"];
    //    [params setValue:@"3" forKey:@"route_status"];
    //    [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"OrderApi",@"boarding"] params:params success:^(id json) {
    //
    //        @try {
    //            [MBProgressHUD hideHUD];
    //            NSString *resultStr = [NSString stringWithFormat:@"%@",json[@"result"]];
    //            if ([resultStr isEqualToString:@"1"]) {
    //                _billingBgView.hidden = YES;
    //                _coverView.hidden = YES;
    //                _chargingBgView.hidden = NO;
    //                _bottomBgView.hidden = YES;
    //                _buttonState = 2;
    //                _isCalculateStart = 1;
    //                return ;
    //            } else if ([resultStr isEqualToString:@"0"]) {
    //                [MBProgressHUD showError:@"请重新确认开始计费"];
    //                return ;
    //            }
    //        }
    //        @catch (NSException *exception) {
    //
    //        }
    //        @finally {
    //
    //        }
    //
    //    } failure:^(NSError *error) {
    //        [MBProgressHUD hideHUD];
    //        [MBProgressHUD showError:@"网络错误"];
    //    }];
}

// 结束计费
- (void)chargingBtnClicked
{
    [MBProgressHUD showMessage:@"请稍候"];
    
    switch (self.ruleInfoModel.rule_type.integerValue) {
        case 1:
        {
            NSMutableDictionary *priceDic = [[self.calculateSpecialCar calculatePriceWithParams:@{@"distance":@"0"}] mutableCopy];
            [priceDic setObject:_model.route_id forKey:@"route_id"];
            [priceDic setObject:_ruleInfoModel.step forKey:@"start_price"];
            [priceDic setObject:@"4" forKey:@"route_status"];
            [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"OrderApi",@"billing"] params:priceDic success:^(id json) {
                [MBProgressHUD hideHUD];
                @try {
                    NSString *dataStr = [NSString stringWithFormat:@"%@",json[@"data"]];
                    if ([dataStr isEqualToString:@"1"]) {
                        _isCalculateStart = 0;
                        ModefiedViewController *modefied = [[ModefiedViewController alloc] init];
                        modefied.model = self.model;
                        [_timer setFireDate:[NSDate distantFuture]];
                        [self.navigationController pushViewController:modefied animated:YES];
                    } else {
                        [MBProgressHUD showError:@"请重新确认计费"];
                    }
                } @catch (NSException *exception) {
                    
                } @finally {
                    
                }
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"网络错误"];
            }];
            break;
        }
        case 2:
        {
<<<<<<< Updated upstream
            NSArray *priceArr = [self.calculateCharteredBus calculatePriceWithSpeed:0 andGonePrice:_gonePrice andBordingTime:_boardingTime];
=======
            NSArray *priceArr = [self.calculateCharteredBus calculatePriceWithSpeed:0 andGonePrice:_gonePrice];
>>>>>>> Stashed changes
            [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"OrderApi",@"billing"] params:@{@"route_id":_model.route_id,@"total_price":priceArr[0],@"mileage":priceArr[1],@"route_status":@"4",@"carbon_emission":priceArr[2]} success:^(id json) {
                [MBProgressHUD hideHUD];
                @try {
                    NSString *dataStr = [NSString stringWithFormat:@"%@",json[@"data"]];
                    if ([dataStr isEqualToString:@"1"]) {
                        _isCalculateStart = 0;
                        ModefiedViewController *modefied = [[ModefiedViewController alloc] init];
                        modefied.model = self.model;
                        [_timer setFireDate:[NSDate distantFuture]];
                        [self.navigationController pushViewController:modefied animated:YES];
                    } else {
                        [MBProgressHUD showError:@"请重新确认计费"];
                    }
                } @catch (NSException *exception) {
                    
                } @finally {
                    
                }
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"网络错误"];
            }];
            break;
        }
        case 3:
        {
            [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"OrderApi",@"billing"] params:@{@"route_id":_model.route_id,@"total_price":_ruleInfoModel.once_price,@"route_status":@"4",@"mileage":[NSString stringWithFormat:@"%f",_driverDistance],@"carbon_emission":[NSString stringWithFormat:@"%f",_driverDistance*0.00013]} success:^(id json) {
                [MBProgressHUD hideHUD];
                @try {
                    _isCalculateStart = 0;
                    NSString *dataStr = [NSString stringWithFormat:@"%@",json[@"data"]];
                    if ([dataStr isEqualToString:@"1"]) {
                        ModefiedViewController *modefied = [[ModefiedViewController alloc] init];
                        modefied.model = self.model;
                        [_timer setFireDate:[NSDate distantFuture]];
                        [self.navigationController pushViewController:modefied animated:YES];
                    } else {
                        [MBProgressHUD showError:@"请重新确认计费"];
                    }
                } @catch (NSException *exception) {
                    
                } @finally {
                    
                }
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"网络错误"];
            }];
            break;
        }
        case 4:
        {
            [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"OrderApi",@"billing"] params:@{@"route_id":_model.route_id,@"total_price":_ruleInfoModel.once_price,@"route_status":@"4",@"mileage":[NSString stringWithFormat:@"%f",_driverDistance],@"carbon_emission":[NSString stringWithFormat:@"%f",_driverDistance*0.00013]} success:^(id json) {
                [MBProgressHUD hideHUD];
                @try {
                    _isCalculateStart = 0;
                    NSString *dataStr = [NSString stringWithFormat:@"%@",json[@"data"]];
                    if ([dataStr isEqualToString:@"1"]) {
                        ModefiedViewController *modefied = [[ModefiedViewController alloc] init];
                        modefied.model = self.model;
                        [_timer setFireDate:[NSDate distantFuture]];
                        [self.navigationController pushViewController:modefied animated:YES];
                    } else {
                        [MBProgressHUD showError:@"请重新确认计费"];
                    }
                } @catch (NSException *exception) {
                    
                } @finally {
                    
                }
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"网络错误"];
            }];
            break;
        }
        default:
            break;
    }
    
    //    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //    [params setValue:_model.route_id forKey:@"route_id"];
    //    [params setValue:@"4" forKey:@"route_status"];
    //    [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"OrderApi",@"boarding"] params:params success:^(id json) {
    //        [MBProgressHUD hideHUD];
    //        @try {
    //            NSString *resultStr = [NSString stringWithFormat:@"%@",json[@"result"]];
    //            if ([resultStr isEqualToString:@"1"]) {
    //                ModefiedViewController *modefied = [[ModefiedViewController alloc] init];
    //                //            modefied.driverDistance = distanceLabel.text;
    //                //            modefied.price = price;
    //                modefied.model = self.model;
    //                //            modefied.priceModel = actualPriceModel;
    //                [_timer setFireDate:[NSDate distantFuture]];
    //                [self.navigationController pushViewController:modefied animated:YES];
    //
    //                return ;
    //            } else if ([resultStr isEqualToString:@"0"]) {
    //
    //                [MBProgressHUD showError:@"请重新确认结束计费"];
    //                return;
    //            }
    //        }
    //        @catch (NSException *exception) {
    //
    //        }
    //        @finally {
    //
    //        }
    //
    //    } failure:^(NSError *error) {
    //        [MBProgressHUD hideHUD];
    //        [MBProgressHUD showError:@"网络错误"];
    //    }];
    
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
        [MBProgressHUD showMessage:@"终点修改中，请稍候"];
        NSString *endCoordinates = [NSString stringWithFormat:@"%f,%f",p.location.latitude,p.location.longitude];
        [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"orderApi",@"change_destination"] params:@{@"route_id":_model.route_id,@"end_name":p.name,@"end_coordinates":endCoordinates} success:^(id json) {
            
            @try {
                [MBProgressHUD hideHUD];
                NSString *dataStr = [NSString stringWithFormat:@"%@",json[@"data"]];
                if ([dataStr isEqualToString:@"1"]) {
                    [MBProgressHUD showError:json[@"info"]];
                    
                    //将修改后的终点的坐标传给model
                    NSString *modelEndCoordinates = [NSString stringWithFormat:@"%f,%f",p.location.longitude,p.location.latitude];
                    
                    _model.end_coordinates = modelEndCoordinates;
                    
                    AMapNaviPoint *startPoint = [AMapNaviPoint locationWithLatitude:[[_model.origin_coordinates componentsSeparatedByString:@","][1] floatValue] longitude:[[_model.origin_coordinates componentsSeparatedByString:@","][0] floatValue]];
                    AMapNaviPoint *endPoint = [AMapNaviPoint locationWithLatitude:p.location.latitude longitude:p.location.longitude];
                    NSArray *startPoints = @[startPoint];
                    NSArray *endPoints   = @[endPoint];
                    
                    [self.naviManager calculateDriveRouteWithStartPoints:startPoints endPoints:endPoints wayPoints:nil drivingStrategy:2];
                    
                    UIView *bgView = [self.view viewWithTag:2000];
                    UILabel *destinationLabel = (UILabel *)[bgView viewWithTag:2001];
                    destinationLabel.text = p.name;
                    return ;
                } else if ([dataStr isEqualToString:@"0"]) {
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
            [MBProgressHUD showError:@"网络错误"];
            NYLog(@"%@",error.localizedDescription);
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

- (void)pullDownTaped:(UITapGestureRecognizer *)tap
{
    UIView *bgView = [tap.view superview];
    if (bgView.height == 78) {
        [UIView animateWithDuration:.3f animations:^{
            bgView.height += tap.view.tag+1;
            tap.view.y += tap.view.tag+1;
        }];
    } else {
        [UIView animateWithDuration:.3f animations:^{
            bgView.height = 78;
            tap.view.y = 60;
        }];
    }
    
}

@end
