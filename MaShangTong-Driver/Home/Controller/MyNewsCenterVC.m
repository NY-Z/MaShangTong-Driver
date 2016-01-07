//
//  MyNewsCenterVC.m
//  MaShangTong
//
//  Created by q on 15/12/10.
//  Copyright © 2015年 NY. All rights reserved.
//

#import "MyNewsCenterVC.h"
#import "MyNewsTableViewCell.h"
#import "NYMyCenterModel.h"

@interface MyNewsCenterVC ()
{
    NSMutableArray *_heightArr;
}
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
   

    [self dealNavicatonItens];
    
    [self creatTableView];
    
    [self configDataArr];
}

- (void)configDataArr
{
    _heightArr = [NSMutableArray array];
    [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"OrderApi",@"msg_notice"] params:@{} success:^(id json) {
        
        @try {
            NSString *dataStr = [NSString stringWithFormat:@"%@",json[@"data"]];
            if ([dataStr isEqualToString:@"0"]) {
                [MBProgressHUD showError:@"暂时没有系统消息"];
                return ;
            } else if ([dataStr isEqualToString:@"1"]) {
                _newsDataAry = json[@"info"];
                for (NSDictionary *dic in _newsDataAry) {
                    NSString *content = [NSString stringWithFormat:@"【%@】%@",dic[@"title"],dic[@"content"]];
                    CGRect rect = [content boundingRectWithSize:CGSizeMake(260, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
                    [_heightArr addObject:[NSString stringWithFormat:@"%.2f",rect.size.height]];
                }
                [_tableView reloadData];
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD showError:@"网络错误"];
        
    }];
}

#pragma mark - 设置NavicatonItens
-(void)dealNavicatonItens
{
    self.navigationItem.title = @"消息中心";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:21],NSForegroundColorAttributeName:RGBColor(73, 185, 254, 1.f)}];
    
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    leftBtn.size = CGSizeMake(22, 22);
    [leftBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
}
//返回Btn的点击事件
-(void)backBtnClick
{
    NSLog(@"返回");
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
    _tableView.tableFooterView = [UIView new];
    
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _newsDataAry.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [_heightArr[indexPath.row] floatValue]+35;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier  = @"MyNewsTableViewCell";
    MyNewsTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MyNewsTableViewCell" owner:nil options:nil]lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSLog(@"%@",indexPath);
    }
    cell.detailsLabel.text = [NSString stringWithFormat:@"【%@】%@",_newsDataAry[indexPath.row][@"title"],_newsDataAry[indexPath.row][@"content"]];
    cell.timeLabel.text = [NSString stringWithFormat:@"码尚通播报%@",_newsDataAry[indexPath.row][@"time"]];
    return cell;
}
@end
