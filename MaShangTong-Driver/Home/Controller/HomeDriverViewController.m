//
//  HomeDriverViewController.m
//  MaShangTong
//
//  Created by NY on 15/10/29.
//  Copyright © 2015年 NY. All rights reserved.
//

#import "HomeDriverViewController.h"
#import <AMapNaviKit/MAMapKit.h>
#import <AMapNaviKit/AMapNaviKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import "Masonry.h"
#import "SharedMapView.h"
#import "DownloadManager.h"
#import "PersonCenterViewController.h"
#import "PersonInfoViewController.h"

#import "PickUpPassengerViewController.h"
#import "DriverRegisViewController.h"

#import "NYMyTripsViewController.h"
#import "NYMyCommentViewController.h"
#import "NYMyWalletViewController.h"
#import "NYInvitationViewController.h"
#import "MyNewsCenterVC.h"
#import "NYShareViewController.h"
#import "SettingViewController.h"
#import "DriverInfoModel.h"

#define BottomViewHeight 89

@interface HomeDriverViewController () <MAMapViewDelegate,IFlySpeechSynthesizerDelegate,AMapNaviManagerDelegate>
{
    UIView *topView;
    UIView *topBottomView;
    BOOL _isRequest;
    NSTimer *_timer;
    UIView *modeBgView;
    UIButton *listenBtn;
    UIButton *offRunningBtn;
    NSString *_routeId;
    NSArray *_speakingArr;
    NSInteger _speakingArrCount;
    NSInteger _currentSpeakIndex;
    BOOL _isAllowSpeaking;
    BOOL _isLocationSuccess;
    NSInteger _isFirstSetCenter;
    NSInteger _reservaType;
    
    NSString *_reservation_type;
    BOOL _isChangeMode;
}
@property (nonatomic, strong) NSArray *annotations;
@property (nonatomic, strong) MAPolyline *polyline;
@property (nonatomic, strong) MAAnnotationView *userLocationAnnotationView;
@property (nonatomic,strong) PersonCenterViewController *personCenter;

@end

