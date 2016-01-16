//
//  GSageView.h
//  MaShangTong
//
//  Created by q on 15/12/21.
//  Copyright © 2015年 NY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSageView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>

{
    NSInteger ageNum;
    NSArray *_dataAry;
}
@property (nonatomic,strong)void(^chooseAge)(NSString *ageStr);


@end
