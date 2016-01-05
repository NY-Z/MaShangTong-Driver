//
//  PersonCenterViewController.m
//  MaShangTong
//
//  Created by niliu1h  on 15/10/17.
//  Copyright (c) 2015年 NY. All rights reserved.
//  个人中心

#import "PersonCenterViewController.h"
#import "Masonry.h"
#import "MyCenterCell.h"
#import "DriverInfoModel.h"

#define kMyCenterImage @"image"
#define kMyCenterTitle @"title"

@interface PersonCenterViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation PersonCenterViewController
// 懒加载
- (NSMutableArray *)dataArr
{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

//个人页面的总体是一个tableView，并设置他的headView
- (void)configTableView
{
    DriverInfoModel *driverInfo = [NSKeyedUnarchiver unarchiveObjectWithData:[USER_DEFAULT objectForKey:@"user_info"]];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*3/4, SCREEN_HEIGHT-138) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.bounces = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    // TableHeaderView
    UIView *bgTableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*3/4, 107)];
    
    UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 35, 65, 65)];
    headerView.tag = 200;
    
    NSData *imageData = [USER_DEFAULT objectForKey:@"header_image"];
    if (imageData) {
        headerView.image = [[UIImage alloc] initWithData:imageData];
    } else {
        if (driverInfo.head_image) {
            [headerView sd_setImageWithURL:[NSURL URLWithString:driverInfo.head_image] placeholderImage:[UIImage imageNamed:@"sijitouxiang"]];
        } else {
            headerView.image = [UIImage imageNamed:@"sijitouxiang"];
        }
    }
    
    headerView.layer.cornerRadius = 32.5;
    [bgTableHeaderView addSubview:headerView];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.tag = 300;
    nameLabel.text = driverInfo.user_name;
    nameLabel.font = [UIFont systemFontOfSize:13];
    nameLabel.textColor = RGBColor(125, 125, 125, 1.f);
    [bgTableHeaderView addSubview:nameLabel];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView);
        make.size.mas_equalTo(CGSizeMake(100, 30));
        make.left.equalTo(headerView.mas_right).with.offset(18);
    }];
    
    UILabel *infoLabel = [[UILabel alloc] init];
    infoLabel.text = driverInfo.license_plate;
    infoLabel.textAlignment = 0;
    infoLabel.textColor = RGBColor(163, 163, 163, 1.f);
    infoLabel.font = [UIFont systemFontOfSize:13];
    [bgTableHeaderView addSubview:infoLabel];
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel);
        make.top.equalTo(nameLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(150, 15));
    }];
    
    UILabel *numberLabel = [[UILabel alloc] init];
    numberLabel.text = [NSString stringWithFormat:@"%@单",driverInfo.snum];
    numberLabel.textColor = RGBColor(163, 163, 163, 1.f);
    numberLabel.font = [UIFont systemFontOfSize:13];
    [bgTableHeaderView addSubview:numberLabel];
    
    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel);
        make.top.equalTo(infoLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
    
    UIImageView *indicatorImageView = [[UIImageView alloc] init];
    indicatorImageView.image = [UIImage imageNamed:@"indicator"];
    [bgTableHeaderView addSubview:indicatorImageView];
    
    [indicatorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView);
        make.right.equalTo(bgTableHeaderView).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15, 107, (SCREEN_WIDTH*3/4), 1)];
    view.backgroundColor = RGBColor(229, 229, 229, 1.f);
    [bgTableHeaderView addSubview:view];
    
    //在tableHeadView上添加一个点击的事件
    bgTableHeaderView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableHeaderViewClick:)];
    [bgTableHeaderView addGestureRecognizer:tap];
    
    _tableView.tableHeaderView = bgTableHeaderView;
}

//设置广告图片
- (void)configAD
{
    UIImageView *adImageView = [[UIImageView alloc] init];
    adImageView.image = [UIImage imageNamed:@"advertisementImage"];
    [self.view addSubview:adImageView];
    
    [adImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).with.offset(-92);
        make.left.equalTo(_tableView).with.offset(0);
        make.right.equalTo(_tableView).with.offset(0);
        make.height.equalTo(@((SCREEN_WIDTH*3/16)));
    }];
}