@implementation HomeDriverViewController
- (void)configNavigationBar
{
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = RGBColor(99, 190, 255, 1.f);
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"gerenzhongxin"] forState:UIControlStateNormal];
    [leftBtn setFrame:CGRectMake(0, 0, 44, 44)];
    [leftBtn addTarget:self action:@selector(driverInfoBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"xiaoxi"] forState:UIControlStateNormal];
    [rightBtn setFrame:CGRectMake(0, 0, 44, 44)];
    [rightBtn addTarget:self action:@selector(infomationBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    UIImageView *titleImageView = [[UIImageView alloc] init];
    titleImageView.image = [UIImage imageNamed:@"LOGO"];
    titleImageView.frame = CGRectMake(0, 0, 84, 33);
    titleImageView.contentMode = UIViewContentModeCenter;
    self.navigationItem.titleView = titleImageView;
}

- (void)configBottom
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-BottomViewHeight-64, SCREEN_WIDTH, BottomViewHeight)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UIButton *modeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [modeBtn setTitle:@"模式" forState:UIControlStateNormal];
    [modeBtn setTitleColor:RGBColor(82, 170, 255, 1.f) forState:UIControlStateNormal];
        [modeBtn addTarget:self action:@selector(modeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    modeBtn.selected = NO;
    [bottomView addSubview:modeBtn];
    [modeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView).offset(31);
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.centerY.equalTo(bottomView);
    }];
    modeBtn.layer.borderColor = RGBColor(82, 170, 255, 1.f).CGColor;
    modeBtn.layer.borderWidth = 2.f;
    modeBtn.layer.cornerRadius = 25;
    
    listenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [listenBtn setTitle:@"休息中" forState:UIControlStateNormal];
    [listenBtn setTitle:@"听单中" forState:UIControlStateSelected];
    listenBtn.enabled = NO;
    listenBtn.selected = NO;
    [listenBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [listenBtn setBackgroundColor:RGBColor(82, 170, 255, 1.f)];
    [listenBtn addTarget:self action:@selector(listenBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:listenBtn];
    [listenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(bottomView);
        make.size.mas_equalTo(CGSizeMake(61, 61));
    }];
    listenBtn.clipsToBounds = YES;
    listenBtn.layer.cornerRadius = 30.5;
    listenBtn.layer.borderWidth = 2.f;
    listenBtn.layer.borderColor = RGBColor(82, 170, 255, 1.f).CGColor;
    
    offRunningBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [offRunningBtn setTitle:@"出车" forState:UIControlStateNormal];
    [offRunningBtn setTitle:@"收车" forState:UIControlStateSelected];
    [offRunningBtn setTitleColor:RGBColor(169, 169, 169, 1.f) forState:UIControlStateNormal];
    [offRunningBtn addTarget:self action:@selector(offRunningBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    offRunningBtn.selected = NO;
    [bottomView addSubview:offRunningBtn];
    [offRunningBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bottomView).offset(-30);
        make.centerY.equalTo(bottomView);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    offRunningBtn.clipsToBounds = YES;
    offRunningBtn.layer.cornerRadius = 25;
    offRunningBtn.layer.borderColor = RGBColor(82, 170, 255, 1.f).CGColor;
    offRunningBtn.layer.borderWidth = 2.f;
}

- (void)configTop
{
    topView = [[UIView alloc] initWithFrame:CGRectMake(0, 11, SCREEN_WIDTH, 48)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    topView.clipsToBounds = YES;
    
    CGFloat width = SCREEN_WIDTH/3;
    CGFloat height = 24;
    
    DriverInfoModel *driverInfo = [NSKeyedUnarchiver unarchiveObjectWithData:[USER_DEFAULT objectForKey:@"user_info"]];
    
    NSArray *titleArr = @[[NSString stringWithFormat:@"单数：%@单",driverInfo.snum],@"今日流水：90.30",[NSString stringWithFormat:@"%.2f★",[driverInfo.point floatValue]]];
    for (NSInteger i = 0; i < 3; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i*width, 0, width, height)];
        label.text = titleArr[i];
        label.textColor = RGBColor(38, 164, 254, 1.f);
        label.font = [UIFont systemFontOfSize:13];
        label.textAlignment = 1;
        [topView addSubview:label];
    }
    
    UIImageView *topMidImageView = [[UIImageView alloc] init];
    topMidImageView.frame = CGRectMake(0, 24, SCREEN_WIDTH, 74);
    [topView addSubview:topMidImageView];
    
    [DownloadManager get:@"http://112.124.115.81/m.php?m=OrderApi&a=adv&adv_id=6" params:nil success:^(id json) {
        @try {
            NSString *dataStr = [NSString stringWithFormat:@"%@",json[@"data"]];
            if ([dataStr isEqualToString:@"1"]) {
                [topMidImageView sd_setImageWithURL:json[@"info"]];
            } else {
                topMidImageView.backgroundColor = [UIColor whiteColor];
                return ;
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    } failure:^(NSError *error) {
        
    }];
    
    topBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 24, SCREEN_WIDTH, 24)];
    topBottomView.backgroundColor = [UIColor whiteColor];
    topBottomView.tag = 100;
    [topView addSubview:topBottomView];
    
    UIImageView *dropOffImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gengduo"]];
    dropOffImageView.frame = CGRectMake(SCREEN_WIDTH/2-18, 3, 18, 18);
    [topBottomView addSubview:dropOffImageView];
    
    UIButton *dropOffBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [dropOffBtn addTarget:self action:@selector(dropBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    dropOffBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 24);
    [topBottomView addSubview:dropOffBtn];
}

- (void)configSwitchMode
{
    modeBgView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-BottomViewHeight+32, SCREEN_WIDTH/3, BottomViewHeight)];
    modeBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:modeBgView];

    UIButton *listenSigleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [listenSigleBtn setTitle:@"预约用车" forState:UIControlStateNormal];
    [listenSigleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    listenSigleBtn.size = CGSizeMake(SCREEN_WIDTH/3, BottomViewHeight/2);
    [listenSigleBtn addTarget:self action:@selector(bookCarBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [modeBgView addSubview:listenSigleBtn];

    UIButton *closeCarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeCarBtn setTitle:@"立即用车" forState:UIControlStateNormal];
    [closeCarBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    closeCarBtn.frame = CGRectMake(0, BottomViewHeight/2, SCREEN_WIDTH/3, BottomViewHeight/2);
    [closeCarBtn addTarget:self action:@selector(rightNowCarBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [modeBgView addSubview:closeCarBtn];
}

- (void)configTimer
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:UITrackingRunLoopMode];
    }
    if (!_isRequest) {
        [_timer setFireDate:[NSDate distantFuture]];
        [self.iFlySpeechSynthesizer stopSpeaking];
    }
    if (_isChangeMode) {
        [_timer setFireDate:[NSDate distantPast]];
        _isChangeMode = NO;
    }
}

- (void)configLeftViewController
{
    _personCenter = [[PersonCenterViewController alloc] init];
    _personCenter.view.frame = CGRectMake(-SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _personCenter.view.hidden = YES;
    
    __weak typeof(self) weakSelf = self;
    
    _personCenter.logOutBtnClicked = ^(){
        [MBProgressHUD showMessage:@"正在退出"];
        [weakSelf hidePersonCenter];
        BOOL a = [weakSelf.navigationController.viewControllers[0] isKindOfClass:[DriverRegisViewController class]];
        if (a) {
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        } else {
            DriverRegisViewController *login = [[DriverRegisViewController alloc] init];
            [UIApplication sharedApplication].keyWindow.rootViewController = [[UINavigationController alloc] initWithRootViewController:login];
        }
        [MBProgressHUD hideHUD];
    };
    
    _personCenter.tableViewCellSelected = ^(NSInteger cellId, NSString *title){
        id vc;
        switch (cellId) {
            case 0:
                vc = [[NYMyTripsViewController alloc] init];
                [weakSelf.navigationController pushViewController:vc animated:NO];
                break;
            case 1:
                vc = [[NYMyCommentViewController alloc] init];
                [weakSelf.navigationController pushViewController:vc animated:NO];
                break;
                
            case 2:
                vc = [[NYMyWalletViewController alloc] init];
                [weakSelf.navigationController pushViewController:vc animated:NO];
                break;
                
            case 3:
                vc = [[NYInvitationViewController alloc] init];
                [weakSelf.navigationController pushViewController:vc animated:NO];
                break;
                
            case 4:
                vc = [[MyNewsCenterVC alloc] init];
                [weakSelf.navigationController pushViewController:vc animated:NO];
                break;
                
            case 5:
                vc = [[NYShareViewController alloc] init];
                [weakSelf.navigationController pushViewController:vc animated:NO];
                break;
                
            case 6:
                
                break;
            case 7:
                vc = [[SettingViewController alloc] init];
                [weakSelf.navigationController pushViewController:vc animated:NO];
                break;
            default:
                break;
        }
        [weakSelf hidePersonCenter];
    };
    
    _personCenter.tableHeaderViewClicked = ^{
        
        PersonInfoViewController *vc = [[PersonInfoViewController alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
        [weakSelf hidePersonCenter];
        
    };
}

- (void)hidePersonCenter
{
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        weakSelf.personCenter.view.x = -SCREEN_WIDTH;
        
    } completion:^(BOOL finished) {
        
        [weakSelf.personCenter.view removeFromSuperview];
        
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self configNavigationBar];
    self.mapView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    [self.view sendSubviewToBack:self.mapView];
    self.mapView.showsUserLocation = YES;
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [self.mapView setCenterCoordinate:delegate.driverCoordinate];
    [self.mapView setZoomLevel:14 animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.mapView];
    _isRequest = NO;
    _isAllowSpeaking = YES;
    _isLocationSuccess = NO;
    _isChangeMode = NO;
    _isFirstSetCenter = 0;
    _reservation_type = @"1";
    [self configTimer];
    [self configSwitchMode];
    [self configBottom];
    [self configTop];
    [self configLeftViewController];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listenTheOrder:) name:@"GetTheOrderList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(continueListenTheOrder:) name:@"ContinueListenTheOrders" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self clearMapView];
}

#pragma mark - MAMapViewDelegate
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.driverCoordinate = userLocation.coordinate;
    delegate.driverSpeed = [NSString stringWithFormat:@"%f",userLocation.location.speed*3.6];
    if (userLocation.location.speed < 0) {
        
        delegate.driverSpeed = 0;
    }
    
    if (_isFirstSetCenter <= 3) {
        [self.mapView setCenterCoordinate:userLocation.location.coordinate];
        _isFirstSetCenter++;
    }
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAUserLocation class]]) {
        static NSString *anIde = @"PointAnnotation";
        MAAnnotationView *view = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:anIde];
        
        if (!view) {
            view = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:anIde];
            view.image = [UIImage imageNamed:@"sijidingwei"];
            view.draggable = YES;
            view.canShowCallout = YES;
            view.centerOffset = CGPointMake(0, 0);
        }
        return view;
    }
    return nil;
}

