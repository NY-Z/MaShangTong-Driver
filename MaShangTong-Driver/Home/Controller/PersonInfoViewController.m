//
//  PersonInfoViewController.m
//  MaShangTong
//
//  Created by niliu1h  on 15/10/17.
//  Copyright (c) 2015年 NY. All rights reserved.
//  个人信息

#import "PersonInfoViewController.h"
#import "PersonInfoCell.h"
#import "GSsexView.h"
#import "GSageView.h"
#import "GScityView.h"
#import "GSauthenticationVC.h"
#import "DriverInfoModel.h"
#import "GSchangePassWordVC.h"
#import "StarView.h"

#define kPersonInfoTitle @"title"
#define kPersonInfoSubTitle @"subTitle"

@interface PersonInfoViewController () <UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) GSsexView *sexV;
@property (nonatomic,strong) GSageView *ageV;
@property (nonatomic,strong) GScityView *cityV;
@property (nonatomic,strong) NSArray *contentAry;

@property (nonatomic,strong) DriverInfoModel *driverInfo;

@end

@implementation PersonInfoViewController

- (void)configTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/4, SCREEN_WIDTH, SCREEN_HEIGHT-SCREEN_WIDTH/4-64) style:UITableViewStylePlain];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (void)configAdImageView
{
    UIImageView *adImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"advertisementImage@2x"]];
    adImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/4);
    [self.view addSubview:adImageView];
}

- (void)configNavigationItem
{
    self.navigationItem.title = @"个人信息";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:RGBColor(99, 193, 255, 1.f)}];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    backBtn.size = CGSizeMake(22, 22);
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}

- (void)configChangeView
{
//    __weak typeof(self) weakSelf = self;
    __weak typeof(_tableView) weakTableView = _tableView;
    
    _sexV = [[GSsexView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-220-64, SCREEN_WIDTH, 220)];
    
    _sexV.chooseSex = ^(NSString *sexStr){
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
        PersonInfoCell *cell = [weakTableView cellForRowAtIndexPath:indexPath];
        if ([cell.subTitleLabel.text isEqualToString:sexStr]) {
            return ;
        }

        [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"UserApi",@"update_personalData"] params:@{@"user_id":[USER_DEFAULT objectForKey:@"user_id"],@"sex":sexStr} success:^(id json) {
            NSString *dataStr = [NSString stringWithFormat:@"%@",json[@"data"]];
            if ([dataStr isEqualToString:@"0"]) {
                [MBProgressHUD showError:@"个人资料修改失败"];
                return ;
            } else if ([dataStr isEqualToString:@"1"]) {
                [MBProgressHUD showSuccess:@"个人资料修改成功"];
                cell.subTitleLabel.text = sexStr;
                
                DriverInfoModel *driverInfo = [NSKeyedUnarchiver unarchiveObjectWithData:[USER_DEFAULT objectForKey:@"user_info"]];
                driverInfo.sex = sexStr;
                [USER_DEFAULT setObject:[NSKeyedArchiver archivedDataWithRootObject:driverInfo] forKey:@"user_info"];
                [USER_DEFAULT synchronize];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD showError:@"个人资料修改失败"];
        }];
        
    };
    
    _ageV = [[GSageView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-220-64, SCREEN_WIDTH, 220)];
    _ageV.chooseAge = ^(NSString *ageStr){
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
        PersonInfoCell *cell = [weakTableView cellForRowAtIndexPath:indexPath];
        if ([cell.subTitleLabel.text isEqualToString:ageStr]) {
            return ;
        }
        
        [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"UserApi",@"update_personalData"] params:@{@"user_id":[USER_DEFAULT objectForKey:@"user_id"],@"age":ageStr} success:^(id json) {
            NSString *dataStr = [NSString stringWithFormat:@"%@",json[@"data"]];
            if ([dataStr isEqualToString:@"0"]) {
                [MBProgressHUD showError:@"个人资料修改失败"];
                return ;
            } else if ([dataStr isEqualToString:@"1"]) {
                [MBProgressHUD showSuccess:@"个人资料修改成功"];
                cell.subTitleLabel.text = ageStr;
                
                DriverInfoModel *driverInfo = [NSKeyedUnarchiver unarchiveObjectWithData:[USER_DEFAULT objectForKey:@"user_info"]];
                driverInfo.snum = [ageStr substringWithRange:NSMakeRange(0, 2)];
                [USER_DEFAULT setObject:[NSKeyedArchiver archivedDataWithRootObject:driverInfo] forKey:@"user_info"];
                [USER_DEFAULT synchronize];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD showError:@"个人资料修改失败"];
        }];
        
    };
    
    _cityV = [[GScityView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-220-64, SCREEN_WIDTH, 220)];
    _cityV.chooseCity = ^(NSString *cityName){
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
        PersonInfoCell *cell = [weakTableView cellForRowAtIndexPath:indexPath];
        if ([cell.subTitleLabel.text isEqualToString:cityName]) {
            return ;
        }
        
        [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"UserApi",@"update_personalData"] params:@{@"user_id":[USER_DEFAULT objectForKey:@"user_id"],@"city":cityName} success:^(id json) {
            NSString *dataStr = [NSString stringWithFormat:@"%@",json[@"data"]];
            if ([dataStr isEqualToString:@"0"]) {
                [MBProgressHUD showError:@"个人资料修改失败"];
                return ;
            } else if ([dataStr isEqualToString:@"1"]) {
                [MBProgressHUD showSuccess:@"个人资料修改成功"];
                cell.subTitleLabel.text = cityName;
                DriverInfoModel *driverInfo = [NSKeyedUnarchiver unarchiveObjectWithData:[USER_DEFAULT objectForKey:@"user_info"]];
                driverInfo.city = cityName;
                [USER_DEFAULT setObject:[NSKeyedArchiver archivedDataWithRootObject:driverInfo] forKey:@"user_info"];
                [USER_DEFAULT synchronize];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD showError:@"个人资料修改失败"];
        }];
        
    };
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configDriverInfo];
    [self configNavigationItem];
    [self configAdImageView];
    [self configDataArr];
    [self configTableView];
    [self configChangeView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}

