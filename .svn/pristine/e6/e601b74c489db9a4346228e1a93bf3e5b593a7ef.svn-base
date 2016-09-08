//
//  UIViewReminderEdit.m
//  ChinaBrowser
//
//  Created by David on 14/11/26.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIViewReminderEdit.h"

#import "modelModeProgram.h"
#import "modelProgram.h"

#define kRepeatItemSpace (-1.0f)
#define kRepeatItemBgSelectColor [UIColor colorWithRed:0.196 green:0.686 blue:1.000 alpha:1.000]
#define kRepeatItemBgUnselectColor [UIColor colorWithWhite:0.88 alpha:1]
#define kRepeatItemBorderColor [UIColor colorWithWhite:0.65 alpha:1]
#define kRepeatItemBorderWidth (0.5f)

@interface UIViewReminderEdit () <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>
{
    IBOutlet UIPickerView *_pickView;
    IBOutlet UILabel *_labelFieldRepeat;
    IBOutlet UILabel *_labelFieldModeName;
    
    IBOutlet UIView *_viewRepeat;
    IBOutlet UITextField *_textFieldModeName;
    
    IBOutletCollection(UIButton) NSArray *_arrBtnRepeat;
    
    NSInteger _programServerId;
}

@end

@implementation UIViewReminderEdit

@synthesize time = _time;
@synthesize modelName = _modelName;
@synthesize repeatMode = _repeatMode;

#pragma mark - property
- (void)setActionType:(ProgramActionType)actionType
{
    _actionType = actionType;
    switch (actionType) {
            /**
             *  新建模式
             */
        case ProgramActionTypeAddMode:
        {
            _labelFieldModeName.text = LocalizedString(@"qingshurumoshiming");
            _textFieldModeName.text = LocalizedString(@"moshiyi");
        }break;
            /**
             *  新增预约
             */
        case ProgramActionTypeAddModeProgram:
            /**
             *  编辑预约
             */
        case ProgramActionTypeEditModeProgram:
        {
            // 删除 模式名 选项
            CGRect rc = self.frame;
            rc.size.height = _labelFieldModeName.top;
            self.frame = rc;
            
            [_labelFieldModeName removeFromSuperview];
            [_textFieldModeName removeFromSuperview];
            
            _labelFieldModeName = nil;
            _labelFieldRepeat = nil;
        }break;
            
        default:
            break;
    }
}

- (void)setTime:(NSInteger)time
{
    // 设置预约时间
    [_pickView selectRow:time/3600 inComponent:1 animated:NO];
    [_pickView selectRow:time%3600/60 inComponent:2 animated:NO];
}

- (void)setRepeatMode:(RemindRepeatMode)repeatMode
{
    // 设置预约重复模式
    [_arrBtnRepeat enumerateObjectsUsingBlock:^(UIButton *btnRepeat, NSUInteger idx, BOOL *stop) {
        if (repeatMode&btnRepeat.tag) {
            btnRepeat.selected = YES;
            btnRepeat.backgroundColor = kRepeatItemBgSelectColor;
        }
        else {
            btnRepeat.selected = NO;
            btnRepeat.backgroundColor = kRepeatItemBgUnselectColor;
        }
    }];
}

- (void)setModelName:(NSString *)modelName
{
    _textFieldModeName.text = modelName;
}

- (NSString *)modelName
{
    return _textFieldModeName.text;
}

- (NSInteger)time
{
    NSInteger time = [_pickView selectedRowInComponent:1]*3600+[_pickView selectedRowInComponent:2]*60;
    return time;
}

- (RemindRepeatMode)repeatMode
{
    RemindRepeatMode repeatMode = RemindRepeatModeNone;
    for (UIButton *btnRepeat in _arrBtnRepeat) {
        if (btnRepeat.selected) {
            repeatMode |= btnRepeat.tag;
        }
    }
    return repeatMode;
}

- (void)setCanSelectTime:(BOOL)canSelectTime
{
    _pickView.userInteractionEnabled = canSelectTime;
    [_pickView reloadAllComponents];
}

