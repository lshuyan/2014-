//
//  UIControllerCreateBookmark.m
//  ChinaBrowser
//
//  Created by HHY on 14/11/10.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIControllerCreateBookmark.h"

#import "UIViewNav.h"
#import "UIControllerSelectionForder.h"

#import "ModelBookmark.h"

#import "ADOBookmark.h"

#import "BlockUI.h"

@interface UIControllerCreateBookmark ()<UITextFieldDelegate>
{
    UIViewNav *_viewNav;
    UIButton *_btnSave;
    IBOutlet UITableView *_tableView;
    
    UITextField *_textFieldForder;
    UITextField *_textFieldTitle;
    UITextField *_textFieldLink;
    
    UITableViewCell *_cellFolderName;
    
    // 选择保存的文件夹编号
    NSInteger _parentPkidSelected;
}
@end

@implementation UIControllerCreateBookmark

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    /**
     *  初始化为 -1
     */
    _parentPkidSelected = -1;
    
    //注册键盘通知
    [self registerForKeyboardNotifications];
    
    //初始化UI
    [self initUI];
}

//初始化界面
-(void)initUI
{
    _viewNav = [UIViewNav viewNav];
    [self.view addSubview:_viewNav];
    
    UIButton *btnBack =[UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setImage:[UIImage imageWithBundleFile:@"iPhone/back_0.png"] forState:UIControlStateNormal];
    [btnBack setImage:[UIImage imageWithBundleFile:@"iPhone/back_1.png"] forState:UIControlStateHighlighted];
    [btnBack addTarget:self action:@selector(onTouchBtnback) forControlEvents:UIControlEventTouchUpInside];
    [btnBack sizeToFit];
    _viewNav.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    
    _btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnSave setTitle:LocalizedString(@"baocun") forState:UIControlStateNormal];
    [_btnSave setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnSave setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [_btnSave setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [_btnSave addTarget:self action:@selector(onTouchRightBarButtonItem) forControlEvents:UIControlEventTouchUpInside];
    [_btnSave sizeToFit];
    _viewNav.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_btnSave];
    
    NSString *titleKey = nil;
    switch (_type) {
        case BookmarkActionTypeNewBookmark:
        {
            titleKey = @"xinjianshuqian";
            _btnSave.enabled = NO;
        }break;
        case BookmarkActionTypeNewFolder:
        {
            titleKey = @"xinjianwenjianjia";
            _btnSave.enabled = NO;
        }break;
        case BookmarkActionTypeEditBookmark:
        {
            titleKey = @"bianjishuqian";
            _btnSave.enabled = YES;
        }break;
        case BookmarkActionTypeEditFolder:
        {
            titleKey = @"bianjiwenjianjia";
            _btnSave.enabled = YES;
        }break;
        default:
            break;
    }
    self.title = LocalizedString(titleKey);
    _viewNav.title = self.title;
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
 *  注册键盘通知
 */
- (void)registerForKeyboardNotifications
{
    //使用NSNotificationCenter 鍵盤出現時
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    //使用NSNotificationCenter 鍵盤隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

//实现当键盘出现的时候计算键盘的高度大小。用于设置scrollView的contentSize;
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    float kbheight;
    
    kbheight = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    //得到鍵盤的高度
    if (kbheight>300) {
        kbheight = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.width;
    }
    CGRect rect = _tableView.frame;
    
    rect.size.height = self.view.bounds.size.height-rect.origin.y-kbheight;
    _tableView.frame = rect;
    
}

//当键盘隐藏的时候
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    CGRect rect =_tableView.frame;
    rect.size.height = self.view.bounds.size.height-rect.origin.y;
    _tableView.frame = rect;
}

/**
 *  返回按钮
 */
- (void)onTouchBtnback
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  点击_nav右边按钮事件.  保存
 */
