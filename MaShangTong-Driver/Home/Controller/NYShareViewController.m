//
//  NYShareViewController.m
//  MaShangTong-Driver
//
//  Created by apple on 15/12/20.
//  Copyright © 2015年 jeaner. All rights reserved.
//

#import "NYShareViewController.h"
#import "UMSocial.h"

@interface NYShareViewController () <UMSocialDataDelegate,UMSocialUIDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *momentsImageView;
@property (weak, nonatomic) IBOutlet UIImageView *friendsImageView;
@property (weak, nonatomic) IBOutlet UIImageView *qqshareImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sinaShareImageView;

@end

@implementation NYShareViewController

- (void)configNavigationBar
{
    self.navigationItem.title = @"分享";
    [self.navigationController.navigationBar setTitleTextAttributes:NAVIGATIONITEM_TITLE_PROPERTY];
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
    self.momentsImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *momentTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(momentsTaped)];
    [self.momentsImageView addGestureRecognizer:momentTap];
    
    self.friendsImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *friendTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(friendSTaped)];
    [self.friendsImageView addGestureRecognizer:friendTap];
    
    UITapGestureRecognizer *qqTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(qqTaped)];
    [self.qqshareImageView addGestureRecognizer:qqTap];
    
    UITapGestureRecognizer *sinaTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sinaTaped)];
    [self.sinaShareImageView addGestureRecognizer:sinaTap];
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
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
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
            NSLog(@"分享成功！");
        }
    }];
}

- (void)friendSTaped
{
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:@"分享内嵌文字" image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
        }
    }];
}

- (void)qqTaped
{
    
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:@"分享内嵌文字" image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
        }
    }];
}

- (void)sinaTaped
{
//    [UMSocialSnsService presentSnsIconSheetView:self
//                                         appKey:(NSString *)UMSocialAppKey
//                                      shareText:@"你要分享的文字"
//                                     shareImage:nil
//                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,nil]
//                                       delegate:self];
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:@"分享内嵌文字" image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
        }
    }];
}

@end









