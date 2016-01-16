//
//  SettingViewController.m
//  MaShangTong
//
//  Created by niliu1h  on 15/10/22.
//  Copyright (c) 2015年 NY. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingTableViewCell.h"
#import "KLSwitch.h"
#import "NYContactUsViewController.h"
#import "NYAboutUsViewController.h"
#import "NYTaxiGuideViewController.h"
#import "NYSuggestionViewController.h"

@interface SettingViewController () <UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_dataArr;
}
@end

@implementation SettingViewController

- (void)configNavigationBar
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBarButtonItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.size = CGSizeMake(44, 44);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    self.navigationItem.title = @"设置";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:21],NSForegroundColorAttributeName:RGBColor(73, 185, 254, 1.f)}];
}

- (void)configTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
}

- (void)configDataSource
{
    _dataArr = @[@[@"记住导航软件选择",@"默认开启导航"],@[@"意见反馈",@"打车指南",@"联系我们",@"关于我们"]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavigationBar];
    [self configDataSource];
    [self configTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NAVIGATIONBAR_PROPERTY
    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = _dataArr[section];
    return arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 33;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 22;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"消息提示";
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 22)];
    headerBgView.backgroundColor = RGBColor(247, 247, 247, 1.f);
    if (section == 0) {
        
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH-20, 22)];
        headerLabel.text = @"消息提示";
        headerLabel.textColor = RGBColor(205, 205, 205, 1.f);
        headerLabel.font = [UIFont systemFontOfSize:13];
        [headerBgView addSubview:headerLabel];
        return headerBgView;
    }
    return headerBgView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"SettingCell";
    SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[SettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.leftTitleLabel.text = _dataArr[indexPath.section][indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section == 0) {
        cell.rightSwitch.hidden = NO;
        cell.accessoryType = UITableViewCellAccessoryNone;
        if (indexPath.section == 0 && indexPath.row == 0) {
            cell.rightSwitch.hidden = YES;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            
        }
    } else {
        cell.rightSwitch.hidden = YES;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
//                [self presentViewController:[UMFeedback feedbackModalViewController] animated:YES completion:nil];
                [self.navigationController pushViewController:[[NYSuggestionViewController alloc] init] animated:YES];
                break;
            case 1:
                [self.navigationController pushViewController:[[NYTaxiGuideViewController alloc] init] animated:YES];
                break;
            case 2:
                [self.navigationController pushViewController:[[NYContactUsViewController alloc] init] animated:YES];
                break;
            case 3:
                [self.navigationController pushViewController:[[NYAboutUsViewController alloc] init] animated:YES];
                break;
            default:
                break;
        }
    }
}

#pragma mark - Action
- (void)leftBarButtonItemClicked:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
