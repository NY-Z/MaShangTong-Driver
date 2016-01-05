//
//  detailOrderVC.h
//  MaShangTong
//
//  Created by q on 15/12/19.
//  Copyright © 2015年 NY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface detailOrderVC : UIViewController


@property (nonatomic,copy) NSString *route_id;


@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *combinedLabel;
@property (weak, nonatomic) IBOutlet UILabel *preferentialLabel;

@property (weak, nonatomic) IBOutlet UILabel *mileageLabel;

@property (weak, nonatomic) IBOutlet UILabel *carbonLabel;


@property (weak, nonatomic) IBOutlet UILabel *carTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orginPointLabel;
@property (weak, nonatomic) IBOutlet UILabel *endPointLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


- (IBAction)checkValuationRules:(id)sender;

@end
