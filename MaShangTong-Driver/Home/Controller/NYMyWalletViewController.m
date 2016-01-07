//
//  NYMyWalletViewController.m
//  MaShangTong-Driver
//
//  Created by apple on 15/12/16.
//  Copyright © 2015年 jeaner. All rights reserved.
//

#import "NYMyWalletViewController.h"
#import "VoucherTableViewCell.h"
#import "NYMyBalanceTableViewCell.h"
#import "NYMyVoucherModel.h"
#import "NYMyBalanceModel.h"

@interface NYMyWalletViewController () <UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_voucherTableView;
    NSMutableArray *_voucherDataArr;
    
    UITableView *_balanceTableView;
    NSMutableArray *_balanceDataArr;
}
@end

@implementation NYMyWalletViewController

- (void)configNavigationItem
{
    self.navigationItem.title = @"我的账户";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:21],NSForegroundColorAttributeName:RGBColor(73, 185, 254, 1.f)}];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    backBtn.size = CGSizeMake(22, 22);
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}

-(void)creatOthers
{
    //上面一条灰色的线
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    view.backgroundColor = RGBColor(220, 220, 220, 1.f);
    
    [self.view addSubview:view];
    
    //下面用两个Btn完成
    NSArray *btnNameAry = @[@"我的余额",@"我的券"];
    for (NSInteger i = 0; i<2; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*(self.view.frame.size.width/2), 1, (self.view.frame.size.width/2), 30);
        btn.backgroundColor = [UIColor whiteColor];
        btn.tag = 120+i;
        btn.enabled = NO;
        [btn setTitle:btnNameAry[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn setTitleColor:RGBColor(99, 193, 255, 1.f) forState:UIControlStateNormal];
        if (i == 1) {
            btn.backgroundColor = RGBColor(220, 220, 220, 1.f);
            [btn setTitleColor:RGBColor(192, 192, 192, 1.f) forState:UIControlStateNormal];
            btn.enabled = YES;
        }
        
        [btn addTarget:self action:@selector(cheackMyWallet:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:btn];
    }
    
}

- (void)configTableView
{
    _voucherTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, SCREEN_HEIGHT-94) style:UITableViewStylePlain];
    _voucherTableView.delegate = self;
    _voucherTableView.dataSource = self;
    _voucherTableView.tableFooterView = [UIView new];
    [self.view addSubview:_voucherTableView];
    
    UIView *voucherTableHeaderView = [UIView new];
    voucherTableHeaderView.size = CGSizeMake(SCREEN_WIDTH, 128);
    
    UILabel *voucherLabel = [[UILabel alloc] init];
    voucherLabel.textAlignment = 2;
    voucherLabel.font = [UIFont systemFontOfSize:13];
    voucherLabel.tag = 400;
    NSMutableAttributedString *voucherAttri = [[NSMutableAttributedString alloc] initWithString:@"0000.00元"];
    [voucherAttri addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:30]} range:NSMakeRange(0, 7)];
    voucherLabel.attributedText = voucherAttri;
    [voucherTableHeaderView addSubview:voucherLabel];
    [voucherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(voucherTableHeaderView);
        make.height.mas_equalTo(30);
        make.left.equalTo(voucherTableHeaderView);
        make.width.mas_equalTo(SCREEN_WIDTH*3/5);
    }];
    
    UIButton *voucherBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [voucherBtn setTitle:@"兑换" forState:UIControlStateNormal];
    [voucherBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [voucherBtn setBackgroundColor:RGBColor(112, 191, 253, 1.f)];
    [voucherTableHeaderView addSubview:voucherBtn];
    [voucherBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(voucherLabel.mas_right).offset(10);
        make.centerY.equalTo(voucherLabel);
        make.size.mas_equalTo(CGSizeMake(58, 58));
    }];
    voucherBtn.layer.cornerRadius = 29.f;
    
    UILabel *infoLabel = [UILabel new];
    infoLabel.text = @"收到代金券总额";
    infoLabel.textAlignment = 0;
    infoLabel.textColor = RGBColor(181, 181, 181, 1.f);
    infoLabel.font = [UIFont systemFontOfSize:10];
    [voucherTableHeaderView addSubview:infoLabel];
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(voucherTableHeaderView).offset(SCREEN_WIDTH/4);
        make.top.equalTo(voucherLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(80, 16));
    }];
    
    UIView *voucherBarrierView = [UIView new];
    voucherBarrierView.backgroundColor = RGBColor(181, 181, 181, 1.f);
    [voucherTableHeaderView addSubview:voucherBarrierView];
    [voucherBarrierView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(voucherTableHeaderView);
        make.right.equalTo(voucherTableHeaderView);
        make.bottom.equalTo(voucherTableHeaderView);
        make.height.mas_equalTo(1);
    }];
    
    UILabel *voucherStatementLabel = [UILabel new];
    voucherStatementLabel.text = @"收支明细";
    voucherStatementLabel.textAlignment = 1;
    voucherStatementLabel.textColor = RGBColor(123, 123, 123, 1.f);
    voucherStatementLabel.font = [UIFont systemFontOfSize:11];
    voucherStatementLabel.backgroundColor = [UIColor whiteColor];
    [voucherTableHeaderView addSubview:voucherStatementLabel];
    [voucherStatementLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(voucherBarrierView);
        make.centerX.equalTo(voucherBarrierView);
        make.size.mas_equalTo(CGSizeMake(80, 20));
    }];
    
    _voucherTableView.tableHeaderView = voucherTableHeaderView;
    _voucherTableView.hidden = YES;
