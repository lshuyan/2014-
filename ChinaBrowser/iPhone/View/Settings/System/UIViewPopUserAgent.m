//
//  UIViewPopUserAgent.m
//  ChinaBrowser
//
//  Created by David on 14/11/11.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIViewPopUserAgent.h"

@interface UIViewPopUserAgent () <UIPickerViewDataSource, UIPickerViewDelegate>

@end

@implementation UIViewPopUserAgent
{
    __weak IBOutlet UIPickerView *_pickerView;
    NSArray *_arrItem;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _arrItem = [AppSetting shareAppSetting].arrUserAgent;
}

- (void)showInView:(UIView *)view completion:(void (^)())completion
{
    [super showInView:view completion:completion];
    
    [_pickerView selectRow:[AppSetting shareAppSetting].userAgentIndex inComponent:0 animated:NO];
}

- (void)onTouchOk
{
    NSInteger index = [_pickerView selectedRowInComponent:0];
    if (index>=0) {
        [_delegate viewPopUserAgent:self selectUserAgentIndex:index];
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
    return _arrItem[row];
}

@end
