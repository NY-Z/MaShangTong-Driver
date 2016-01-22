//
//  SelfCardViewController.m
//  PPTravel
//
//  Created by mac on 26/1/24.
//  Copyright © 2026年 xinfu. All rights reserved.
//

#import "SelfCardViewController.h"
#import "AddCardViewController.h"
#import "SelfCardTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

#define color_systemOrange RGBColor(112, 191, 253, 1.f)

@interface SelfCardViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray *cardArr;

@end

@implementation SelfCardViewController

- (NSMutableArray *)cardArr
{
    if (_cardArr == nil) {
        _cardArr = [NSMutableArray array];
    }
    return _cardArr;
}

- (void)configNavigationBar
{
    self.navigationItem.title = @"我的银行卡";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:21],NSForegroundColorAttributeName:RGBColor(73, 185, 254, 1.f)}];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    backBtn.size = CGSizeMake(22, 22);
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [editBtn setImage:[UIImage imageNamed:@"bianji"] forState:UIControlStateNormal];
    editBtn.size = CGSizeMake(22, 22);
    [editBtn addTarget:self action:@selector(editBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
}

- (void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mainTableView.backgroundColor = background_Color;
    self.mainTableView.tableFooterView = [UIView new];
    [self createCard];
    [self configNavigationBar];
}

-(void)createCard{
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
}

- (void)configDataSource
{
    [MBProgressHUD showMessage:@"加载中"];
    [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"orderApi",@"myCards"] params:@{@"user_id":[USER_DEFAULT objectForKey:@"user_id"]} success:^(id json) {
        @try {
            NSString *dataStr = [NSString stringWithFormat:@"%@",json[@"data"]];
            [MBProgressHUD hideHUD];
            if ([dataStr isEqualToString:@"1"]) {
                _cardArr = [json[@"info"] mutableCopy];
                [_mainTableView reloadData];
            } else {
                [MBProgressHUD showError:json[@"info"]];
            }
        } @catch (NSException *exception) {
            
        } @finally {
        
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"查询失败，请重试"];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self configDataSource];
}

-(void)addCard{
    [self.navigationController pushViewController:[[AddCardViewController alloc] init] animated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return _cardArr.count;
    }else
        return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return 80;
    }
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    if (section == 0) {
        view.frame = CGRectMake(0, 0, 0, 0);
    }else{
        view.frame = CGRectMake(0, 0, SCREEN_HEIGHT-40, 50);
        view.backgroundColor = background_Color;
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 15, SCREEN_WIDTH-20, 45)];
        [btn addTarget:self action:@selector(addCard) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[UIImage imageNamed:@"addCard"] forState:UIControlStateNormal];
        [view addSubview:btn];
    }
    return view;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"SelfCardTableViewCell";
    SelfCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (indexPath.section == 0) {
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SelfCardTableViewCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.backView.layer.masksToBounds = YES;
        cell.backView.layer.cornerRadius = 6.0;
        cell.backView.layer.borderWidth = 1.0;
        cell.backView.layer.borderColor = [[UIColor whiteColor] CGColor];
        self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    cell.backgroundColor = [UIColor clearColor];
    NSDictionary *dic = _cardArr[indexPath.row];
    NSString *cardNum = dic[@"car_num"];
    NSString *newStr = [cardNum substringWithRange:NSMakeRange(cardNum.length-4, 4)];
    cell.label.text = [NSString stringWithFormat:@"%@（尾号为%@）",dic[@"bank_name"],newStr];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectBankCard) {
        SelfCardTableViewCell *cell = (SelfCardTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        self.selectBankCard(_cardArr[indexPath.row],cell.label.text);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary *dic = _cardArr[indexPath.row];
        [MBProgressHUD showMessage:@"正在删除"];
        [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"orderApi",@"del_card"] params:@{@"bank_id":dic[@"bank_id"]} success:^(id json) {
            [MBProgressHUD hideHUD];
            @try {
                NSString *dataStr = [NSString stringWithFormat:@"%@",json[@"data"]];
                if ([dataStr isEqualToString:@"1"]) {
                    [MBProgressHUD showSuccess:@"删除成功"];
                    [_cardArr removeObjectAtIndex:indexPath.row];
                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                } else {
                    [MBProgressHUD showError:@"删除失败，请重试"];
                }
            } @catch (NSException *exception) {
                
            } @finally {
                
            }
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"删除失败，请重试"];
            NYLog(@"%@",error.localizedDescription);
        }];
    }
}

- (void)editBtnClick
{
    [_mainTableView setEditing:!_mainTableView.editing animated:YES];
}



@end
