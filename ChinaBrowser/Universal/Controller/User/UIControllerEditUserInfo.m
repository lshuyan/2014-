//
//  UIControllerEditUserInfo.m
//  ChinaBrowser
//
//  Created by HHY on 14/11/3.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIControllerEditUserInfo.h"

#import "UIControllerEditNick.h"
#import "UIControllerScreenshotIcon.h"
#import "UIControllerImageGroup.h"
#import "UIControllerImageGroup.h"
#import "UIControllerImageAssets.h"

#import "UserManager.h"
#import "ModelUser.h"
#import "UICellEditIcon.h"

#import "UIViewPopGender.h"

#import "UIImageView+WebCache.h"
#import "UIImage+Resize.h"

#import <AGCommon/UIImage+Common.h>
#import <AGCommon/NSData+Common.h>
#import "BlockUI.h"

@interface UIControllerEditUserInfo ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIControllerScreenshotIconDelegate, UIViewPopGenderDelegate, UIControllerEdintNickDelegate, UIControllerImageAssetsDelegate>
{
    UIImagePickerController *_pickerController;
    NSArray *_arrGender;
    AFJSONRequestOperation *_reqModify;
    UICellEditIcon *_cellEdit;
}
@end

@implementation UIControllerEditUserInfo

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _arrGender = @[@{@"type":@(UserGenderMale), @"gender":@"nan"},
                 @{@"type":@(UserGenderFemale), @"gender":@"nv"},
                 @{@"type":@(UserGenderSecrecy), @"gender":@"baomi"}];
    
    self.title = LocalizedString(@"gerenxinxi");
    _viewNav = [UIViewNav viewNav];
    _viewNav.title = self.title;
    [self.view addSubview:_viewNav];
    UIButton *btnBack =[UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setImage:[UIImage imageWithBundleFile:@"iPhone/back_0.png"] forState:UIControlStateNormal];
    [btnBack setImage:[UIImage imageWithBundleFile:@"iPhone/back_1.png"] forState:UIControlStateHighlighted];
    [btnBack addTarget:self action:@selector(onTouchBtnBack) forControlEvents:UIControlEventTouchUpInside];
    [btnBack sizeToFit];
    _viewNav.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btnBack];
    
}

/**
 *  屏幕旋转
 *
 *  @param toInterfaceOrientation
 *  @param duration
 */
-(void)layoutSubViewsWithInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    if (UIUserInterfaceIdiomPad==UI_USER_INTERFACE_IDIOM()) return;
    
    [_viewNav resizeWithOrientation:orientation];
    
    CGRect rc = _tableView.frame;
    rc.origin.y = _viewNav.bottom;
    rc.size.height = self.view.height-rc.origin.y;
    _tableView.frame = rc;
}

//返回按钮 lianjie
-(void)onTouchBtnBack
{
    [SVProgressHUD dismiss];
    [_reqModify cancel];
    _reqModify = nil;
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isEqualIndexPath:indexPath section:0 row:0]) {
        return 80;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indexPath.row==0?@"UICellEditIcon":@"UICellSysNone"];
    if (!cell) {
        if (indexPath.row==0) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"UICellEditIcon" owner:self options:nil] lastObject];
        }
        else{
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UICellSysNone"];
        }
    }

    //头像
    if ([self isEqualIndexPath:indexPath section:0 row:0]) {
        
        if (!_cellEdit) {
            _cellEdit = (UICellEditIcon *)cell;
            _cellEdit.textLabel.text = LocalizedString(@"touxiang");
            _cellEdit.textLabel.backgroundColor = [UIColor clearColor];
        }
        __weak UIImageView *wImageViewIcon = (UIImageView *)_cellEdit.imageViewIcon;
        [wImageViewIcon setImageWithURL:[NSURL URLWithString:[UserManager shareUserManager].currUser.avatar]
             placeholderImage:[UIImage imageWithBundleFile:@"iPhone/User/avatar_default.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                 if (image) {
                     wImageViewIcon.image = [UIImage imageWithData:UIImagePNGRepresentation(image) scale:[UIScreen mainScreen].scale];
                 }
                 else {
                     wImageViewIcon.image = [UIImage imageWithBundleFile:@"iPhone/User/avatar_default.png"];
                 }
             }];
        
    }//昵称
    else if ([self isEqualIndexPath:indexPath section:0 row:1]) {
        cell.textLabel.text = LocalizedString(@"nicheng");
        cell.detailTextLabel.text = [UserManager shareUserManager].currUser.nickname;
    }//性别
    else if ([self isEqualIndexPath:indexPath section:0 row:2]) {
        cell.textLabel.text = LocalizedString(@"xingbie");
        NSInteger genderIndex = [UserManager shareUserManager].currUser.gender-1;
        if (genderIndex<0) {
            genderIndex = 2;
        }
        NSDictionary *dicGender = _arrGender[genderIndex];
        cell.detailTextLabel.text = LocalizedString(dicGender[@"gender"]);
    }
    
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //换头像
    if ([self isEqualIndexPath:indexPath section:0 row:0]) {
        [self onTouthChangeIcon];
    }
    else if([self isEqualIndexPath:indexPath section:0 row:1])
    {
        //换昵称
        UIControllerEditNick *vc = [UIControllerEditNick controllerFromXib];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if([self isEqualIndexPath:indexPath section:0 row:2 ])
    {
        //换性别
        _DEBUG_LOG(@"%s",__FUNCTION__);
        UIViewPopGender *viewPop = [UIViewPopGender viewFromXib];
        viewPop.delegate = self;
        viewPop.labelTitle.text = LocalizedString(@"xuanzexingbie");
        [viewPop showInView:self.view completion:nil];
    }
    
}

