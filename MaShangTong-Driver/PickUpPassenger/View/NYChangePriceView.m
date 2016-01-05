//
//  NYChangePriceView.m
//  MaShangTong-Driver
//
//  Created by NY on 15/12/29.
//  Copyright © 2015年 NY. All rights reserved.
//

#import "NYChangePriceView.h"

@implementation NYChangePriceView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.size = CGSizeMake(SCREEN_WIDTH, 45);
        [self configSubViews];
    }
    return self;
}

- (void)configSubViews
{
    UIView *barrierView = [[UIView alloc] initWithFrame:CGRectMake(50, 0, SCREEN_WIDTH-100, 1)];
    barrierView.backgroundColor = RGBColor(201, 201, 201, 201);
    [self addSubview:barrierView];
    
    UIButton *minusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    minusBtn.x = 50;
    minusBtn.y = 11;
    minusBtn.backgroundColor = [UIColor cyanColor];
    minusBtn.size = CGSizeMake(22, 22);
    [self addSubview:minusBtn];
    
    UIButton *plusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    plusBtn.x = SCREEN_WIDTH-50-22;
    plusBtn.y = 11;
    plusBtn.backgroundColor = [UIColor cyanColor];
    plusBtn.size = CGSizeMake(22, 22);
    [self addSubview:plusBtn];
}

@end
