//
//  GSageView.m
//  MaShangTong
//
//  Created by q on 15/12/21.
//  Copyright © 2015年 NY. All rights reserved.
//

#import "GSageView.h"

@implementation GSageView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self creatTwoBtn];
        [self crearPicker];
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
    if (self.chooseAge) {
        self.chooseAge([_dataAry objectAtIndex:(NSInteger)ageNum]);
    }
    
    [self removeFromSuperview];
}

-(void)crearPicker
{
    _dataAry = [NSArray arrayWithObjects:@"00后",@"90后",@"80后",@"70后", nil];
    
    UIPickerView *sexPickerV = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 180)];
    sexPickerV.delegate = self;
    sexPickerV.dataSource = self;
    
    [self addSubview:sexPickerV];
}
#pragma mark - UIPickerViewDelegate,UIPickerViewDatasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _dataAry.count;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _dataAry[row];
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    ageNum = row;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