/**
 *  比较indexpath
 *
 *  @param section   如果section 为-1  只比较row
 *  @param row       同上
 *
 */
-(BOOL)isEqualIndexPath:(NSIndexPath*)indexPath section:(NSInteger)section row:(NSInteger)row
{
    if (section==-1) {
        return (indexPath.row==row);
    }
    else if (row==-1) {
        return (indexPath.section==section);
    }
    else
    {
        return (indexPath.section==section && indexPath.row==row);
    }
}

//相册选择
-(void)onTouthChangeIcon
{
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:LocalizedString(@"quxiao") destructiveButtonTitle:nil otherButtonTitles:LocalizedString(@"paizhao"), LocalizedString(@"congxiangcexuanqu"), nil];
    [action showInView:self.view withCompletionHandler:^(NSInteger buttonIndex) {
        if (buttonIndex==action.cancelButtonIndex) {
            return;
        }
    
        if (0==buttonIndex) {
            // take photo
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = self;
                _pickerController = imagePicker;
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:imagePicker animated:YES completion:nil];
//                showPicker(imagePicker);
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:LocalizedString(@"zhaoxiangjibukeyong") delegate:nil cancelButtonTitle:LocalizedString(@"quxiao") otherButtonTitles:LocalizedString(@"congxiangcexuanqu"), nil];
                [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
                    if (buttonIndex==1) {
                        
                        [self onTouchGroup];
                    }
                }];
            }
            
        }
        else if (1==buttonIndex) {
            
            [self onTouchGroup];
        }
    }];
}

/**
 *  相册
 */
- (void)onTouchGroup
{
    UIControllerImageGroup *controller = [[UIControllerImageGroup alloc]initWithNibName:@"UIControllerImageGroup" bundle:nil];
    controller.controller = self;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - UIControllerScreenshotDelegate

-(void)controllerScreenshotIcon:(UIControllerScreenshotIcon *)cropperViewController didFinished:(UIImage *)editedImage
{

    NSLog(@"image.size == %@",NSStringFromCGSize(editedImage.size));
    NSLog(@"sdfffffff");
    if (self.navigationController.topViewController != self) {
        [self.navigationController popToViewController:self animated:NO];
    }
    
    _cellEdit.imageViewIcon.image = editedImage;
    
    [self doEditWithImageIcon:editedImage nick:nil gender:-1];
}


#pragma mark - UINavigationControllerDelegate, UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* imageOriginal = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [_pickerController dismissViewControllerAnimated:NO completion:nil];
    
    [self presentControllerScreenshotWithImage:imageOriginal];
}

-(void)controller:(UIControllerImageAssets *)picker didFinishPickingAssets:(ALAsset *)assets
{
    CGImageRef ref = [[assets  defaultRepresentation]fullResolutionImage];
    
    UIImage *img = [[UIImage alloc]initWithCGImage:ref scale:1 orientation:UIImageOrientationUp];
    
    [self presentControllerScreenshotWithImage:img];
}