#pragma mark - super methods
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _labelFieldRepeat.text = LocalizedString(@"chongfufangshi");
    _labelFieldModeName.text = LocalizedString(@"qingshurumoshiming");
    
    _textFieldModeName.layer.borderColor = [UIColor colorWithWhite:0.85 alpha:1].CGColor;
    _textFieldModeName.layer.borderWidth = 0.5;
    _textFieldModeName.placeholder = LocalizedString(@"qingshurumoshiming");
    
    UIView *viewLeft = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 10)];
    _textFieldModeName.leftView = viewLeft;
    _textFieldModeName.leftViewMode = UITextFieldViewModeAlways;
    
    NSArray *arrRepeat = @[@{@"title":@"zhou1",
                            @"repeat":@(RemindRepeatMode1)},
                           @{@"title":@"zhou2",
                             @"repeat":@(RemindRepeatMode2)},
                           @{@"title":@"zhou3",
                             @"repeat":@(RemindRepeatMode3)},
                           @{@"title":@"zhou4",
                             @"repeat":@(RemindRepeatMode4)},
                           @{@"title":@"zhou5",
                             @"repeat":@(RemindRepeatMode5)},
                           @{@"title":@"zhou6",
                             @"repeat":@(RemindRepeatMode6)},
                           @{@"title":@"zhou0",
                             @"repeat":@(RemindRepeatMode0)}
                           ];
    
    NSInteger count = MIN(arrRepeat.count, _arrBtnRepeat.count);
    for (NSInteger i=0; i<count; i++) {
        UIButton *btnRepeat = _arrBtnRepeat[i];
        NSDictionary *dicRepeat = arrRepeat[i];
        [btnRepeat setTitle:LocalizedString(dicRepeat[@"title"]) forState:UIControlStateNormal];
        btnRepeat.tag = [dicRepeat[@"repeat"] integerValue];
        [btnRepeat setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btnRepeat setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [btnRepeat setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        btnRepeat.layer.borderColor = kRepeatItemBorderColor.CGColor;
        btnRepeat.layer.borderWidth = kRepeatItemBorderWidth;
        
        [btnRepeat addTarget:self action:@selector(onTouchRepeat:) forControlEvents:UIControlEventTouchUpInside];
    }
}

+ (instancetype)viewFromXib
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [self setNeedsDisplay];
    
    if (_arrBtnRepeat.count>0) {
        CGFloat fWidth = (_viewRepeat.width-(_arrBtnRepeat.count-1)*kRepeatItemSpace)/_arrBtnRepeat.count;
        for (NSInteger i=0; i<_arrBtnRepeat.count; i++) {
            CGRect rc = CGRectMake((fWidth+kRepeatItemSpace)*i, 0, fWidth, _viewRepeat.height);
            UIButton *btnRepeat = _arrBtnRepeat[i];
            btnRepeat.frame = CGRectIntegral(rc);
        }
    }
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, NO);
    CGContextSetShouldAntialias(context, NO);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.85 alpha:1].CGColor);
    CGContextSetLineWidth(context, 0.5);
    CGContextMoveToPoint(context, 0, 0.5);
    CGContextAddLineToPoint(context, self.width, 0.5);
    CGContextMoveToPoint(context, 0, _pickView.bottom);
    CGContextAddLineToPoint(context, self.width, _pickView.bottom);
    CGContextStrokePath(context);
}

#pragma mark - UIPickerViewDataSource, UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 4;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger numb = 1;
    switch (component) {
        case 0: numb=1; break;
        case 1: numb=24; break;
        case 2: numb=60; break;
        case 3: numb=1; break;
        default:
            break;
    }
    return numb;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *labelStr = (UILabel *)view;
    if (!labelStr) {
        labelStr = [[UILabel alloc] init];
        labelStr.backgroundColor = [UIColor clearColor];
    }

    NSString *title;
    switch (component) {
        case 0: title = LocalizedString(@"shi"); labelStr.textAlignment = NSTextAlignmentRight; break;
        case 1:
        case 2: title = [NSString stringWithFormat:@"%02ld", (long)row]; labelStr.textAlignment = NSTextAlignmentCenter; break;
        case 3: title = LocalizedString(@"fen"); labelStr.textAlignment = NSTextAlignmentLeft; break;
        default:
            break;
    }
    labelStr.text = title;
    labelStr.textColor = pickerView.userInteractionEnabled?[UIColor blackColor]:[UIColor grayColor];
    
    view = labelStr;
    return view;
}

- (void)onTouchRepeat:(UIButton *)btnRepeat
{
    btnRepeat.selected = !btnRepeat.selected;
    if (btnRepeat.selected) {
        btnRepeat.backgroundColor = kRepeatItemBgSelectColor;
    }
    else {
        btnRepeat.backgroundColor = kRepeatItemBgUnselectColor;
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