#pragma mark - IFlySpeechSynthesizerDelegate
- (void) onCompleted:(IFlySpeechError *) error {
    if (!_isAllowSpeaking) {
        return;
    }
    if (_speakingArr.count == 0) {
        return;
    }
    if (_currentSpeakIndex < _speakingArr.count-1) {
        _currentSpeakIndex++;
        _routeId = _speakingArr[_currentSpeakIndex][@"route_id"];
        [self.iFlySpeechSynthesizer startSpeaking:_speakingArr[_currentSpeakIndex][@"mess"]];
        return;
    }
    [self configTimer];
}

#pragma mark - NSTimerAction
-(void)updateTimer
{
    NYLog(@"%@",@"请求订单");
    
    [_timer setFireDate:[NSDate distantFuture]];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    [params setObject:userId forKey:@"user_id"];
    [params setObject:_reservation_type forKey:@"reservation_type"];
    
    [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"OrderApi",@"sendorder"] params:params success:^(id json) {
        if ([json[@"data"] isKindOfClass:[NSArray class]]) {
            NSArray *result = (NSArray *)json[@"data"];
            listenBtn.enabled = YES;
            _routeId = result[0][@"route_id"];
            _speakingArr = [NSArray array];
            _speakingArr = [result copy];
            _currentSpeakIndex = 0;
            [self.iFlySpeechSynthesizer startSpeaking:_speakingArr[0][@"mess"]];
        }
        else if ([json[@"data"] isKindOfClass:[NSString class]] && _isRequest){
            [_timer setFireDate:[NSDate distantPast]];
        }
    } failure:^(NSError *error) {
        [_timer setFireDate:[NSDate distantPast]];
        NYLog(@"%@",error.localizedDescription);
        [MBProgressHUD showError:@"网络错误"];
    }];
}

