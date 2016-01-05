//
//  NYInvitationViewController.m
//  MaShangTong-Driver
//
//  Created by apple on 15/12/19.
//  Copyright © 2015年 jeaner. All rights reserved.
//

#import "NYInvitationViewController.h"

@interface NYInvitationViewController ()

- (IBAction)confirmBtnClicked:(id)sender;
@end

@implementation NYInvitationViewController

- (void)configNavigationBar
{
    self.navigationItem.title = @"邀请加盟";
    [self.navigationController.navigationBar setTitleTextAttributes:NAVIGATIONITEM_TITLE_PROPERTY];
    NAVIGATIONITEM_BACKBARBUTTONITEM;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configNavigationBar];
    [self handleTheWeidget];
}

- (void)handleTheWeidget
{
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
}

#pragma mark - Action
- (void)leftBarButtonItemClicked:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)confirmBtnClicked:(id)sender {
    
    [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"UserApi",@"user_recomment"] params:@{} success:^(id json) {
        
    } failure:^(NSError *error) {
        
    }];
    
}
@end
