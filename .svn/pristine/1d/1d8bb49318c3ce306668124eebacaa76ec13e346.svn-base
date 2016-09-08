//
//  UIViewPopBookmark.m
//  ChinaBrowser
//
//  Created by David on 14/12/10.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIViewPopBookmark.h"

#import "UIControlItem.h"

@implementation UIViewPopBookmark
{
    IBOutlet UIControlItem *_controlItemAddToBookmark;
    IBOutlet UIControlItem *_controlItemAddToHomeApp;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_controlItemAddToBookmark setImageNormal:[UIImage imageWithBundleFile:@"iPhone/Home/add_to_label_0.png"]
                                      highlighted:[UIImage imageWithBundleFile:@"iPhone/Home/add_to_label_2.png"]
                                         selected:nil];
        [_controlItemAddToBookmark setTextColorNormal:[UIColor grayColor]
                                          highlighted:[UIColor colorWithRed:0.000 green:0.502 blue:1.000 alpha:1.000]
                                             selected:[UIColor colorWithRed:0.000 green:0.502 blue:1.000 alpha:1.000]];
        _controlItemAddToBookmark.labelTitle.text = LocalizedString(@"jiarushuqian");
        
        [_controlItemAddToHomeApp setImageNormal:[UIImage imageWithBundleFile:@"iPhone/Home/add_to_page_0.png"]
                                     highlighted:[UIImage imageWithBundleFile:@"iPhone/Home/add_to_page_2.png"]
                                        selected:nil];
        [_controlItemAddToHomeApp setTextColorNormal:[UIColor grayColor]
                                         highlighted:[UIColor colorWithRed:0.000 green:0.502 blue:1.000 alpha:1.000]
                                            selected:[UIColor colorWithRed:0.000 green:0.502 blue:1.000 alpha:1.000]];
        _controlItemAddToHomeApp.labelTitle.text = LocalizedString(@"tianjiadaoshouping");
    });
}

- (IBAction)onTouchAddBookmark
{
    if (_callbackWillAddToBookmark) {
        _callbackWillAddToBookmark();
    }
    [self dismissWithCompletion:nil];
}

- (IBAction)onTouchAddHomeApp
{
    if (_callbackWillAddToHomeApp) {
        _callbackWillAddToHomeApp();
    }
    [self dismissWithCompletion:nil];
}

@end
