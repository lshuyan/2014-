//
//  UIViewPopSetFontSize.m
//  ChinaBrowser
//
//  Created by David on 14/11/11.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIViewPopSetFontSize.h"

@interface UIViewPopSetFontSize () <UIWebViewDelegate>

@end

@implementation UIViewPopSetFontSize
{
    __weak IBOutlet UIWebView *_webView;
    __weak IBOutlet UILabel *_labelTips;
    __weak IBOutlet UILabel *_labelFontSize;
    __weak IBOutlet UISlider *_sliderFontSize;
    __weak IBOutlet UIImageView *_imageViewSmallIcon;
    __weak IBOutlet UIImageView *_imageViewBigIcon;
    
}

- (IBAction)onValueChanged:(UISlider *)sender
{
    NSInteger fontSize = roundf(_sliderFontSize.value);
    NSString *js = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%f%%'", (NSInteger)fontSize/kDefaultFontsize*100];
    [_webView stringByEvaluatingJavaScriptFromString:js];
    
    if (fontSize==kDefaultFontsize) {
        _labelFontSize.text = [[@(fontSize) stringValue] stringByAppendingString:@"(默认)"];
    }
    else {
        _labelFontSize.text = [@(fontSize) stringValue];
    }
}

- (IBAction)onTouchUp:(UISlider *)sender
{
    [self onValueChanged:_sliderFontSize];
}

#pragma mark - super methods
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _labelTips.text = LocalizedString(@"zitidaxiaoshezhi_tishi");
    _imageViewBigIcon.image = [UIImage imageWithBundleFile:@""];
    _imageViewSmallIcon.image = [UIImage imageWithBundleFile:@""];
    
    NSInteger fontSize = (NSInteger)[AppSetting shareAppSetting].fontsize;
    if (fontSize==kDefaultFontsize) {
        _labelFontSize.text = [[@(fontSize) stringValue] stringByAppendingFormat:@"(%@)", LocalizedString(@"moren")];
    }
    else {
        _labelFontSize.text = [@(fontSize) stringValue];
    }
    
    _sliderFontSize.maximumValue = kMaxFontsize;
    _sliderFontSize.minimumValue = kMinFontsize;
    _sliderFontSize.value = fontSize;
    
    _webView.opaque = NO;
    _webView.layer.masksToBounds = YES;
    _webView.layer.borderColor = [UIColor colorWithWhite:0.85 alpha:0.8].CGColor;
    _webView.layer.borderWidth = 0.5;
    _webView.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1];
    _webView.userInteractionEnabled = NO;
    
    NSString *html = [NSString stringWithFormat:@"<style>*{margin:0;padding:5;}</style><span>%@</span>", LocalizedString(@"zitidaxiaoshezhi_shiliwenzi")];
    [_webView loadHTMLString:html baseURL:nil];
}

- (void)onTouchOk
{
    NSInteger fontSize = roundf(_sliderFontSize.value);
    [_delegate viewPopSetFontSize:self selectFontSize:fontSize];
    [self dismissWithCompletion:nil];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    _DEBUG_LOG(@"%s", __FUNCTION__);
    NSString *js = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%0.2f%%'", [AppSetting shareAppSetting].fontScale*100];
    [webView stringByEvaluatingJavaScriptFromString:js];
}

@end