#warning 我的余额TableView
    
    _balanceTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, SCREEN_HEIGHT-94) style:UITableViewStylePlain];
    _balanceTableView.delegate = self;
    _balanceTableView.dataSource = self;
    _balanceTableView.tableFooterView = [UIView new];
    [self.view addSubview:_balanceTableView];
//    _balanceTableView.hidden = YES;
    
    UIView *balanceTableHeaderView = [UIView new];
    balanceTableHeaderView.size = CGSizeMake(SCREEN_WIDTH, 128);
    
    UILabel *balanceLabel = [[UILabel alloc] init];
    balanceLabel.textAlignment = 2;
    balanceLabel.font = [UIFont systemFontOfSize:13];
    balanceLabel.tag = 100;
    NSMutableAttributedString *balanceAttri = [[NSMutableAttributedString alloc] initWithString:@"00.00元"];
    [balanceAttri addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:30]} range:NSMakeRange(0, 5)];
    balanceLabel.attributedText = balanceAttri;
    [balanceTableHeaderView addSubview:balanceLabel];
    [balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(balanceTableHeaderView);
        make.height.mas_equalTo(30);
        make.left.equalTo(balanceTableHeaderView);
        make.width.mas_equalTo(SCREEN_WIDTH*3/5);
    }];
    
    UIButton *balanceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [balanceBtn setTitle:@"提现" forState:UIControlStateNormal];
    [balanceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [balanceBtn setBackgroundColor:RGBColor(112, 191, 253, 1.f)];
    [balanceTableHeaderView addSubview:balanceBtn];
    [balanceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(balanceLabel.mas_right).offset(10);
        make.centerY.equalTo(balanceLabel);
        make.size.mas_equalTo(CGSizeMake(58, 58));
    }];
    balanceBtn.layer.cornerRadius = 29.f;
    
    UIView *balanceBarrierView = [UIView new];
    balanceBarrierView.backgroundColor = RGBColor(181, 181, 181, 1.f);
    [balanceTableHeaderView addSubview:balanceBarrierView];
    [balanceBarrierView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(balanceTableHeaderView);
        make.right.equalTo(balanceTableHeaderView);
        make.bottom.equalTo(balanceTableHeaderView);
        make.height.mas_equalTo(1);
    }];
    
    UILabel *balanceStatementLabel = [UILabel new];
    balanceStatementLabel.text = @"收支明细";
    balanceStatementLabel.textAlignment = 1;
    balanceStatementLabel.textColor = RGBColor(123, 123, 123, 1.f);
    balanceStatementLabel.font = [UIFont systemFontOfSize:11];
    balanceStatementLabel.backgroundColor = [UIColor whiteColor];
    [balanceTableHeaderView addSubview:balanceStatementLabel];
    [balanceStatementLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(balanceBarrierView);
        make.centerX.equalTo(balanceBarrierView);
        make.size.mas_equalTo(CGSizeMake(80, 20));
    }];
    
    _balanceTableView.tableHeaderView = balanceTableHeaderView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _balanceDataArr = [NSMutableArray array];
    _voucherDataArr = [NSMutableArray array];
    
    [self configNavigationItem];
    [self creatOthers];
    [self configTableView];
    [self configBalance];
}

