//
//  SelfCardViewController.h
//  PPTravel
//
//  Created by mac on 26/1/24.
//  Copyright © 2026年 xinfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelfCardViewController : UIViewController

- (IBAction)back:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic,strong) void (^selectBankCard) (NSDictionary *dic,NSString *text);

@end
