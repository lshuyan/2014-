//
//  UIControllerAboutUs.m
//  ChinaBrowser
//
//  Created by David on 14/11/8.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIControllerAboutUs.h"

#import "UIControllerWebview.h"

#import "UIViewNav.h"

#import "CheckVersion.h"

#define kCellTitle @"title"
#define kCellType @"type"

/**
 *  单元格操作类型
 */
typedef NS_ENUM(NSInteger, CellActionType) {
    /**
     *  检查更新
     */
    CellActionTypeCheckupdate,
    /**
     *  帮助中心
     */
    CellActionTypeHelp,
    /**
     *  意见反馈
     */
    CellActionTypeFeedback,
    /**
     *  产品介绍
     */
    CellActionTypeIntro
};

@interface UIControllerAboutUs () <UITableViewDataSource, UITableViewDelegate>
{
    UIViewNav *_viewNav;
    
    NSArray *_arrDatasource;
    __weak IBOutlet UITableView *_tableView;
    __weak IBOutlet UIView *_viewHeader;
    __weak IBOutlet UIImageView *_imageViewIcon;
    __weak IBOutlet UILabel *_labelAppName;
    __weak IBOutlet UILabel *_labelAppVersion;
}

@end

@implementation UIControllerAboutUs

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _arrDatasource = @[@[@{kCellTitle:@"jianchagengxin",
                           kCellType:@(CellActionTypeCheckupdate)}],
                       @[@{kCellTitle:@"bangzhuzhongxin",
                           kCellType:@(CellActionTypeHelp)},
                         @{kCellTitle:@"yijianfankui",
                           kCellType:@(CellActionTypeFeedback)},
                         @{kCellTitle:@"chanpinjieshao",
                           kCellType:@(CellActionTypeIntro)}]];
    
    _labelAppName.text = LocalizedString(@"zhonghualiulanqi");
    _labelAppVersion.text = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    
    _viewNav = [UIViewNav viewNav];
    _viewNav.title = self.title;
    [self.view addSubview:_viewNav];
    
    _tableView.tableHeaderView = _viewHeader;
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack addTarget:self action:@selector(onTouchBack) forControlEvents:UIControlEventTouchUpInside];
    [btnBack setImage:[UIImage imageWithBundleFile:@"iPhone/back_0.png"] forState:UIControlStateNormal];
    [btnBack setImage:[UIImage imageWithBundleFile:@"iPhone/back_1.png"] forState:UIControlStateHighlighted];
    [btnBack sizeToFit];
    
    _viewNav.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)layoutSubViewsWithInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    [_viewNav resizeWithOrientation:orientation];
    
    _tableView.frame = CGRectMake(0, _viewNav.bottom, self.view.width, self.view.height-_viewNav.bottom);
}

#pragma mark - private methods
- (void)onTouchBack
{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _arrDatasource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arrCell = _arrDatasource[section];
    return arrCell.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *IdentifierUICellAboutUs = @"UICellAboutUs";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IdentifierUICellAboutUs];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IdentifierUICellAboutUs];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSDictionary *dicCell = _arrDatasource[indexPath.section][indexPath.row];
    cell.textLabel.text = LocalizedString(dicCell[kCellTitle]);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dicCell = _arrDatasource[indexPath.section][indexPath.row];
    CellActionType type = [dicCell[kCellType] integerValue];
    switch (type) {
        case CellActionTypeCheckupdate:
        {
            [CheckVersion checkVersionAtLaunch:NO];
        }break;
        case CellActionTypeHelp:
        {
            UIControllerWebview *controllerWebview = [[UIControllerWebview alloc] init];
            controllerWebview.link = GetApiWithName(API_Help);
            controllerWebview.title = LocalizedString(dicCell[kCellTitle]);
            [self.navigationController pushViewController:controllerWebview animated:YES];
        }break;
        case CellActionTypeIntro:
        {
            UIControllerWebview *controllerWebview = [[UIControllerWebview alloc] init];
            controllerWebview.link = GetApiWithName(API_Intro);
            controllerWebview.title = LocalizedString(dicCell[kCellTitle]);
            [self.navigationController pushViewController:controllerWebview animated:YES];
        }break;
        case CellActionTypeFeedback:
        {
            UIControllerWebview *controllerWebview = [[UIControllerWebview alloc] init];
            controllerWebview.link = GetApiWithName(API_Feedback);
            controllerWebview.title = LocalizedString(dicCell[kCellTitle]);
            [self.navigationController pushViewController:controllerWebview animated:YES];
        }break;
        default:
            break;
    }
}

@end
