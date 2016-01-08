//
//  NYMyCommentViewController.m
//  MaShangTong-Driver
//
//  Created by apple on 15/12/16.
//  Copyright © 2015年 jeaner. All rights reserved.
//

#import "NYMyCommentViewController.h"
#import "NYMyCommentTableViewCell.h"
#import "NYMyCommentModel.h"
#import "NYCommentDetailViewController.h"

@interface NYMyCommentViewController () <UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArr;
//    NYMyCommentModel *_myCommentModel;
}
@end

@implementation NYMyCommentViewController

- (void)configNavigationItem
{
    self.navigationItem.title = @"评价列表";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:21],NSForegroundColorAttributeName:RGBColor(73, 185, 254, 1.f)}];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    backBtn.size = CGSizeMake(22, 22);
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}

- (void)configTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
}

- (void)configDataArr
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:[USER_DEFAULT objectForKey:@"user_id"] forKey:@"driver_id"];
    [MBProgressHUD showMessage:@"正在加载"];
    [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"UserApi",@"comment"] params:params success:^(id json) {
        
        NYLog(@"%@",json);
        [MBProgressHUD hideHUD];
        @try {
            NSString *dataStr = [NSString stringWithFormat:@"%@",json[@"data"]];
            if ([dataStr isEqualToString:@"0"]) {
                [MBProgressHUD showError:@"您暂时还没有评价"];
                return ;
            } else if ([dataStr isEqualToString:@"1"]) {
                _dataArr = json[@"info"];
                [_tableView reloadData];
            }
        }
        @catch (NSException *exception) {
            [MBProgressHUD showError:@"网络错误"];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络错误"];
        NYLog(@"%@",error.localizedDescription);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArr = [NSMutableArray array];
    
    [self configNavigationItem];
    [self configTableView];
    [self configDataArr];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}

#pragma mark - UITableViewDatasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"NYMyCommentTableViewCell";
    NYMyCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NYMyCommentTableViewCell" owner:nil options:nil] lastObject];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NYMyCommentInfoModel *model = [[NYMyCommentInfoModel alloc] initWithDictionary:_dataArr[indexPath.row] error:nil];
    if ([model.head_image hasPrefix:@"http"]) {
        [cell.headerImage sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"sijitouxiang"]];
    }
    cell.dateLabel.text = model.add_time;
    cell.commentLabel.text = model.content;
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // 1.删除数据
        [_dataArr removeObjectAtIndex:indexPath.row];
        // 2.更新UITableView UI界面
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *param = _dataArr[indexPath.row];
    NYCommentDetailViewController *commentDetail = [[NYCommentDetailViewController alloc] init];
    commentDetail.param = param;
    [self.navigationController pushViewController:commentDetail animated:YES];
}

#pragma mark - Action
- (void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