//设置退出按钮所在界面，及退出按钮
- (void)configLogOutBtn
{
    UIView *btnBgView = [[UIView alloc] init];
    btnBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:btnBgView];
    [btnBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view.mas_left).with.offset(SCREEN_WIDTH*3/4);
        make.top.equalTo(self.view.mas_bottom).with.offset(-92);
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"退出登录" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn setTitleColor:RGBColor(103, 103, 103, 1.f) forState:UIControlStateNormal];
    btn.layer.borderColor = RGBColor(180, 180, 180, 1.f).CGColor;
    btn.layer.borderWidth = 1.f;
    btn.layer.cornerRadius = 5.f;
    [btn addTarget:self action:@selector(logoutBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-30);
        make.size.mas_equalTo(CGSizeMake(120, 32));
        make.centerX.equalTo(_tableView);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.superview.backgroundColor = [UIColor clearColor];
    [self configDataSource];
    [self configTableView];
    [self configAD];
    [self configLogOutBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeUserInfo:) name:@"ChangeUserInfo" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeUserHeaderImage:) name:@"ChangeUserHeaderImage" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor=[UIColor colorWithWhite:0.6 alpha:0];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.001 animations:^{
        self.view.backgroundColor=[UIColor colorWithWhite:0.6 alpha:0.6];
    }];
}

//设置每个cell的数据（即是图片）
- (void)configDataSource
{
    _dataArr = [@[@{kMyCenterImage:@"wodexingcheng", kMyCenterTitle:@"我的行程"},
                  @{kMyCenterImage:@"wodepinglun", kMyCenterTitle:@"我的评论"},
                  @{kMyCenterImage:@"wodeqianbao", kMyCenterTitle:@"我的账户"},
                  @{kMyCenterImage:@"sijizhaomu", kMyCenterTitle:@"邀请活动"},
                  @{kMyCenterImage:@"xiaoxizhongxin", kMyCenterTitle:@"消息中心"},
                  @{kMyCenterImage:@"wodefenxiang", kMyCenterTitle:@"分享"},
                  @{kMyCenterImage:@"faxian", kMyCenterTitle:@"发现"},
                  @{kMyCenterImage:@"shezhi", kMyCenterTitle:@"设置"}]
                mutableCopy];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 38;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"MyCenterId";
    MyCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyCenterCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.leftImageView.image = [UIImage imageNamed:_dataArr[indexPath.row][kMyCenterImage]];
    cell.nameLabel.text = _dataArr[indexPath.row][kMyCenterTitle];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableViewCellSelected) {
        self.tableViewCellSelected(indexPath.row,((MyCenterCell *)[tableView cellForRowAtIndexPath:indexPath]).nameLabel.text);
    }
}

#pragma mark - 通知
- (void)changeUserInfo:(NSNotification *)noti
{
    UIView *view = _tableView.tableHeaderView;
    UILabel *label = (UILabel *)[view viewWithTag:300];
    label.text = noti.object;
}

- (void)changeUserHeaderImage:(NSNotification *)noti
{
    UIView *view = _tableView.tableHeaderView;
    UIImageView *imageView = (UIImageView *)[view viewWithTag:200];
    imageView.image = noti.object;
}

#pragma mark - Touches
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.view.backgroundColor=[UIColor colorWithWhite:0.6 alpha:0];

    [UIView animateWithDuration:0.3 animations:^{
        self.view.x = -SCREEN_WIDTH;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
}

#pragma mark - Gesture
- (void)tableHeaderViewClick:(UITapGestureRecognizer *)tap
{
    if (self.tableHeaderViewClicked) {
        self.tableHeaderViewClicked();
    }
}

#pragma mark - Action
- (void)logoutBtnClicked:(UIButton *)btn
{
    [USER_DEFAULT setValue:@"0" forKey:@"isLogin"];
    if (self.logOutBtnClicked) {
        self.logOutBtnClicked();
    }
}

@end
