//
//  UIControllerSelectionForder.m
//  ChinaBrowser
//
//  Created by HHY on 14/11/13.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIControllerSelectionForder.h"
#import "UICellBookmarkHisoty.h"
#import "UIViewNav.h"

#import "ADOBookmark.h"
#import "ModelBookmark.h"


@interface UIControllerSelectionForder () <UITableViewDelegate, UITableViewDataSource>
{
    NSArray *_allFolder;
    
    UIViewNav *_viewNav;
    IBOutlet UITableView *_tableView;
}
@end

@implementation UIControllerSelectionForder

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSMutableArray *arrFolder = [NSMutableArray arrayWithArray:[ADOBookmark queryAllFolderWithUserId:[UserManager shareUserManager].currUser.uid]];
    ModelBookmark *modelRoot = [ModelBookmark model];
    modelRoot.pkid = 0;
    modelRoot.pkid_server = 0;
    modelRoot.parent_pkid = 0;
    modelRoot.parent_pkid_server = 0;
    modelRoot.title = LocalizedString(@"genmulu");
    [arrFolder insertObject:modelRoot atIndex:0];
    
    _allFolder = arrFolder;
    
    self.title = LocalizedString(@"xuanzewenjianjia");
    _viewNav = [UIViewNav viewNav];
    _viewNav.title = self.title;
    [self.view addSubview:_viewNav];
    
    UIButton *btnBack =[UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setImage:[UIImage imageWithBundleFile:@"iPhone/back_0.png"] forState:UIControlStateNormal];
    [btnBack setImage:[UIImage imageWithBundleFile:@"iPhone/back_1.png"] forState:UIControlStateHighlighted];
    [btnBack addTarget:self action:@selector(onTouchBtnback) forControlEvents:UIControlEventTouchUpInside];
    [btnBack sizeToFit];
    _viewNav.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btnBack];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    rc.size.width = _viewNav.frame.size.width;
    _tableView.frame = rc;
    
}

/**
 *  返回按钮
 */
- (void)onTouchBtnback
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TableviewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _allFolder.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdD = @"UICellBookmarkHisoty";
    UICellBookmarkHisoty *cell = [tableView dequeueReusableCellWithIdentifier:cellIdD];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"UICellBookmarkHisoty" owner:self options:nil] lastObject];
    }
    
    ModelBookmark *model = _allFolder[indexPath.row];
    cell.accessoryType = model.pkid==_folderPkid?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
    
    if (0==model.pkid) {
        cell.cellStyle = CellStyleFolder;
        cell.cellSeparatorStyle = CellSeparatorStyleNone;
        cell.labelBookmarkTitle.text = model.title;
        
        cell.imageViewLeftIcon.image = [UIImage imageWithBundleFile:@"iPhone/Settings/Bookmark/folder.png"];
        cell.imageViewLeftIcon.hidden = NO;
        cell.labelBookmarkTitle.hidden = NO;
        cell.labelFolderTitle.hidden = YES;
        cell.imageVIewFolder.hidden = YES;
    }
    else {
        cell.cellSeparatorStyle = CellSeparatorStyleFolder;
        cell.labelFolderTitle.text = model.title;
        
        cell.imageVIewFolder.image = [UIImage imageWithBundleFile:@"iPhone/App/folder.png"];
        cell.imageViewLeftIcon.hidden = YES;
        cell.labelBookmarkTitle.hidden = YES;
        cell.imageVIewFolder.hidden = NO;
        cell.labelFolderTitle.hidden = NO;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModelBookmark *model = _allFolder[indexPath.row];
    if (_callbackDidSelectedFolder) {
        _callbackDidSelectedFolder(model.pkid, model.title);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
