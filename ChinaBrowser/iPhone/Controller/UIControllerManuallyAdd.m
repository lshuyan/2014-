//
//  UIControllerManuallyAdd.m
//  ChinaBrowser
//
//  Created by 石显军 on 14/11/20.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIControllerManuallyAdd.h"

#import "UIViewNav.h"

#import "ModelApp.h"

#import "ADOApp.h"
#import "ADOLinkIcon.h"

@interface UIControllerManuallyAdd ()<UITextFieldDelegate>
{
    UIViewNav *_viewNav;
    UIButton *_btnSave;
    
    __weak IBOutlet UIView *_viewContain;
    __weak IBOutlet UITextField *_textFieldTitle;
    __weak IBOutlet UITextField *_textFieldURL;
}
@end

@implementation UIControllerManuallyAdd

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _viewNav = [UIViewNav viewNav];
    _viewNav.title = self.title;
    {
        UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnBack addTarget:self action:@selector(onTouchBack) forControlEvents:UIControlEventTouchUpInside];
        [btnBack setImage:[UIImage imageWithBundleFile:@"iPhone/back_0.png"] forState:UIControlStateNormal];
        [btnBack setImage:[UIImage imageWithBundleFile:@"iPhone/back_1.png"] forState:UIControlStateHighlighted];
        [btnBack sizeToFit];
        _viewNav.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
        
        _btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnSave addTarget:self action:@selector(onTouchSave) forControlEvents:UIControlEventTouchUpInside];
        [_btnSave setTitle:LocalizedString(@"baocun") forState:UIControlStateNormal];
        [_btnSave setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnSave setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        _btnSave.titleLabel.font = [UIFont systemFontOfSize:15];
        [_btnSave sizeToFit];
        _viewNav.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_btnSave];
    }
    [self.view addSubview:_viewNav];
    
    _textFieldTitle.placeholder = LocalizedString(@"biaoti");
    _textFieldURL.placeholder = LocalizedString(@"wangzhi");
    
    _textFieldTitle.layer.borderColor =
    _textFieldURL.layer.borderColor = [UIColor colorWithWhite:0.7 alpha:1].CGColor;
    
    _textFieldTitle.layer.borderWidth =
    _textFieldURL.layer.borderWidth = 0.5;
    
    _textFieldTitle.leftViewMode =
    _textFieldURL.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *leftTitle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    UIView *leftURL = [[UIView alloc] initWithFrame:leftTitle.frame];
    _textFieldTitle.leftView = leftTitle;
    _textFieldURL.leftView = leftURL;
    
    _textFieldURL.text = _editApp.link;
    _textFieldTitle.text = _editApp.title;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)layoutSubViewsWithInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    if (IsiPad) return;
    
    [_viewNav resizeWithOrientation:orientation];
    _viewContain.frame = CGRectMake(0, _viewNav.bottom, self.view.width, _viewContain.height);
}

#pragma mark - Private Method
- (BOOL)checkForm
{
    BOOL retVal = NO;
    do {
        NSString *link = _textFieldURL.text;
        if (_textFieldTitle.text.length<=0) {
            [SVProgressHUD showErrorWithStatus:LocalizedString(@"qingshurubiaoti")];
            break;
        }
        if (_textFieldURL.text.length<=0) {
            [SVProgressHUD showErrorWithStatus:LocalizedString(@"qingshuruwangzhi")];
            break;
        }
        if (![link isURLString]) {
            [SVProgressHUD showErrorWithStatus:LocalizedString(@"qingshuruzhengquedewangzhi")];
            break;
        }
        
        
        if (![[link lowercaseString] hasPrefix:@"http://"] && ![[link lowercaseString] hasPrefix:@"https://"]) {
            _textFieldURL.text = [@"http://" stringByAppendingString:link];
        }
        
        retVal = YES;
    } while (NO);
    return retVal;
}

#pragma mark - Action Method
- (void)onTouchBack
{
    [self.view endEditing:YES];
    
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (void)onTouchSave
{
    if (![self checkForm]) {
        return;
    }
    
    if (!_callbackDidEdit) {
        return;
    }
    
    /**
     *  生成一个 modelAPP
     */
    if (_editApp) {
        _editApp.title = _textFieldTitle.text;
        _editApp.link = _textFieldURL.text;
        _editApp.icon = [ADOLinkIcon queryWithLink:HostWithLink(_editApp.link)];
        self.callbackDidEdit(_editApp);
    }
    else if (self.callbackDidEdit) {
        if ([ADOApp isExistWithAppType:AppTypeWeb link:_textFieldURL.text urlSchemes:nil userId:[UserManager shareUserManager].currUser.uid]) {
            [SVProgressHUD showErrorWithStatus:LocalizedString(@"gaiwangzhiyicunzai")];
            return;
        }
        else {
            ModelApp *model = [ModelApp model];
            model.userid = [UserManager shareUserManager].currUser.uid;
            model.lan = [LocalizationUtil currLanguage];
            model.title = _textFieldTitle.text;
            model.link = _textFieldURL.text;
            model.appType = AppTypeWeb;
            model.icon = [ADOLinkIcon queryWithLink:HostWithLink(model.link)];
            model.sortIndex = [ADOApp queryMaxSortIndexWithUserId:[UserManager shareUserManager].currUser.uid];
            NSInteger pkid = [ADOApp addModel:model];
            if (pkid>0) {
                model.pkid = pkid;
                self.callbackDidEdit(model);
            }
        }
    }
    
    if (self.navigationController) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (_textFieldURL==textField && 0==textField.text.length) {
        textField.text = @"http://";
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _textFieldTitle){
        [_textFieldURL becomeFirstResponder];
        return NO;
    }
    else {
        if ([self checkForm]) {
            [self onTouchSave];
            return YES;
        }
        else {
            return NO;
        }
    }
}

@end
