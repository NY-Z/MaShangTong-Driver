//
//  GSsexView.h
//  MaShangTong
//
//  Created by q on 15/12/21.
//  Copyright © 2015年 NY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSsexView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>

{
    NSInteger sexNum;
}
@property (nonatomic,strong)void(^chooseSex)(NSString *sexStr);

@end
