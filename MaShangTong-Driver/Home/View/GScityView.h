//
//  GScityView.h
//  MaShangTong
//
//  Created by q on 15/12/24.
//  Copyright © 2015年 NY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GScityView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>

@property  (nonatomic,retain) NSMutableArray *provinceAry;
@property (nonatomic,retain) NSMutableArray *cityAry;

@property (nonatomic,strong) void(^chooseCity)(NSString *cityName);

@end
