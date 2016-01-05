//
//  detailOrderVC.m
//  MaShangTong
//
//  Created by q on 15/12/19.
//  Copyright © 2015年 NY. All rights reserved.
//

#import "detailOrderVC.h"
#import "AFNetworking.h"

@interface detailOrderVC ()


@property  (nonatomic,copy) NSDictionary *dataDic;

@end

@implementation detailOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self dealNavicatonItens];
    
    [self sendOrder];
    
}
#pragma mark - 设置NavicatonItens
-(void)dealNavicatonItens
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    label.text = @"订单详细";
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
    NSLog(@"返回");
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)creatMoneyLabelStr
{
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat: @"%d 元",0]];
    [attriStr setAttributes:@{NSForegroundColorAttributeName:[UIColor blueColor],NSFontAttributeName:[UIFont systemFontOfSize:28]} range:NSMakeRange(0, attriStr.length-1)];
    self.moneyLabel.attributedText = attriStr;
}
#pragma mark - 网络请求，发单
-(void)sendOrder
{
    NSLog(@"%@",_route_id);
    [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"UserApi",@"userTrips_detail"] params:@{@"route_id":_route_id} success:^(id json) {
        NYLog(@"%@",json);
        _dataDic = json[@"info"];
        [self creatMoneyLabelStr];
        [self displayData];
    } failure:^(NSError *error) {
        
    }];
}
//展示数据
-(void)displayData
{
    _moneyLabel.attributedText = [self returnAttriString: _dataDic[@"total_price"]];
    _combinedLabel.text = [NSString stringWithFormat:@"%.2f元", [_dataDic[@"total_price"] floatValue]];
    _mileageLabel.text = [NSString stringWithFormat:@"%@公里", [self returnStrIfStringIsNil:_dataDic[@"mileage"]]];
    _carbonLabel.text = [NSString stringWithFormat:@"%@千克",[self returnStrIfStringIsNil:_dataDic[@"carbon_emission"]]];
    
    _carTypeLabel.text = @"用车类型：包车";
    _orginPointLabel.text = [NSString stringWithFormat:@"服务起点：%@", _dataDic[@"origin_name"] ];
    _endPointLabel.text = [NSString stringWithFormat:@"服务终点：%@",_dataDic[@"end_name"]];
    _timeLabel.text = [NSString stringWithFormat:@"下单时间：%@",_dataDic[@"create_time"]];
    
    
}
-(NSAttributedString *)returnAttriString:(NSString *)string
{
    CGFloat num = [string floatValue];
    
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat: @"%.2f 元",num]];
    [attriStr setAttributes:@{NSForegroundColorAttributeName:[UIColor blueColor],NSFontAttributeName:[UIFont systemFontOfSize:28]} range:NSMakeRange(0, attriStr.length-1)];
    self.moneyLabel.attributedText = attriStr;
    
    return attriStr;
}
-(NSString *)returnStrIfStringIsNil:(NSString *)String
{
    if (String.length == 0) {
        return [NSString stringWithFormat:@"%.2f",0.0];
    }
    else{
        return [NSString stringWithFormat:@"%.2f",[String floatValue]];
    }
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

- (IBAction)checkValuationRules:(id)sender {
}
@end