- (void)configDriverInfo
{
    _driverInfo = [NSKeyedUnarchiver unarchiveObjectWithData:[USER_DEFAULT objectForKey:@"user_info"]];
}

- (NSArray *)dataArr
{
    if (_dataArr == nil) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

- (void)configDataArr
{
    _dataArr = [@[@{kPersonInfoTitle:@"头像",kPersonInfoSubTitle:@""},
                 @{kPersonInfoTitle:@"昵称",kPersonInfoSubTitle:_driverInfo.user_name},
                 @{kPersonInfoTitle:@"性别",kPersonInfoSubTitle:_driverInfo.sex},
                  @{kPersonInfoTitle:@"年龄",kPersonInfoSubTitle:[NSString stringWithFormat:@"%@后",_driverInfo.byear]},
                 @{kPersonInfoTitle:@"所在地",kPersonInfoSubTitle:_driverInfo.city},
                 @{kPersonInfoTitle:@"手机",kPersonInfoSubTitle:_driverInfo.mobile},
                 @{kPersonInfoTitle:@"实名认证",kPersonInfoSubTitle:@"已认证"},
                  @{kPersonInfoTitle:@"修改密码",kPersonInfoSubTitle:@""}] mutableCopy];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 60;
    }
    return 38;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 65;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, -65, SCREEN_WIDTH, 65)];
        
        StarView *starView = [[StarView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-125/2, 20, 125, 25)];
        [starView setRating:[_driverInfo.point floatValue]];
        [tableFooterView addSubview:starView];
        
        UILabel *pointLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, 20)];
        pointLabel.text = [NSString stringWithFormat:@"%@分",_driverInfo.point];
        pointLabel.textAlignment = 1;
        pointLabel.textColor = RGBColor(109, 188, 209, 1.f);
        pointLabel.font = [UIFont systemFontOfSize:15];
        [tableFooterView addSubview:pointLabel];
        
        return tableFooterView;
    } else {
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"PersonInfoCellId";
    PersonInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[PersonInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId indexPath:indexPath];
        cell.separatorInset = UIEdgeInsetsMake(0, 25, 0, 0);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 6 || indexPath.row == 7) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    if (indexPath.row == 0) {
//        [cell.headerView sd_setImageWithURL:[NSURL URLWithString:_driverInfo.head_image] placeholderImage:[UIImage imageNamed:@"sijitouxiang"]];
        
        UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 35, 65, 65)];
        headerView.tag = 200;
        
        NSData *imageData = [USER_DEFAULT objectForKey:@"header_image"];
        if (imageData) {
            cell.headerView.image = [[UIImage alloc] initWithData:imageData];
        } else {
            if (_driverInfo.head_image) {
                [cell.headerView sd_setImageWithURL:[NSURL URLWithString:_driverInfo.head_image] placeholderImage:[UIImage imageNamed:@"sijitouxiang"]];
            } else {
                cell.headerView.image = [UIImage imageNamed:@"sijitouxiang"];
            }
        }
    }
    cell.titleLabel.text = _dataArr[indexPath.row][kPersonInfoTitle];
    cell.subTitleLabel.text = _dataArr[indexPath.row][kPersonInfoSubTitle];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    switch (row) {
        case 0:
        {
            [self pickCameraOrPhotos];
            break;
        }
        case 1:
        {
            [self creatAlertV];
            break;
        }
        case 2:
        {
            [self.view addSubview:_sexV];
            break;
        }
        case 3:
        {
            [self.view addSubview:_ageV];
            break;
        }
        case 4:
        {
            [self.view addSubview:_cityV];
            break;
        }
        case 5:
        {
            break;
        }
        case 6:
        {
            [self.navigationController pushViewController:[[GSauthenticationVC alloc] init] animated:YES];
            break;
        }
        case 7:
        {
            [self changeThePassWord];
        }
        default:
            break;
    }
}

