//
//  InputViewController.m
//  MaShangTong
//
//  Created by niliu1h  on 15/10/21.
//  Copyright (c) 2015年 NY. All rights reserved.
//

#import "InputViewController.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import "Masonry.h"
#import <AMapNaviKit/MAMapKit.h>

@interface InputViewController () <UITableViewDelegate,UITableViewDataSource,AMapSearchDelegate,UITextFieldDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_poiResultArr;
    
    AMapSearchAPI *_search;
    UITextField *inputTextField;
    
    NSString *_currentCity;
}

@end

@implementation InputViewController

- (void)configViews
{
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.height.mas_equalTo(54);
    }];
    
    inputTextField = [[UITextField alloc] init];
    inputTextField.placeholder = self.textFieldText;
    inputTextField.layer.borderColor = RGBColor(98, 190, 255, 1.f).CGColor;
    inputTextField.layer.borderWidth = 1.f;
    inputTextField.layer.cornerRadius = 5.f;
    inputTextField.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:)name:UITextFieldTextDidChangeNotification object:inputTextField];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fangdajing"]];
    imageView.frame = CGRectMake(0, 0, 24, 24);
    inputTextField.leftViewMode = UITextFieldViewModeAlways;
    inputTextField.leftView = imageView;
    inputTextField.font = [UIFont systemFontOfSize:13];
    [inputTextField becomeFirstResponder];
    [bgView addSubview:inputTextField];
    [inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(26);
        make.right.equalTo(bgView).offset(-60);
        make.top.equalTo(bgView).offset(10);
        make.bottom.equalTo(bgView).offset(-10);
    }];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBtn setImage:[UIImage imageNamed:@"chahao"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:deleteBtn];
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView).offset(16);
        make.bottom.equalTo(bgView).offset(-16);
        make.left.equalTo(inputTextField.mas_right).offset(16);
        make.width.mas_equalTo(22);
    }];
    
    UIView *barrierView = [[UIView alloc] init];
    barrierView.backgroundColor = RGBColor(178, 178, 178, 1.f);
    [bgView addSubview:barrierView];
    [barrierView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bgView);
        make.width.equalTo(bgView);
        make.leading.equalTo(bgView);
        make.height.mas_equalTo(1);
    }];
    
}

- (void)configTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _currentCity = @"上海";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    
    [self configViews];
    [self configTableView];
    [self configDataSource];
}

- (void)configDataSource
{
    _poiResultArr = [NSMutableArray array];
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _poiResultArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"InPutTableViewCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    AMapTip *p = _poiResultArr[indexPath.row];
    cell.textLabel.text = p.name;
    cell.detailTextLabel.text = p.district;
    return cell;
}

/*
 @property (nonatomic, copy) NSString *uid; //!< poi的id
 @property (nonatomic, copy) NSString *name; //!< 名称
 @property (nonatomic, copy) NSString *adcode; //!< 区域编码
 @property (nonatomic, copy) NSString *district; //!< 所属区域
 @property (nonatomic, copy) AMapGeoPoint *location; //!< 位置
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [inputTextField resignFirstResponder];
    AMapTip *p = _poiResultArr[indexPath.row];
    if (self.changeDestination) {
        self.changeDestination(p);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [inputTextField resignFirstResponder];
}

#pragma mark - Action
- (void)deleteBtnClicked:(UIButton *)btn
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - Notification
- (void)textFieldDidChange:(NSNotification *)note
{
    _tableView.scrollsToTop = YES;
    AMapInputTipsSearchRequest *request = [[AMapInputTipsSearchRequest alloc] init];
    request.keywords = inputTextField.text;
    request.city = _currentCity;
    [_search AMapInputTipsSearch:request];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - AMapGeocodeSearchRequestDelegate
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response
{
    if(response.geocodes.count == 0) {
        return;
    }
    //处理搜索结果
    NSString *strGeocodes = @"";
    for (AMapTip *p in response.geocodes) {
        strGeocodes = [NSString stringWithFormat:@"%@\ngeocode: %@", strGeocodes, p.description];
        NYLog(@"%f,%f",p.location.latitude,p.location.longitude);
    }
}

#pragma mark - POI-Search

-(void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response
{
    NSMutableArray *tempArray = [NSMutableArray new];
    if (response.tips.count == 0) {
        NSLog(@"没有请求到数据");
        return;
    }
    //对请求到的数据进行处理
    for (AMapTip  *p in response.tips) {
        //将查到的数据存到数组
        [tempArray addObject:p];
        
    }
    _poiResultArr = [NSMutableArray arrayWithArray:tempArray];
    [_tableView reloadData];
    [tempArray removeAllObjects];
}

//实现POI搜索对应的回调函数
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if(response.pois.count == 0)
    {
        return;
    }
    [_poiResultArr removeAllObjects];
    [_poiResultArr addObjectsFromArray:response.pois];
    [_tableView reloadData];
}

@end
