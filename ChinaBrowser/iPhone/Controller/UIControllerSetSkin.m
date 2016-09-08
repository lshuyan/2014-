//
//  UIControllerSetSkin.m
//  ChinaBrowser
//
//  Created by David on 14-3-14.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIControllerSetSkin.h"
#import "UIControllerScreenshot.h"
#import "UIControllerImageGroup.h"
#import "UIControllerImageAssets.h"

#import "BlockUI.h"

#import <AGCommon/UIImage+Common.h>

#import "UIScrollViewSetSkin.h"
#import "UIViewNav.h"

#import "UIImage+BlurredFrame.h"
#import "UIImage+ImageEffects.h"
#import "UIImage+Resize.h"
#import "KTAnimationKit.h"

#import <AssetsLibrary/AssetsLibrary.h>

@interface UIControllerSetSkin () <UIScrollViewSetSkinDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIControllerScreenshotDelegate, UIControllerImageAssetsDelegate>
{
    IBOutlet UIImageView *_imageViewBg;
    UIViewNav *_viewNav;
    IBOutlet UIScrollViewSetSkin *_scrollView;
    // 取消编辑
    UIButton *_btnCancelEdit;
    
    UIImagePickerController *_pickerController;

    NSInteger _fileIndex;
    BOOL _isInternal;
}

- (void)onTouchBack;

@end

@implementation UIControllerSetSkin

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _viewNav = [UIViewNav viewNav];
    _viewNav.title = self.title;
    [self.view addSubview:_viewNav];
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack addTarget:self action:@selector(onTouchBack) forControlEvents:UIControlEventTouchUpInside];
    [btnBack setImage:[UIImage imageWithBundleFile:@"iPhone/back_0.png"] forState:UIControlStateNormal];
    [btnBack setImage:[UIImage imageWithBundleFile:@"iPhone/back_1.png"] forState:UIControlStateHighlighted];
    [btnBack sizeToFit];
    
    UIButton *btnOk = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnOk addTarget:self action:@selector(onTouchOk) forControlEvents:UIControlEventTouchUpInside];
    [btnOk setTitle:LocalizedString(@"queding") forState:UIControlStateNormal];
    [btnOk setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnOk setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [btnOk setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [btnOk sizeToFit];
    _viewNav.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnOk];
    _viewNav.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];

    _imageViewBg.image = [AppSetting shareAppSetting].skinImage;

    _scrollView.delegateSetSkin = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)layoutSubViewsWithInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    if (UIUserInterfaceIdiomPad==UI_USER_INTERFACE_IDIOM()) return;
    
    [_viewNav resizeWithOrientation:orientation];
    
    if (_btnCancelEdit) {
        CGRect rc = _btnCancelEdit.frame;
        rc.size.width = self.view.width;
        rc.size.height = IsPortrait?44:32;
        rc.origin = CGPointMake(0, self.view.height-rc.size.height);
        _btnCancelEdit.frame = rc;
        
        _scrollView.frame = CGRectMake(0, _viewNav.bottom, self.view.width, _btnCancelEdit.top-_viewNav.bottom);
    }
    else {
        CGRect rc = _scrollView.frame;
        rc.origin.y = _viewNav.bottom;
        rc.size.height = self.view.height-rc.origin.y;
        _scrollView.frame = rc;
    }
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)onTouchBack
{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)onTouchOk
{
    if ([AppSetting shareAppSetting].skinInfo.isAppInternal != _scrollView.skinInfo.isAppInternal ||
        [AppSetting shareAppSetting].skinInfo.skinIndex != _scrollView.skinInfo.skinIndex) {
        [AppSetting shareAppSetting].skinInfo = _scrollView.skinInfo;
        [_delegate controllerSetSkinDidChanageSkin:self];
    }
    
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)onTouchCancelEdit
{
    [_scrollView setEdit:NO];
}

