//
//  NYShareViewController.m
//  MaShangTong-Driver
//
//  Created by apple on 15/12/20.
//  Copyright © 2015年 jeaner. All rights reserved.
//

#import "NYShareViewController.h"
#import "UMSocial.h"

#import <WXApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <WeiboSDK.h>

@interface NYShareViewController () <UMSocialDataDelegate,UMSocialUIDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *momentsImageView;
@property (weak, nonatomic) IBOutlet UIImageView *friendsImageView;
@property (weak, nonatomic) IBOutlet UIImageView *qqshareImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sinaShareImageView;

@end

@implementation NYShareViewController

- (void)configNavigationBar
{
    self.navigationItem.title = @"我的分享";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:21],NSForegroundColorAttributeName:RGBColor(73, 185, 254, 1.f)}];
    NAVIGATIONITEM_BACKBARBUTTONITEM;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavigationBar];
    [self handleTheWeidget];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NAVIGATIONBAR_PROPERTY;
}

- (void)handleTheWeidget
{
    UITapGestureRecognizer *sinaTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sinaTaped)];
    [self.sinaShareImageView addGestureRecognizer:sinaTap];
    
    BOOL isWxInstalled = [WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi];
    if (!isWxInstalled) {
        self.momentsImageView.hidden = YES;
        self.friendsImageView.hidden = YES;
    } else {
        self.momentsImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *momentTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(momentsTaped)];
        [self.momentsImageView addGestureRecognizer:momentTap];
        
        self.friendsImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *friendTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(friendSTaped)];
        [self.friendsImageView addGestureRecognizer:friendTap];
    }
    
    BOOL isQqInstalled = [QQApiInterface isQQInstalled] && [QQApiInterface isQQSupportApi];
    if (!isQqInstalled) {
        self.qqshareImageView.hidden = YES;
    } else {
        UITapGestureRecognizer *qqTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(qqTaped)];
        [self.qqshareImageView addGestureRecognizer:qqTap];
    }
}

#pragma mark - UMSocialDataDelegate
- (void)didFinishGetUMSocialDataResponse:(UMSocialResponseEntity *)response
{
    NYLog(@"%@",response);
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //        [AppLanguageProcess getLanguageWithKey:@"TEXT_CANCEL"]
        //得到分享到的微博平台名
        NSString *responseDataStr = [[response.data allKeys] objectAtIndex:0];
        NYLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
        if ([responseDataStr isEqualToString:@"sina"]) {
            [MBProgressHUD showSuccess:@"新浪微博分享成功"];
        }
    }
}

#pragma mark - Action
- (void)leftBarButtonItemClicked:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - ShareAction
- (void)momentsTaped
{
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:@"分享内嵌文字" image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            NYLog(@"分享成功！");
        }
    }];
}

- (void)friendSTaped
{
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:@"分享内嵌文字" image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            NYLog(@"分享成功！");
        }
    }];
}

- (void)qqTaped
{
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:@"分享内嵌文字" image:nil location:nil urlResource:[[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeVideo url:@"http://umeng.com/social"] presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            NYLog(@"分享成功！");
        }
    }];
}

- (void)sinaTaped
{
    
//    if ([WeiboSDK isWeiboAppInstalled] && [WeiboSDK isCanShareInWeiboAPP] && [WeiboSDK isCanSSOInWeiboApp]) {
//    [MBProgressHUD showMessage:@"正在分享"];
//        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:@"分享内嵌文字，www.baidu.com" image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
//            if (response.responseCode == UMSResponseCodeSuccess) {
//                NYLog(@"分享成功！");
//                [MBProgressHUD hideHUD];
//                [MBProgressHUD showSuccess:@"分享成功！"];
//            }
//        }];
//    }
    //else {
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:(NSString *)UMSocialAppKey
                                          shareText:@"友盟社会化分享让您快速实现分享等社会化功能，http://umeng.com/social"
                                         shareImage:[UIImage imageNamed:@"icon.png"]
                                    shareToSnsNames:@[UMShareToSina]
                                           delegate:self];
//    }
}

@end









