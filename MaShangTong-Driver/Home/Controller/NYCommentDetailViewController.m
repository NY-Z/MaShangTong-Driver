//
//  NYCommentDetailViewController.m
//  MaShangTong-Driver
//
//  Created by NY on 15/12/28.
//  Copyright © 2015年 NY. All rights reserved.
//

#import "NYCommentDetailViewController.h"
#import "StarView.h"

@interface NYCommentDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *passengerHeaderView;
@property (weak, nonatomic) IBOutlet UILabel *passengerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *passengerMobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *passengerPriceLabel;
@property (weak, nonatomic) IBOutlet StarView *rateImageView;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

@end

@implementation NYCommentDetailViewController

- (void)configNavigationBar
{
    self.navigationItem.title = @"评价详情";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:RGBColor(99, 193, 255, 1.f)}];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    backBtn.size = CGSizeMake(22, 22);
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configNavigationBar];
    [self configDetail];
}

- (void)configDetail
{
    [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"UserApi",@"comment_detail"] params:@{@"route_id":_param[@"route_id"],@"user_id":_param[@"user_id"],@"driver_id":_param[@"driver_id"]} success:^(id json) {
        NYLog(@"%@",json);
        NSString *price = [NSString stringWithFormat:@"%.2f",[json[@"info"][@"price"][@"total_price"] floatValue]];
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@元",price]];
        [attri addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:42]} range:NSMakeRange(0, price.length)];
        _passengerPriceLabel.attributedText = attri;
        NSArray *arr = json[@"info"][@"res"];
        NSDictionary *dic = arr[0];
        _passengerNameLabel.text = dic[@"user_name"];
        NSMutableString *mulStr = [dic[@"mobile"] mutableCopy];
        [mulStr replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        _passengerMobileLabel.text = mulStr;
        _commentLabel.text = dic[@"content"];
        [_rateImageView setRating:[dic[@"stars"] floatValue]];
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络错误"];
    }];
    
}

#pragma mark - Action
- (void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