-(void)onTouchRightBarButtonItem
{
    switch (_type) {
        case BookmarkActionTypeEditBookmark:
        {
            if (![_textFieldLink.text isURLString]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:LocalizedString(@"qingshuruzhengquedeshuqianlianjie") delegate:nil cancelButtonTitle:LocalizedString(@"quxiao") otherButtonTitles:LocalizedString(@"queding"), nil];
                [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
                    if (alert.cancelButtonIndex==buttonIndex) {
                        return;
                    }
                    
                    [_textFieldLink becomeFirstResponder];
                }];
                return;
            }
            
            if ([ADOBookmark isExistWithLink:_textFieldLink.text userId:[UserManager shareUserManager].currUser.uid exceptPkid:_modelEdit.pkid]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:LocalizedString(@"yicunzaixiangtonglianjieshuqian") delegate:nil cancelButtonTitle:LocalizedString(@"quxiao") otherButtonTitles:LocalizedString(@"queding"), nil];
                [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
                    if (alert.cancelButtonIndex==buttonIndex) {
                        return;
                    }
                    
                    [_textFieldLink becomeFirstResponder];
                }];
                return;
            }
            
            _modelEdit.title = _textFieldTitle.text;
            _modelEdit.link = _textFieldLink.text;
            _modelEdit.icon = FaviconWithLink(_modelEdit.link);
            if (_parentPkidSelected>-1 && _modelEdit.parent_pkid!=_parentPkidSelected) {
                /**
                 *  切换到了另一个文件夹，
                 *  1、移到另一个文件夹底部 sort_index = max sort_index of (_parentPkidSelect)
                 *  2、当前文件夹 需要重新排序 _modelEdit.parent_pkid resort begin of _modelEdit.sort_index
                 */
                NSInteger parentPkidOld = _modelEdit.parent_pkid;
                NSInteger sortIndexBegin = _modelEdit.sortIndex;
                
                _modelEdit.parent_pkid = _parentPkidSelected;
                _modelEdit.parent_pkid_server = [ADOBookmark queryPkidServerWithPkid:_modelEdit.parent_pkid];
                // 1、移到另一个文件夹底部 sort_index = max sort_index of (_parentPkidSelect)
                _modelEdit.sortIndex = [ADOBookmark queryMaxSortIndexWithParentPkid:_parentPkidSelected userId:_modelEdit.userid]+1;
                
                // 2、当前文件夹 需要重新排序 _modelEdit.parent_pkid resort begin of _modelEdit.sort_index
                NSArray *arrWillResort = [ADOBookmark queryWithParentPkid:parentPkidOld fromSortIndex:sortIndexBegin exceptPkid:_modelEdit.pkid];
                for (NSInteger i=0; i<arrWillResort.count; i++) {
                    ModelBookmark *modelWillResort = arrWillResort[i];
                    [ADOBookmark updateSort:sortIndexBegin+i withPkid:modelWillResort.pkid];
                }
            }
            _modelEdit.updateTime = [[NSDate date] timeIntervalSince1970];
            
            if ([ADOBookmark updateModel:_modelEdit]) {
                if ([SyncHelper shouldAutoSync] && [SyncHelper shouldSyncWithType:SyncDataTypeBookmark]) {
                    [[SyncHelper shareSync] syncUpdateArrBookmark:@[_modelEdit] completion:^{
                        
                    } fail:^(NSError *error) {
                        
                    }];
                }
            }
            
            if (_callbackDidEditBookmark) {
                _callbackDidEditBookmark(_modelEdit);
            }
        }break;
        case BookmarkActionTypeEditFolder:
        {
            _modelEdit.title = _textFieldForder.text;
            _modelEdit.updateTime = [[NSDate date] timeIntervalSince1970];
            
            if ([ADOBookmark updateModel:_modelEdit]) {
                if ([SyncHelper shouldAutoSync] && [SyncHelper shouldSyncWithType:SyncDataTypeBookmark]) {
                    [[SyncHelper shareSync] syncUpdateArrBookmark:@[_modelEdit] completion:^{
                        
                    } fail:^(NSError *error) {
                        
                    }];
                }
            }
            
            if (_callbackDidEditBookmark) {
                _callbackDidEditBookmark(_modelEdit);
            }
        }break;
        case BookmarkActionTypeNewBookmark:
        {
            if ([ADOBookmark isExistWithLink:_textFieldLink.text userId:[UserManager shareUserManager].currUser.uid]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:LocalizedString(@"yicunzaixiangtonglianjieshuqian") delegate:nil cancelButtonTitle:LocalizedString(@"quxiao") otherButtonTitles:LocalizedString(@"queding"), nil];
                [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
                    if (alert.cancelButtonIndex==buttonIndex) {
                        return;
                    }
                    
                    [_textFieldLink becomeFirstResponder];
                }];
                return;
            }
            
            ModelBookmark *model = [ModelBookmark model];
            model.title = _textFieldTitle.text;
            model.link = _textFieldLink.text;
            model.icon = FaviconWithLink(model.link);
            model.isFolder = NO;
            model.canEdit = YES;
            model.parent_pkid = _parentPkidSelected>-1?_parentPkidSelected:_parentPkidOfNew;
            model.parent_pkid_server = [ADOBookmark queryPkidServerWithPkid:model.parent_pkid];
            model.updateTime = [[NSDate date] timeIntervalSince1970];
            model.sortIndex = [ADOBookmark queryMaxSortIndexWithParentPkid:model.parent_pkid userId:model.userid]+1;
            model.pkid = [ADOBookmark addModel:model];
            
            if (model.pkid>0 && [SyncHelper shouldAutoSync] && [SyncHelper shouldSyncWithType:SyncDataTypeBookmark]) {
                [[SyncHelper shareSync] syncAddArrBookmark:@[model] completion:^{
                    
                } fail:^(NSError *error) {
                    
                }];
            }
            
            if (model.pkid>0 && _callbackDidNewBookmark) {
                _callbackDidNewBookmark(model);
            }
        }break;
        case BookmarkActionTypeNewFolder:
        {
            ModelBookmark *model = [ModelBookmark model];
            model.title = _textFieldForder.text;
            model.isFolder = YES;
            model.canEdit = YES;
            model.parent_pkid = _parentPkidOfNew;
            model.parent_pkid_server = [ADOBookmark queryParentPkidServerWithParentPkid:model.parent_pkid];
            model.updateTime = [[NSDate date] timeIntervalSince1970];
            model.sortIndex = [ADOBookmark queryMaxSortIndexWithParentPkid:model.parent_pkid userId:model.userid]+1;
            model.pkid = [ADOBookmark addModel:model];
            
            if (model.pkid>0 && [SyncHelper shouldAutoSync] && [SyncHelper shouldSyncWithType:SyncDataTypeBookmark]) {
                [[SyncHelper shareSync] syncAddArrBookmark:@[model] completion:^{
                    
                } fail:^(NSError *error) {
                    
                }];
            }
            
            if (model.pkid>0 && _callbackDidNewBookmark) {
                _callbackDidNewBookmark(model);
            }
        }break;
        default:
            break;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITextField *)newTextFiledWithFrame:(CGRect)frame
{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.delegate = self;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.delegate = self;
    return textField;
}