#pragma mark - Action
- (void)dropBtnClicked:(UIButton *)btn
{
    if (topView.height != 48+74) {
        [UIView animateWithDuration:.3f animations:^{
            topView.height = 122;
            topBottomView.y = 98;
        }];
    } else {
        
        [UIView animateWithDuration:.3f animations:^{
            topView.height = 48;
            topBottomView.y = 24;
        }];
    }
}

- (void)listenBtnClicked:(UIButton *)btn
{
    if (!_routeId || [_routeId isEqualToString:@""]) {
        return;
    }
    [MBProgressHUD showMessage:@"抢单中,请稍候"];
    _isRequest = NO;
    _isAllowSpeaking = NO;
    [_timer setFireDate:[NSDate distantFuture]];
    [self.iFlySpeechSynthesizer stopSpeaking];
    
    listenBtn.enabled = NO;
    offRunningBtn.selected = NO;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *driverID = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    [params setValue:driverID forKey:@"driver_id"];
    [params setValue:_routeId forKey:@"route_id"];
    [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"OrderApi",@"graporder"] params:params success:^(id json) {
        
        if ([json[@"result"] isEqualToString:@"0"]) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"抢单失败"];
            _isRequest = YES;
            _isAllowSpeaking = YES;
            [_timer setFireDate:[NSDate distantPast]];
            listenBtn.enabled = YES;
            offRunningBtn.selected = YES;
            return ;
        }    else if ([json[@"result"] isEqualToString:@"-1"]) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"此单已被抢"];
            listenBtn.enabled = NO;
            _isRequest = YES;
            _isAllowSpeaking = YES;
            [_timer setFireDate:[NSDate distantPast]];
            
            listenBtn.enabled = YES;
            offRunningBtn.selected = YES;
            return ;
        }
        PassengerModel *model = [[PassengerModel alloc] initWithDictionary:json error:nil];
        DataModel *dataModel = model.data[0];
        [MBProgressHUD hideHUD];
        
        PickUpPassengerViewController *passengerVc = [[PickUpPassengerViewController alloc] init];
        passengerVc.model = dataModel;
        [self.navigationController pushViewController:passengerVc animated:YES];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [self.iFlySpeechSynthesizer stopSpeaking];
        [MBProgressHUD showError:@"您的网络有问题"];
    }];
}

