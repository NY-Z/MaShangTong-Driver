//
//  GScityView.m
//  MaShangTong
//
//  Created by q on 15/12/24.
//  Copyright © 2015年 NY. All rights reserved.
//

#import "GScityView.h"

@implementation GScityView

static NSInteger cityNum;
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self dealArray];
        [self creatTwoBtn];
        [self creatPickerV];
        
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - 添加取消和确定的Btn
-(void)creatTwoBtn
{
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 60, 40);
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [leftBtn setTitleColor:RGBColor(98, 190, 255, 1.f) forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(pickerLeftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:leftBtn];
    
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(SCREEN_WIDTH - 60, 0, 60, 40);
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn setTitleColor:RGBColor(98, 190, 255, 1.f) forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(pickerRightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rightBtn];
    
}
#pragma mark - btn的点击事件
-(void)pickerLeftBtnClicked:(UIButton *)sender
{
    [self removeFromSuperview];
}
-(void)pickerRightBtnClicked:(UIButton *)sender
{
    NSLog(@"%@",_cityAry[cityNum]);
    if (self.chooseCity) {
        self.chooseCity(_cityAry[cityNum]);
    }
    [self removeFromSuperview];
}
#pragma mark - 创建PickerView
-(void)creatPickerV
{
    UIPickerView *pickerV = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 180)];
    pickerV.dataSource = self;
    pickerV.delegate = self;
    
    [self addSubview:pickerV];
}

#pragma mark - 处理数据
-(void)dealArray
{
    _provinceAry = [NSMutableArray new];
    _cityAry = [NSMutableArray new];
    NSString *pathStr = [[NSBundle mainBundle]pathForResource:@"ProvincesAndCities" ofType:@"plist"];
    NSArray *plistArray = [NSArray arrayWithContentsOfFile:pathStr];
    for (NSDictionary *subDict in plistArray) {
        NSString *provinceStr = subDict[@"State"];
        [_provinceAry addObject:provinceStr];
    }
    
    NSDictionary *subDic = plistArray[0];
    NSArray *subAry = subDic[@"Cities"];
    for (NSDictionary *subDict in subAry) {
        [_cityAry addObject:subDict[@"city"]];
    }

}
#pragma mark - UIPickerViewDelegate,UIPickerViewDatasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return _provinceAry.count;
    }
    else{
        return _cityAry.count;
    }
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return _provinceAry[row];
    }
    else{
        return _cityAry[row];
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if (component == 0) {
        [_cityAry removeAllObjects];
        NSString *pathStr = [[NSBundle mainBundle]pathForResource:@"ProvincesAndCities" ofType:@"plist"];
        NSArray *plistArray = [NSArray arrayWithContentsOfFile:pathStr];
        NSLog(@"plistArray:%ld",plistArray.count);
        NSDictionary *subDic = plistArray[row];
        NSArray *subAry = subDic[@"Cities"];
        for (NSDictionary *subDict in subAry) {
            [_cityAry addObject:subDict[@"city"]];
        }
        [pickerView reloadAllComponents];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        cityNum = 0;
    }
    if (component == 1) {
        cityNum = row;
        NSLog(@"%ld",cityNum);
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