/**
 *  跳转到截取头像
 *
 *  @param image 相册 或 相机中选取的图片
 */
-(void)presentControllerScreenshotWithImage:(UIImage *)image
{
    
    UIControllerScreenshotIcon *controller = [[UIControllerScreenshotIcon alloc]initWithImage:[image rotate:UIImageOrientationUp]];//把图片方向修改.
    controller.delegate = self;
//    [self.navigationController pushViewController:controller animated:YES];
    [self presentViewController:controller animated:YES completion:nil];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



#pragma mark - UIViewPopGenderDelegate
- (void)viewPopGender:(UIViewPopGender *)viewPopGender selectedGender:(NSInteger)gender
{
    [self doEditWithImageIcon:nil nick:nil gender:gender];
//    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    NSDictionary *dicGender = _arrGender[gender-1];
    cell.detailTextLabel.text = LocalizedString(dicGender[@"gender"]);
}

#pragma mark - UIControllerEditdDelegate
- (void)controller:(UIControllerEditNick *)controller edinNick:(NSString *)nick
{
    [self doEditWithImageIcon:nil nick:nick gender:-1];
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    cell.detailTextLabel.text = nick;
}

/**
 *  用户修改逻辑
 */
- (void)doEditWithImageIcon:(UIImage *)imageIcom nick:(NSString *)nick  gender:(NSInteger)gender
{
    //防止多次登录
    [_reqModify cancel];
    _reqModify = nil;
    
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionaryWithDictionary:@{@"uid":@([UserManager shareUserManager].currUser.uid),
                                                                                    @"token":[UserManager shareUserManager].currUser.token}];
    //昵称
    if (nick) {
        dicParam[@"nickname"] = nick;
    }
    
    //性别
    if (gender>-1) {
        gender -= 1;
        if (gender<0) {
            gender = 2;
        }
        NSDictionary *dicGender = _arrGender[gender];
        dicParam[@"gender"] = dicGender[@"type"];
    }
    
    //头像
    if (imageIcom) {
        NSData *imageData = UIImagePNGRepresentation(imageIcom);
        dicParam[@"avatar"] = [imageData base64Encoding];
    }
    
    __weak UITableView *tableview = _tableView;
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@""]];
    NSMutableURLRequest *req = [client multipartFormRequestWithMethod:@"POST" path:GetApiWithName(API_UserEdit) parameters:dicParam constructingBodyWithBlock:nil];
    _reqModify = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        _DEBUG_LOG(@"\n------modify user result:%@", JSON);
        
        BOOL flag = NO;
        NSInteger error = -1;
        NSString *msg;
        do {
            if (![JSON isKindOfClass:[NSDictionary class]]) break;
            
            {
                msg = JSON[@"msg"];
                error = [JSON[@"error"] integerValue];
            }
            
            NSDictionary *dicUser = JSON[@"data"];
            if (![dicUser isKindOfClass:[NSDictionary class]]) break;
            
            ModelUser *modelUser = [ModelUser modelWithDict:dicUser];
            // 个人信息持久化
            [[UserManager shareUserManager] updateUser:modelUser];
            _DEBUG_LOG(@"%@", modelUser.avatar);
            [_cellEdit.imageViewIcon setImageWithURL:[NSURL URLWithString:modelUser.avatar] placeholderImage:_cellEdit.imageViewIcon.image];
            
            flag = YES;
        } while (NO);
        
        if (flag) {
            [SVProgressHUD showSuccessWithStatus:LocalizedString(@"baocunchenggong")];
//            [_tableView reloadData];
            [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationDidUpdateUserInfo object:nil];
        }
        else {
            [SVProgressHUD showErrorWithStatus:LocalizedString(@"baocunshibai")];
        }
        tableview.userInteractionEnabled = YES;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"failure__%@",(NSDictionary*)JSON);
        
        [SVProgressHUD showErrorWithStatus:LocalizedString(@"denglushibai")];
        
        tableview.userInteractionEnabled = YES;
    }];
    
    if (imageIcom) {
        [_reqModify setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            [SVProgressHUD showProgress:totalBytesWritten*1.0/totalBytesExpectedToWrite status:nil maskType:SVProgressHUDMaskTypeClear];
            tableview.userInteractionEnabled = NO;
        }];
    }
    
    [_reqModify start];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
}

@end