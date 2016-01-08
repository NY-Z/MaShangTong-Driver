//
//  NYMyTripsViewController.m
//  MaShangTong-Driver
//
//  Created by apple on 15/12/16.
//  Copyright © 2015年 jeaner. All rights reserved.
//

#import "NYMyTripsViewController.h"
#import "MyTripCell.h"
#import "NYMyTripModel.h"
#import "detailOrderVC.h"

#define kOrigin @"origin"
#define kDestination @"destination"
#define kJourney @"journey"
#define kCarbon @"carbon"

@interface NYMyTripsViewController () <UITableViewDataSource,UITableViewDelegate>
{
    UIView *topBgView;
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) NYMyTripModel *myTripModel;

@end

@implementation NYMyTripsViewController

- (NSArray *)dataArr
{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)configTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 32, SCREEN_WIDTH, SCREEN_HEIGHT-64-32) style:UITableViewStylePlain];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (void)configNavigationItem
{
    self.navigationItem.title = @"我的行程";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:21],NSForegroundColorAttributeName:RGBColor(73, 185, 254, 1.f)}];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    backBtn.size = CGSizeMake(22, 22);
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [editBtn setImage:[UIImage imageNamed:@"bianji"] forState:UIControlStateNormal];
    editBtn.size = CGSizeMake(22, 22);
    [editBtn addTarget:self action:@selector(editingAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
}

- (void)configTopView
{
    topBgView = [[UIView alloc] init];
    topBgView.backgroundColor = RGBColor(229, 229, 229, 1.f);
    [self.view addSubview:topBgView];
    [topBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 32));
    }];
    
    NSArray *titleArr = @[@"总路程",@"总次数",@"总碳排放"];
    for (NSInteger i = 0; i < 3; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.text = titleArr[i];
        label.textAlignment = 1;
        label.textColor = RGBColor(93, 93, 93, 1.f);
        label.font = [UIFont systemFontOfSize:12];
        [topBgView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topBgView);
            make.left.equalTo(topBgView).offset(SCREEN_WIDTH*i/3);
            make.width.mas_equalTo(SCREEN_WIDTH/3);
            make.height.mas_equalTo(16);
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configNavigationItem];
    [self configTopView];
    [self configTableView];
    [self configDataArr];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}

- (void)configDataArr
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:[USER_DEFAULT objectForKey:@"user_id"] forKey:@"driver_id"];
    [MBProgressHUD showMessage:@"正在加载"];
    [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"UserApi",@"myTrips"] params:params success:^(id json) {
        [MBProgressHUD hideHUD];
        @try {
            _myTripModel = [[NYMyTripModel alloc] initWithDictionary:json error:nil];
            [_tableView reloadData];
            NSArray *amountArr = @[_myTripModel.info.distance,_myTripModel.info.num1,_myTripModel.info.carbon_emission];
            for (NSInteger i = 0; i < 3; i++) {
                UILabel *label = [[UILabel alloc] init];
                label.text = amountArr[i];
                label.textAlignment = 1;
                label.textColor = RGBColor(168, 209, 246, 1.f);
                label.font = [UIFont systemFontOfSize:12];
                [topBgView addSubview:label];
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(topBgView).offset(16);
                    make.left.equalTo(topBgView).offset(SCREEN_WIDTH*i/3);
                    make.width.mas_equalTo(SCREEN_WIDTH/3);
                    make.height.mas_equalTo(16);
                }];
            }
        }
        @catch (NSException *exception) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"网络错误"];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络错误"];
    }];
}

#pragma mark - Action
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _myTripModel.info.detaile.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"MyTripCellId";
    MyTripCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyTripCell" owner:nil options:nil] lastObject];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NYMYTripInfoModel *infoModel = _myTripModel.info;
    NYMyTripDetaileModel *detailModel = infoModel.detaile[indexPath.row];
    cell.originLabel.text = detailModel.origin_name;
    cell.destinationLabel.text = detailModel.end_name;
    cell.journeyLabel.text = [NSString stringWithFormat:@"路程：%@",detailModel.trip_distance];
    cell.carbonLabel.text = [NSString stringWithFormat:@"碳排放：%@",detailModel.carbon_emission];
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NYMYTripInfoModel *infoModel = _myTripModel.info;
        NYMyTripDetaileModel *detailModel = infoModel.detaile[indexPath.row];
        [MBProgressHUD showMessage:@"正在删除"];
        [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"UserApi",@"order_delete"] params:@{@"route_id":detailModel.route_id} success:^(id json) {
            NYLog(@"%@",json);
            [MBProgressHUD hideHUD];
            NSString *dataStr = [NSString stringWithFormat:@"%@",json[@"data"]];
            if ([dataStr isEqualToString:@"1"]) {
                [infoModel.detaile removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                [MBProgressHUD showSuccess:@"删除成功"];
            } else {
                [MBProgressHUD showError:@"删除失败"];
            }
            
        } failure:^(NSError *error) {
            NYLog(@"%@",error.localizedDescription);
        }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    detailOrderVC *detail = [[detailOrderVC alloc] init];
    NYMyTripDetaileModel *detailModel = _myTripModel.info.detaile[indexPath.row];
    detail.route_id = detailModel.route_id;
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - Action
- (void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)editingAction:(UIButton *)btn
{
    [_tableView setEditing:!_tableView.editing animated:YES];
}

@end
