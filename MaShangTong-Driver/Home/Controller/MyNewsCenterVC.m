//
//  MyNewsCenterVC.m
//  MaShangTong
//
//  Created by q on 15/12/10.
//  Copyright © 2015年 NY. All rights reserved.
//

#import "MyNewsCenterVC.h"
#import "MyNewsTableViewCell.h"

#import "AFNetworking.h"

@interface MyNewsCenterVC ()

@end

@implementation MyNewsCenterVC


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _newsDataAry = [NSArray new];
    _hightAry = [NSMutableArray new];
   
    [self sendOrder];
    
    [self dealNavicatonItens];

    
    [self creatTableView];
}
#pragma mark - 设置NavicatonItens
-(void)dealNavicatonItens
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    label.text = @"消息中心";
    label.textAlignment = 1;
    label.font = [UIFont systemFontOfSize:19];
    label.textColor = RGBColor(99, 193, 255, 1.f);
    
    self.navigationItem.titleView = label;
    
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    leftBtn.size = CGSizeMake(22, 22);
    [leftBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
}
//返回Btn的点击事件
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 创建TableView
-(void)creatTableView
{
    //上面一条灰色的线
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 20)];
    view.backgroundColor = RGBColor(220, 220, 220, 1.f);
    [self.view addSubview:view];
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 1, self.view.size.width, self.view.size.height-65) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource= self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _newsDataAry.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [_hightAry[indexPath.row] floatValue]+50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier  = @"MyNewsTableViewCell";
    MyNewsTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];

    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MyNewsTableViewCell" owner:nil options:nil]lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dic = _newsDataAry[indexPath.row];
    cell.timeLabel.text = [NSString stringWithFormat:@"%@,%@",dic[@"title"],dic[@"time"]];
    cell.detailsLabel.text = dic[@"content"];
    
    return cell;
}

#pragma mark - 网络请求，消息中心
-(void)sendOrder
{
    
    NSDictionary *param = [NSDictionary new];
    
    NSString *url = [NSString stringWithFormat:URL_HEADER,@"OrderApi",@"msg_notice"];
    [MBProgressHUD showMessage:@"加载中"];
    [DownloadManager post:url params:param success:^(id json) {
        
        @try {
            [MBProgressHUD hideHUD];
            if ([json[@"data"] isEqualToString:@"0"]) {
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 21)];
                label.text = @"啊哦~~没有消息~~~";
                label.textAlignment = 1;
                label.font = [UIFont systemFontOfSize:12];
                label.textColor = RGBColor(192, 192, 192, 0.9f);
                [self.view addSubview:label];
                
            }
            else{
                _newsDataAry = json[@"info"];
                for (NSDictionary *dic in _newsDataAry) {
                    NSString *content = [NSString stringWithFormat:@"%@",dic[@"content"]];
                    CGRect rect = [content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-64, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
                    [_hightAry addObject:[NSString stringWithFormat:@"%.2f",rect.size.height]];
                }
                [_tableView reloadData];
            }
        } @catch (NSException *exception) {
            
        } @finally {
            
        }

    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络错误"];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
