//
//  UIViewPopUrlOpenStyle.m
//  ChinaBrowser
//
//  Created by David on 14/11/10.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIViewPopUrlOpenStyle.h"

@interface UIViewPopUrlOpenStyle () <UIPickerViewDataSource, UIPickerViewDelegate>

@end

@implementation UIViewPopUrlOpenStyle
{
    __weak IBOutlet UIPickerView *_pickerView;
    
    NSArray *_arrItem;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _arrItem = @[@(UrlOpenStyleCurrent), @(UrlOpenStyleAuto), @(UrlOpenStyleNewTab), @(UrlOpenStyleBackground)];
}

- (void)showInView:(UIView *)view completion:(void (^)())completion
{
    [super showInView:view completion:completion];
    
    UrlOpenStyle style = [AppSetting shareAppSetting].urlOpenStyle;
    [_arrItem enumerateObjectsUsingBlock:^(NSNumber *type, NSUInteger idx, BOOL *stop) {
        if ([type integerValue]==style) {
            [_pickerView selectRow:idx inComponent:0 animated:NO];
            
            *stop = YES;
        }
    }];
}

- (void)onTouchOk
{
    NSInteger index = [_pickerView selectedRowInComponent:0];
    if (index>=0) {
        [_delegate viewPopUrlOpenStyle:self selectUrlOpenStyle:[_arrItem[index] integerValue]];
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
    UrlOpenStyle style = [_arrItem[row] integerValue];
    return StringFromUrlOpenStyle(style);
}

@end
