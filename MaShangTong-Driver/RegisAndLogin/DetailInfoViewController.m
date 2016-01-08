//
//  DetailInfoViewController.m
//  MaShangTong-Driver
//
//  Created by NY on 15/11/24.
//  Copyright © 2015年 jeaner. All rights reserved.
//

#import "DetailInfoViewController.h"

@interface DetailInfoViewController () <UIWebViewDelegate>

@property (nonatomic,strong) UIWebView *webView;

@end

@implementation DetailInfoViewController

- (void)setNavigationBar
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.text = @"司机加盟";
    titleLabel.textAlignment = 1;
    titleLabel.textColor = RGBColor(112, 187, 254, 1.f);
    titleLabel.font = [UIFont systemFontOfSize:16];
    self.navigationItem.titleView = titleLabel;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:RGBColor(199, 199, 199, 1.f) forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [backBtn setImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
    backBtn.size = CGSizeMake(54, 44);
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}
- (void)initWebView
{
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    NSString *urlStr = [NSString stringWithFormat:@"http://112.124.115.81/admin/public/mst/zhuce2.php?id=%@",self.userId];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:urlRequest];
    [self.view addSubview:_webView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBar];
    [self initWebView];
}

#pragma mark - UIWebViewDelegate
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD showError:@"网络异常"];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NYLog(@"%@",request.URL.absoluteString);
    if ([request.URL.absoluteString hasPrefix:@"http://www."]) {
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        return NO;
    }
    return YES;
}

#pragma mark - Action
- (void)backBtnClicked:(UIButton *)btn
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
