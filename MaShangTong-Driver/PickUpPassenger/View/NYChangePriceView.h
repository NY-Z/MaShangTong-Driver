//
//  NYChangePriceView.h
//  MaShangTong-Driver
//
//  Created by NY on 15/12/29.
//  Copyright © 2015年 NY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NYChangePriceView : UIView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title;

@property (nonatomic,assign) NSInteger price;
@property (nonatomic,copy) NSString *title;

- (void)changePrice:(NSInteger)price;

@end
