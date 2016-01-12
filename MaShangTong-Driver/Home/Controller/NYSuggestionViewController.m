//
//  NYSuggestionViewController.m
//  MaShangTong-Personal
//
//  Created by NY on 16/1/6.
//  Copyright © 2016年 jeaner. All rights reserved.
//

#import "NYSuggestionViewController.h"

@interface NYSuggestionViewController ()

@property (weak, nonatomic) IBOutlet UITextView *suggestionTextView;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
- (IBAction)confirmBtnClicked:(id)sender;

@end

@implementation NYSuggestionViewController

- (void)configNavigationBar
{
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBarButtonItemClicked) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.size = CGSizeMake(44, 44);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    self.navigationItem.title = @"意见反馈";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:21],NSForegroundColorAttributeName:RGBColor(73, 185, 254, 1.f)}];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configNavigationBar];
    [self handleTheWeidget];
}

- (void)handleTheWeidget
{
    self.confirmBtn.layer.cornerRadius = 5.f;
    
    self.suggestionTextView.layer.cornerRadius = 5.f;
    self.suggestionTextView.layer.borderColor = RGBColor(109, 187, 248, 1.f).CGColor;
    self.suggestionTextView.layer.borderWidth = 1.f;
}

#pragma mark - Action
- (IBAction)confirmBtnClicked:(id)sender {
    
    if (_suggestionTextView.text.length < 10) {
        [MBProgressHUD showError:@"反馈内容过短，再说两句吧~"];
        return;
    }
    
    [MBProgressHUD showMessage:@"反馈中"];
    [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"UserApi",@"feedBack"] params:@{@"user_id":[USER_DEFAULT objectForKey:@"user_id"],@"content":_suggestionTextView.text} success:^(id json) {
       
        @try {
            [MBProgressHUD hideHUD];
            NSString *dataStr = [NSString stringWithFormat:@"%@",json[@"data"]];
            if ([dataStr isEqualToString:@"0"]) {
                [MBProgressHUD showError:@"反馈失败，请重试"];
                return ;
            } else if ([dataStr isEqualToString:@"1"]) {
                [self.navigationController popViewControllerAnimated:YES];
                [MBProgressHUD showSuccess:@"感谢您的反馈信息"];
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)leftBarButtonItemClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