- (void)onTouchGroup
{
    UIControllerImageGroup *controller = [UIControllerImageGroup controllerFromXib];
    controller.controller = self;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - UIScrollViewSetSkinDelegate
- (void)scrollViewSetSkin:(UIScrollViewSetSkin *)scrollViewSetSkin selectSkinFileIndex:(NSInteger)fileIndex isInternal:(BOOL)isInternal
{
    _fileIndex = fileIndex;
    _isInternal = isInternal;
    
    SkinInfo skinInfo;
    skinInfo.isAppInternal = isInternal;
    skinInfo.skinIndex = fileIndex;
    _imageViewBg.image = [[AppSetting shareAppSetting] getSkinImageWithSkinInfo:skinInfo];
    [KTAnimationKit animationEaseIn:_imageViewBg];
}

- (void)scrollViewSetSkinWillAddSkin:(UIScrollViewSetSkin *)scrollViewSetSkin
{
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:LocalizedString(@"quxiao") destructiveButtonTitle:nil otherButtonTitles:LocalizedString(@"paizhao"), LocalizedString(@"congxiangcexuanqu"), nil];
    [action showInView:self.view withCompletionHandler:^(NSInteger buttonIndex) {
        if (buttonIndex==action.cancelButtonIndex) {
            return;
        }
        
        if (0==buttonIndex) {
            // take photo
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = self;
                _pickerController = imagePicker;
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:LocalizedString(@"zhaoxiangjibukeyong") delegate:nil cancelButtonTitle:LocalizedString(@"quxiao") otherButtonTitles:LocalizedString(@"congxiangcexuanqu"), nil];
                [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
                    if (buttonIndex==1)
                    {
                        
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

- (void)scrollViewSetSkin:(UIScrollViewSetSkin *)scrollViewSetSkin didChangedEdit:(BOOL)edit
{
    if (edit) {
        CGRect rc = CGRectZero;
        rc.size.width = self.view.width;
        rc.size.height = IsPortrait?40:32;
        rc.origin.x = 0;
        rc.origin.y = self.view.height-rc.size.height;
        _btnCancelEdit = [[UIButton alloc] initWithFrame:rc];
        [_btnCancelEdit addTarget:self action:@selector(onTouchCancelEdit) forControlEvents:UIControlEventTouchUpInside];
        [_btnCancelEdit setTitle:LocalizedString(@"wancheng") forState:UIControlStateNormal];
        [_btnCancelEdit setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_btnCancelEdit setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        _btnCancelEdit.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
        _btnCancelEdit.transform = CGAffineTransformMakeTranslation(0, _btnCancelEdit.height);
        [self.view addSubview:_btnCancelEdit];
        [UIView animateWithDuration:0.3 animations:^{
            _btnCancelEdit.transform = CGAffineTransformIdentity;
            _scrollView.frame = CGRectMake(0, _viewNav.bottom, self.view.width, _btnCancelEdit.top-_viewNav.bottom);
        }];
    }
    else {
        [UIView animateWithDuration:0.3 animations:^{
            _btnCancelEdit.transform = CGAffineTransformMakeTranslation(0, _btnCancelEdit.height);
            _scrollView.frame = CGRectMake(0, _viewNav.bottom, self.view.width, self.view.height-_viewNav.bottom);
        } completion:^(BOOL finished) {
            [_btnCancelEdit removeFromSuperview];
            _btnCancelEdit = nil;
        }];
    }
    
    [(UIButton *)_viewNav.rightBarButtonItem.customView setEnabled:!edit];
}

#pragma mark - UIControllerScreenshotDelegate
-(void)controller:(UIControllerScreenshot *)controller didCaptureImage:(UIImage *)image
{
    if (self.navigationController.topViewController != self) {
        [self.navigationController popToViewController:self animated:NO];
    }
    
//    [_pickerController dismissModalViewControllerAnimated:NO];
    
    // 图片在这里
    NSString *szTime = [[@((NSInteger)[[NSDate date] timeIntervalSince1970]) stringValue] stringByAppendingPathExtension:@"jpg"];
    // UIImage* imageOriginal = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSString *dicPath = GetDocumentDirAppend(kSkinDirName);
    NSString *filepath = [dicPath stringByAppendingPathComponent:szTime];
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    CGFloat scale = [[UIScreen mainScreen] scale];
    size = CGSizeApplyAffineTransform(size, CGAffineTransformMakeScale(scale, scale));
    if (image.size.width>size.width && image.size.height>size.height) {
        image = [image scaleImageWithSize:size];
    }
    
    [UIImageJPEGRepresentation(image, 1) writeToFile:filepath atomically:YES];
    
    [_scrollView addSkinImageWithPath:filepath animated:YES];
    
    [_scrollView selectLastSkinImage];
}

#pragma mark - UINavigationControllerDelegate, UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* imageOriginal = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [_pickerController dismissViewControllerAnimated:NO completion:nil];
    
    [self presentControllerScreenshotWithImage:imageOriginal];
}

#pragma mark - UIControllerScreenshotDelegate
-(void)controller:(UIControllerImageAssets *)picker didFinishPickingAssets:(ALAsset *)assets
{
    CGImageRef ref = [[assets  defaultRepresentation]fullResolutionImage];
    
    UIImage *img = [[UIImage alloc]initWithCGImage:ref scale:[[UIScreen mainScreen] scale] orientation:UIImageOrientationUp];
    
    [self presentControllerScreenshotWithImage:img];

}

/**
 *  跳转到截取皮肤
 *
 *  @param image 选取的图片
 */
-(void)presentControllerScreenshotWithImage:(UIImage *)image
{
    UIControllerScreenshot *controller = [UIControllerScreenshot controllerFromXib];
    controller.delegate = self;
    controller.screenshotType = ScreenshotSkin;
//    UIImage * a=[image rotate:UIImageOrientationUp];
//    UIImageOrientation aa = a.imageOrientation;
//    UIImageOrientation imageOrientation = image.imageOrientation;
//    CGSize imagesize= image.size;
//    CGSize asize = a.size;
    controller.imageOriginal = [image rotate:UIImageOrientationUp];//转正相片
    [self.navigationController pushViewController:controller animated:YES];
}

//pickerController消失的动画
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [UIView animateWithDuration:0.35 animations:^{
        picker.view.transform = CGAffineTransformMakeScale(0.001, 0.001);
        picker.view.alpha = 0;
    } completion:^(BOOL finished) {
        [picker.view removeFromSuperview];
        [picker removeFromParentViewController];
    }];
}

@end
