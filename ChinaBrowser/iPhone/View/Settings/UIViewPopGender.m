//
//  UIViewPopGender.m
//  ChinaBrowser
//
//  Created by David on 14/11/18.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIViewPopGender.h"

#import "ModelUser.h"

@interface UIViewPopGender () <UIPickerViewDataSource, UIPickerViewDelegate>
{
    __weak IBOutlet UIPickerView *_pickerView;
    NSArray *_arrItem;
}

@end

@implementation UIViewPopGender

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _arrItem = @[@{@"type":@(UserGenderMale), @"gender":@"nan"},
                 @{@"type":@(UserGenderFemale), @"gender":@"nv"},
                 @{@"type":@(UserGenderSecrecy), @"gender":@"baomi"}];
}

- (void)showInView:(UIView *)view completion:(void (^)())completion
{
    [super showInView:view completion:completion];
    
    NSInteger gender = [UserManager shareUserManager].currUser.gender;
    NSInteger genderIndex = gender-UserGenderMale;
    if (gender>0) {
        [_pickerView selectRow:genderIndex inComponent:0 animated:NO];
    }
}

- (void)onTouchOk
{
    NSInteger index = [_pickerView selectedRowInComponent:0];
    if (index>=0) {
        NSInteger gender = [_arrItem[index][@"type"] integerValue];
        [_delegate viewPopGender:self selectedGender:gender];
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
    NSDictionary *dicGender = _arrItem[row];
    return LocalizedString(dicGender[@"gender"]);
}

@end
