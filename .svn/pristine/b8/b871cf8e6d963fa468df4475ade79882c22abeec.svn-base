//
//  UIControllerClearCache.m
//  ChinaBrowser
//
//  Created by David on 14/12/28.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIControllerClearCache.h"

#import "UIViewNav.h"

#import "ADOHistory.h"
#import "ADOUserPassword.h"

/**
 *  单元行内容类型
 */
typedef NS_ENUM(NSInteger, CellType) {
    CellTypeUnknow  = 0,
    /**
     *  历史记录
     */
    CellTypeHistory = 1 << 0,
    /**
     *  页面缓存
     */
    CellTypeWebCache= 1 << 1,
    /**
     *  Cookie
     */
    CellTypeCookie  = 1 << 2,
    /**
     *  账号密码
     */
    CellTypePwd     = 1 << 3
};

#define kCellType @"kCellType"
#define kCellTitle @"kCellTitle"
#define kCellSelected @"kCellSelected"

@interface UIControllerClearCache () <UITableViewDataSource, UITableViewDelegate>
{
    UIViewNav *_viewNav;
    IBOutlet UITableView *_tableView;
    
    NSArray *_arrSectionCell;
}

@end

@implementation UIControllerClearCache

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _arrSectionCell = @[@[@{kCellType:@(CellTypeHistory),
                            kCellTitle:@"lishijilu",
                            kCellSelected:@(YES)},
                          @{kCellType:@(CellTypeWebCache),
                            kCellTitle:@"yemianhuancun",
                            kCellSelected:@(YES)},
                          @{kCellType:@(CellTypeCookie),
                            kCellTitle:@"cookie",
                            kCellSelected:@(YES)},
                          @{kCellType:@(CellTypePwd),
                            kCellTitle:@"zhanghaomima",
                            kCellSelected:@(NO)}]];
    
    _viewNav = [UIViewNav viewNav];
    _viewNav.title = self.title;
    {
        UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnBack addTarget:self action:@selector(onTouchBack) forControlEvents:UIControlEventTouchUpInside];
        [btnBack setImage:[UIImage imageWithBundleFile:@"iPhone/back_0.png"] forState:UIControlStateNormal];
        [btnBack setImage:[UIImage imageWithBundleFile:@"iPhone/back_1.png"] forState:UIControlStateHighlighted];
        [btnBack sizeToFit];
        
        UIButton *btnClear = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnClear addTarget:self action:@selector(onTouchClear) forControlEvents:UIControlEventTouchUpInside];
        [btnClear setTitle:LocalizedString(@"qingchu") forState:UIControlStateNormal];
        [btnClear setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnClear setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [btnClear sizeToFit];
        
        _viewNav.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
        _viewNav.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnClear];
    }
    [self.view addSubview:_viewNav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)layoutSubViewsWithInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    [_viewNav resizeWithOrientation:orientation];
    _tableView.frame = CGRectMake(0, _viewNav.bottom, _viewNav.width, self.view.height-_viewNav.bottom);
}

#pragma mark - private methods
- (void)onTouchBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onTouchClear
{
    NSArray *arrSelectedIndexPath = [_tableView indexPathsForSelectedRows];
    [arrSelectedIndexPath enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL *stop) {
        CellType cellType = [(_arrSectionCell[indexPath.section][indexPath.row])[kCellType] integerValue];
        if (CellTypeHistory==cellType) {
            [ADOHistory clearWithUserId:[UserManager shareUserManager].currUser.uid];
            if ([SyncHelper shouldAutoSync]) {
                [[SyncHelper shareSync] syncClearDataType:SyncDataTypeHistory completion:^{
                    
                } fail:^(NSError *error) {
                    
                }];
            }
        }
        else if (CellTypeWebCache==cellType) {
            //清除UIWebView的缓存
            [[NSURLCache sharedURLCache] removeAllCachedResponses];
        }
        else if (CellTypeCookie==cellType) {
            //清除cookies
            NSHTTPCookie *cookie;
            NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            for (cookie in [storage cookies])
            {
                [storage deleteCookie:cookie];
            }
        }
        else if (CellTypePwd==cellType) {
            [ADOUserPassword clear];
        }
    }];
    
    [self onTouchBack];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _arrSectionCell.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_arrSectionCell[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *Identifier = @"Identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
        cell.selectedBackgroundView = [[UIView alloc] init];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    }
    cell.textLabel.text = LocalizedString(_arrSectionCell[indexPath.section][indexPath.row][kCellTitle]);
    
    id selected = [cell userData];
    if (!selected) {
        // 获取默认选择状态
        selected = _arrSectionCell[indexPath.section][indexPath.row][kCellSelected];
        if (!selected) {
            // 如果没有默认选择状态=》设置为NO，不选择
            selected = @(NO);
        }
        cell.userData = selected;
    }
    cell.accessoryType = [selected boolValue]?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return LocalizedString(@"qinggouxuanqingchuxiang");
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    id selected = [cell userData];
    if (selected) {
        selected = @(![selected boolValue]);
    }
    else {
        selected = @(YES);
    }
    cell.userData = selected;
    
    cell.accessoryType = [selected boolValue]?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
}

@end
