//
//  NYChangePriceView.m
//  MaShangTong-Driver
//
//  Created by NY on 15/12/29.
//  Copyright © 2015年 NY. All rights reserved.
//

#import "NYChangePriceView.h"

@implementation NYChangePriceView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title
{
    if (self = [super initWithFrame:frame]) {
        self.size = CGSizeMake(SCREEN_WIDTH, 45);
        [self configSubViewsWithTitle:title];
    }
    return self;
}

- (void)configSubViewsWithTitle:(NSString *)title
{
    UIView *barrierView = [[UIView alloc] initWithFrame:CGRectMake(50, 0, SCREEN_WIDTH-100, 1)];
    barrierView.backgroundColor = RGBColor(201, 201, 201, 201);
    [self addSubview:barrierView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-30, -8, 60, 16)];
    nameLabel.text = title;
    nameLabel.backgroundColor = [UIColor whiteColor];
    nameLabel.textColor = RGBColor(180, 180, 180, 1.f);
    nameLabel.font = [UIFont systemFontOfSize:12];
    nameLabel.textAlignment = 1;
    [self addSubview:nameLabel];
    
    UIButton *minusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [minusBtn setImage:[UIImage imageNamed:@"minus"] forState:UIControlStateNormal];
    minusBtn.x = 50;
    minusBtn.y = 11;
//    minusBtn.backgroundColor = [UIColor cyanColor];
    minusBtn.size = CGSizeMake(25, 25);
    [minusBtn addTarget:self action:@selector(minusBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:minusBtn];
    
    UIButton *plusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [plusBtn setImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
    plusBtn.x = SCREEN_WIDTH-50-25;
    plusBtn.y = 11;
//    plusBtn.backgroundColor = [UIColor cyanColor];
    plusBtn.size = CGSizeMake(25, 25);
    [plusBtn addTarget:self action:@selector(plusBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:plusBtn];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-40, 11, 80, 25)];
    priceLabel.text = @"0元";
    priceLabel.textAlignment = 1;
    priceLabel.tag = 100;
    priceLabel.font = [UIFont systemFontOfSize:18];
    priceLabel.textColor = RGBColor(150, 150, 150, 1.f);
    [self addSubview:priceLabel];
}

- (void)changePrice:(NSInteger)price
{
    UILabel *label = (UILabel *)[self viewWithTag:100];
    label.text = [NSString stringWithFormat:@"%li元",(long)price];
    _price = price;
}

- (void)minusBtnClicked
{
    if (_price == 0) {
        return;
    }
    _price--;
    UILabel *label = (UILabel *)[self viewWithTag:100];
    label.text = [NSString stringWithFormat:@"%li元",_price];
}

- (void)plusBtnClicked
{
    _price++;
    UILabel *label = (UILabel *)[self viewWithTag:100];
    label.text = [NSString stringWithFormat:@"%li元",_price];
}

@end