#pragma mark - UITextFieldDelete
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _textFieldTitle) {
        [_textFieldLink becomeFirstResponder];
    }
    else if (_btnSave.enabled) {
        [self onTouchRightBarButtonItem];
    }
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (BookmarkActionTypeEditBookmark==_type || BookmarkActionTypeNewBookmark==_type) {
        _btnSave.enabled = _textFieldTitle.text.length>0 && _textFieldLink.text.length>0;
    }
    else {
        _btnSave.enabled = text.length>0;
    }
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    _btnSave.enabled = NO;
    return YES;
}

#pragma mark - tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (BookmarkActionTypeEditBookmark==_type || BookmarkActionTypeNewBookmark==_type) {
        return 2;
    }
    else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (BookmarkActionTypeEditBookmark==_type || BookmarkActionTypeNewBookmark==_type) {
        if (0==section) {
            return 2;
        }
        else {
            return 1;
        }
    }
    else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    CGRect rc = CGRectMake(20, 0, ([UIScreen mainScreen].bounds.size.width>[UIScreen mainScreen].bounds.size.height?[UIScreen mainScreen].bounds.size.height:[UIScreen mainScreen].bounds.size.width)-30, 44);
    
    UITextField *textField = nil;
    if (BookmarkActionTypeNewFolder==_type || BookmarkActionTypeEditFolder==_type) {
        if (!_textFieldForder) {
            textField = [self newTextFiledWithFrame:rc];
            textField.placeholder = LocalizedString(@"xinjianwenjianjia");
            textField.returnKeyType = UIReturnKeyDone;
            _textFieldForder = textField;
        }
        else {
            textField = _textFieldForder;
        }
        
        if (BookmarkActionTypeEditFolder==_type) {
            // 编辑状态设置 值
            textField.text = _modelEdit.title;
        }
        
        [cell addSubview:textField];
        textField.frame = rc;
    }
    else {
        if (0==indexPath.section) {
            if (0==indexPath.row) {
                if (_textFieldTitle) {
                    textField = _textFieldTitle;
                }
                else {
                    textField = [self newTextFiledWithFrame:rc];
                    textField.returnKeyType = UIReturnKeyNext;
                    textField.placeholder = LocalizedString(@"shuqianneirong");
                    _textFieldTitle = textField;
                }
                if (BookmarkActionTypeEditBookmark==_type) {
                    textField.text = _modelEdit.title;
                }
            }
            else {
                if (_textFieldLink) {
                    textField = _textFieldLink;
                }
                else {
                    textField = [self newTextFiledWithFrame:rc];
                    textField.returnKeyType = UIReturnKeyDone;
                    textField.placeholder = LocalizedString(@"shuqianlianjie");
                    _textFieldLink = textField;
                }
                if (BookmarkActionTypeEditBookmark==_type) {
                    textField.text = _modelEdit.link;
                }
            }
            
            [cell addSubview:textField];
            textField.frame = rc;
        }
        else {
            // 文件夹 cell
            _cellFolderName = cell;
            ModelBookmark *model = [ADOBookmark queryWithPkid:_modelEdit?_modelEdit.parent_pkid:_parentPkidOfNew];
            if (model) {
                cell.textLabel.text = model.title;
            }
            else {
                cell.textLabel.text = LocalizedString(@"genmulu");
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.imageView.image = [UIImage imageWithBundleFile:@"iPhone/Settings/Bookmark/folder.png"];
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 1) {
        // 选择文件夹，（编辑书签、新建书签）
        UIControllerSelectionForder *controller = [UIControllerSelectionForder controllerFromXib];
        controller.callbackDidSelectedFolder = ^(NSInteger pkid, NSString *title){
            _cellFolderName.textLabel.text = title;
            _parentPkidSelected = pkid;
        };
        
        if (BookmarkActionTypeEditBookmark==_type) {
            controller.folderPkid = _parentPkidSelected>-1?_parentPkidSelected:_modelEdit.parent_pkid;
        }
        else if (BookmarkActionTypeNewBookmark==_type) {
            controller.folderPkid = _parentPkidSelected>-1?_parentPkidSelected:_parentPkidOfNew;
        }
        
        [self.navigationController pushViewController:controller animated:YES];
    }
}

@end