- (void)pickCameraOrPhotos
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"打开相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        //资源类型为图片库
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
        //设置选择后的图片可被编辑
        picker.allowsEditing = YES;
        [self presentModalViewController:picker animated:YES];
        
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"打开相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        //判断是否有相机
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            //设置拍照后的图片可被编辑
            picker.allowsEditing = YES;
            //资源类型为照相机
            picker.sourceType = sourceType;
            [self presentModalViewController:picker animated:YES];
        }else {
            NSLog(@"该设备无摄像头");  
        }
    }]];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    UIImage *compressedImage;
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        
        UIImage *image = [editingInfo objectForKey:UIImagePickerControllerOriginalImage];
        NSString *mediaTyoe = [editingInfo objectForKey:UIImagePickerControllerMediaType];
        if ([mediaTyoe isEqualToString:(NSString *)kUTTypeImage]) {
            UIImage *editImage = [editingInfo objectForKey:UIImagePickerControllerEditedImage];
            UIImageWriteToSavedPhotosAlbum(editImage, self, nil, NULL);
            [MBProgressHUD showError:@"您刚刚拍摄的是视频,请重试"];
        }
        CGSize imageSize = CGSizeMake(42, 42);
        compressedImage = [self imageWithImage:image scaledToSize:imageSize];
    } else if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        
        UIImage *image = editingInfo[UIImagePickerControllerOriginalImage];
        compressedImage = [self imageWithImage:image scaledToSize:CGSizeMake(42, 42)];
    }
    
    NSData *compressedImageData = UIImagePNGRepresentation(compressedImage);
    if (!compressedImageData) {
        compressedImageData = UIImageJPEGRepresentation(compressedImage, 1.f);
    }
    NSLog(@"%@",[compressedImageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]);
    [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"UserApi",@"update_img"] params:@{@"user_id":[USER_DEFAULT objectForKey:@"user_id"],@"img":[compressedImageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]} success:^(id json) {
        
        NSString *dataStr = [NSString stringWithFormat:@"%@",json[@"data"]];
        if ([dataStr isEqualToString:@"0"]) {
            [MBProgressHUD showError:@"上传失败"];
            return ;
        }
        [MBProgressHUD showSuccess:@"上传成功"];
        [USER_DEFAULT setObject:compressedImageData forKey:@"header_image"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeUserHeaderImage" object:compressedImage];
        [USER_DEFAULT synchronize];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        PersonInfoCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
        cell.headerView.image = compressedImage;
        
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"图片上传失败"];
    }];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

// 图片压缩
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

-(void)creatAlertV
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"修改昵称" message:@"请输入昵称" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textFiled = [alert textFieldAtIndex:1];
    textFiled.keyboardType = UIKeyboardAppearanceDefault;
    alert.delegate = self;
    [alert show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        UITextField *textFiled = [alertView textFieldAtIndex:0];
        if (!textFiled.text) {
            [MBProgressHUD showError:@"昵称格式非法"];
            return;
        }
        [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"UserApi",@"update_personalData"] params:@{@"user_id":[USER_DEFAULT objectForKey:@"user_id"],@"user_name":textFiled.text} success:^(id json) {
            NSString *dataStr = [NSString stringWithFormat:@"%@",json[@"data"]];
            if ([dataStr isEqualToString:@"0"]) {
                [MBProgressHUD showError:@"昵称修改失败"];
            } else {
                [MBProgressHUD showSuccess:@"昵称修改成功"];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
                PersonInfoCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
                cell.subTitleLabel.text = textFiled.text;
                DriverInfoModel *driverInfo = [NSKeyedUnarchiver unarchiveObjectWithData:[USER_DEFAULT objectForKey:@"user_info"]];
                driverInfo.user_name = textFiled.text;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeUserInfo" object:textFiled.text];
                [USER_DEFAULT setObject:[NSKeyedArchiver archivedDataWithRootObject:driverInfo] forKey:@"user_info"];
                [USER_DEFAULT synchronize];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD showError:@"昵称修改失败"];
        }];
    }
}

- (void)changeThePassWord
{
    [self.navigationController pushViewController:[[GSchangePassWordVC alloc] init] animated:YES];
}

#pragma mark - Action
- (void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
