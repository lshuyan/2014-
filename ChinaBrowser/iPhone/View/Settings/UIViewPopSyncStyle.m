//
//  UIViewPopSyncStyle.m
//  ChinaBrowser
//
//  Created by David on 14/11/24.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIViewPopSyncStyle.h"

#import "ModelUser.h"
#import "ModelUserSettings.h"

@interface UIViewPopSyncStyle ()
{
    __weak IBOutlet UIPickerView *_pickerView;
    NSArray *_arrItem;
}

@end

@implementation UIViewPopSyncStyle

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _arrItem = @[@{@"syncStyle":@(SyncStyleWiFi), @"text":@"jinzaiWifixiazidong"},
                 @{@"syncStyle":@(SyncStyleAuto), @"text":@"zongshizidong"},
                 @{@"syncStyle":@(SyncStyleManual), @"text":@"zongshishoudong"}];
}

- (void)showInView:(UIView *)view completion:(void (^)())completion
{
    [super showInView:view completion:completion];
    
    NSInteger selectRow = -1;
    NSInteger syncStyle = [UserManager shareUserManager].currUser.settings.syncStyle;
    for (NSInteger i=0; i<_arrItem.count; i++) {
        NSDictionary *dictSync = _arrItem[i];
        if ([dictSync[@"syncStyle"] integerValue]==syncStyle) {
            selectRow = i;
            break;
        }
    }
    if (selectRow>0) {
        [_pickerView selectRow:selectRow inComponent:0 animated:NO];
    }
}

- (void)onTouchOk
{
    NSInteger index = [_pickerView selectedRowInComponent:0];
    if (index>=0) {
        SyncStyle syncStyle = [_arrItem[index][@"syncStyle"] integerValue];
        if (_callbackDidSelectSyncStyle) {
            _callbackDidSelectSyncStyle(syncStyle);
        }
    }
    [self dismissWithCompletion:nil];
}

#pragma mark - UIPickerViewDataSource, UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _arrItem.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSDictionary *dictSyncStyle = _arrItem[row];
    return LocalizedString(dictSyncStyle[@"text"]);
}

@end
