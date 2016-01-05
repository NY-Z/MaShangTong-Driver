//
//  StarView.m
//  LimitFree_1513
//
//  Created by gaokunpeng on 15/9/14.
//  Copyright (c) 2015年 gaokunpeng. All rights reserved.
//

#import "StarView.h"
#import "MyUtil.h"

@implementation StarView
{
    //前景图片
    UIImageView *_fgImageView;
}

//代码初始化时调用
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createImageView];
    }
    return self;
}

//xib初始化
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self createImageView];
    }
    return self;
}

//创建图片视图
- (void)createImageView
{
    //背景图片
    UIImageView *bgImageView = [MyUtil createImageViewFrame:CGRectMake(0, 0, 115, 23) imageName:@"StarsBackground"];
    [self addSubview:bgImageView];
    
    //前景图片
    _fgImageView = [MyUtil createImageViewFrame:CGRectMake(0, 0, 115, 23) imageName:@"StarsForeground"];
    //设置停靠模式
    _fgImageView.contentMode = UIViewContentModeLeft;
    _fgImageView.clipsToBounds = YES;
    [self addSubview:_fgImageView];
}

-(void)setRating:(float)rating
{
    _fgImageView.frame = CGRectMake(0, 0, 115*rating/5.0f, 23);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