- (void)offRunningBtnClicked:(UIButton *)btn
{
    btn.selected = !btn.selected;
    listenBtn.selected = btn.selected;
    if (btn.selected) {
        _isRequest = YES;
        _isAllowSpeaking = YES;
        listenBtn.enabled = YES;
        [_timer setFireDate:[NSDate distantPast]];
    } else {
        _isRequest = NO;
        _isAllowSpeaking = NO;
        listenBtn.enabled = NO;
        [self.iFlySpeechSynthesizer stopSpeaking];
        [_timer setFireDate:[NSDate distantFuture]];
    }
}

- (void)driverInfoBtnClicked:(UIButton *)btn
{
    [[UIApplication sharedApplication].keyWindow addSubview:_personCenter.view];
    [self showPersonCenter];
}

- (void)infomationBtnClicked
{
    [self.navigationController pushViewController:[[MyNewsCenterVC alloc] init] animated:YES];
}

- (void)showPersonCenter
{
    _personCenter.view.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        _personCenter.view.x = 0;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)modeBtnClicked:(UIButton *)btn
{
    modeBgView.y = SCREEN_HEIGHT-3*BottomViewHeight+32;
}

- (void)bookCarBtnClicked:(UIButton *)btn
{
    if ([_reservation_type isEqualToString:@"2"]) {
        return;
    }
    _reservation_type = @"2";
    modeBgView.y = SCREEN_HEIGHT;
    
    [self.iFlySpeechSynthesizer stopSpeaking];
    _speakingArr = [NSArray array];
    _routeId = @"";
    _currentSpeakIndex = 0;
    _isChangeMode = YES;
    [self configTimer];
}

- (void)rightNowCarBtnClicked:(UIButton *)btn
{
    if ([_reservation_type isEqualToString:@"1"]) {
        return;
    }
    _reservation_type = @"1";
    modeBgView.y = SCREEN_HEIGHT;
    
    [self.iFlySpeechSynthesizer stopSpeaking];
    _speakingArr = [NSArray array];
    _routeId = @"";
    _currentSpeakIndex = 0;
    _isChangeMode = YES;
    [self configTimer];
}

#pragma mark - AMapNaviManagerDelegate
- (void)naviManagerOnCalculateRouteSuccess:(AMapNaviManager *)naviManager
{
    [self showRouteWithNaviRoute:[[naviManager naviRoute] copy]];
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

#pragma mark - MAMapView Delegate
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

#pragma mark - 通知
- (void)listenTheOrder:(NSNotification *)noti
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetTheOrderList" object:nil];
    [self.iFlySpeechSynthesizer startSpeaking:noti.object];
}

- (void)continueListenTheOrder:(NSNotification *)noti
{
    listenBtn.enabled = NO;
    _isRequest = YES;
    _isAllowSpeaking = YES;
    [_timer setFireDate:[NSDate distantPast]];
    
    listenBtn.enabled = YES;
    offRunningBtn.selected = YES;
}

#pragma mark - dealloc
- (void)dealloc
{
    [_timer setFireDate:[NSDate distantFuture]];
    [_timer invalidate];
    _timer = nil;
}

@end