- (void)configBalance
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:[USER_DEFAULT objectForKey:@"user_id"] forKey:@"user_id"];
    [params setValue:@"4" forKey:@"type"];
    [params setValue:@"3" forKey:@"group_id"];
    [MBProgressHUD showMessage:@"正在加载"];
    [DownloadManager post:@"http://112.124.115.81/m.php?m=UserApi&a=recharge" params:params success:^(id json) {
        
        @try {
            NYLog(@"%@",json);
            NSString *money = json[@"money"];
            UIView *view = _balanceTableView.tableHeaderView;
            UILabel *label = (UILabel *)[view viewWithTag:100];
            NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@元",money]];
            [attri addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:30]} range:NSMakeRange(0, money.length)];
            label.attributedText = attri;
            [MBProgressHUD hideHUD];
        }
        @catch (NSException *exception) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"网络错误"];
        }
        @finally {
            
        }
        
    } failure:^(NSError *error) {
        NYLog(@"%@",error.localizedDescription);
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络错误"];
    }];
    
    
    [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"UserApi",@"driver_bill"] params:@{@"driver_id":[USER_DEFAULT objectForKey:@"user_id"]} success:^(id json) {
        NYLog(@"%@",json);
        
        @try {
            [MBProgressHUD hideHUD];
            NSString *dataStr = [NSString stringWithFormat:@"%@",json[@"data"]];
            if ([dataStr isEqualToString:@"0"]) {
                [MBProgressHUD showSuccess:@"您暂时没有收支明细"];
                return ;
            } else if ([dataStr isEqualToString:@"1"]) {
                _balanceDataArr = json[@"info"];
                [_balanceTableView reloadData];
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
    } failure:^(NSError *error) {
        NYLog(@"%@",error.localizedDescription);
    }];
    
    [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"UserApi",@"user_show_ticket"] params:@{@"user_id":[USER_DEFAULT objectForKey:@"user_id"]} success:^(id json) {
        NYLog(@"%@",json);
        
        NSString *dataStr = [NSString stringWithFormat:@"%@",json[@"data"]];
        if ([dataStr isEqualToString:@"0"]) {
            [MBProgressHUD showError:@"您暂时没有代金券"];
        } else {
            _voucherDataArr = json[@"info"];
            
            CGFloat value = 0;
            for (NSDictionary *dic in _voucherDataArr) {
                value += [dic[@"price"] floatValue];
            }
            NSString *valueStr = [NSString stringWithFormat:@"%.2f",value];
            UIView *voucherHeaderView = _voucherTableView.tableHeaderView;
            UILabel *priceLabel = (UILabel *)[voucherHeaderView viewWithTag:400];
            NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@元",valueStr]];
            [attri addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:30]} range:NSMakeRange(0, valueStr.length)];
            priceLabel.attributedText = attri;
            
            [_voucherTableView reloadData];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络错误"];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _voucherTableView) {
        return _voucherDataArr.count;
    }
    else return _balanceDataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _voucherTableView) {
        return 80;
    } else {
        return 70;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _voucherTableView) {
        static NSString *cellId = @"VoucherTableViewCellReuseId";
        VoucherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"VoucherTableViewCell" owner:nil options:nil] lastObject];
        }
        [cell configModel:[[NYMyVoucherModel alloc] initWithDictionary:_voucherDataArr[indexPath.row] error:nil]];
        return cell;
    } else if (tableView == _balanceTableView) {
        static NSString *cellId = @"BalanceTableViewCellReuseId";
        NYMyBalanceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"NYMyBalanceTableViewCell" owner:nil options:nil] lastObject];
        }
        [cell configModel:[[NYMyBalanceModel alloc] initWithDictionary:_balanceDataArr[indexPath.row] error:nil]];
        return cell;
    }
    return nil;
}

#pragma mark - Action
- (void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cheackMyWallet:(UIButton *)btn
{
    UIButton *getBtn1 = [self.view viewWithTag:120];
    UIButton *getBtn2 = [self.view viewWithTag:121];
    
    //“我的钱包“被点击了
    if ( getBtn1.enabled) {
        getBtn1.backgroundColor = [UIColor whiteColor];
        [getBtn1 setTitleColor:RGBColor(99, 193, 255, 1.f) forState:UIControlStateNormal];
        
        getBtn2.backgroundColor = RGBColor(220, 220, 220, 1.f);
        [getBtn2 setTitleColor:RGBColor(192, 192, 192, 1.f) forState:UIControlStateNormal];
        
        
        getBtn1.enabled = NO;
        getBtn2.enabled = YES;
        _balanceTableView.hidden = NO;
        _voucherTableView.hidden = YES;
    }
//    “我的券”被点击了
    else {
        getBtn2.backgroundColor = [UIColor whiteColor];
        [getBtn2 setTitleColor:RGBColor(99, 193, 255, 1.f) forState:UIControlStateNormal];
        
        getBtn1.backgroundColor = RGBColor(220, 220, 220, 1.f);
        [getBtn1 setTitleColor:RGBColor(192, 192, 192, 1.f) forState:UIControlStateNormal];
        
        
        getBtn2.enabled = NO;
        getBtn1.enabled = YES;
        _balanceTableView.hidden = YES;
        _voucherTableView.hidden = NO;
        
//        [DownloadManager post:@"" params:param success:^(id json) {
//            
//        } failure:^(NSError *error) {
//            
//        }];
    }
}

@end
