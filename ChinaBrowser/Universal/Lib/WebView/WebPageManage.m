//
//  WebPageManage.m
//  Browser-Touch
//
//  Created by David on 14-5-22.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "WebPageManage.h"

@interface WebPageManage ()

- (void)memoryWarning;

@end

@implementation WebPageManage
{
    NSMutableArray *_arrWebPage;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _arrWebPage = [NSMutableArray array];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(memoryWarning)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];
    }
    return self;
}

#pragma mark - property
- (UIWebPage *)currWebPage
{
    return _arrWebPage[_currWebPageIndex];
}

- (void)setCurrWebPageIndex:(NSInteger)currWebPageIndex
{
    if (currWebPageIndex>=0 && currWebPageIndex<_arrWebPage.count) {
        _currWebPageIndex = currWebPageIndex;
    }
}

/**
 *  设置当前网页
 *
 *  @param currWebPage UIWebPage, currWebPage 必须存在于当前的容器中，否则设置无效
 */
- (void)setCurrWebPage:(UIWebPage *)currWebPage
{
    NSInteger index = [_arrWebPage indexOfObject:currWebPage];
    if (index>=0 && index<_arrWebPage.count) {
        _currWebPageIndex = index;
    }
}

/**
 *  通过原始链接地址查找网页
 *
 *  @param linkOrigin 原始链接地址
 *
 *  @return UIWebPage
 */
- (UIWebPage *)findWebPageWithOriginLink:(NSString *)linkOrigin
{
    UIWebPage *webPageRet = nil;
    for (UIWebPage *webPage in _arrWebPage) {
        if ([webPage.linkOrigin isEqualToString:linkOrigin]) {
            webPageRet = webPage;
            break;
        }
    }
    return  webPageRet;
}

- (void)setFontScale:(CGFloat)fontScale
{
    if (fontScale!=_fontScale) {
        _fontScale = fontScale;
        
        for (UIWebPage *webPage in _arrWebPage) {
            webPage.fontScale = fontScale;
        }
    }
}

- (void)setNoImageMode:(BOOL)noImageMode
{
    if (noImageMode!=_noImageMode) {
        _noImageMode = noImageMode;
        
        for (UIWebPage *webPage in _arrWebPage) {
            webPage.noImageMode = noImageMode;
        }
    }
}

#pragma mark - private methods
- (NSInteger)numberOfWebPage
{
    return _arrWebPage.count;
}

- (NSArray *)arrWebPage
{
    return _arrWebPage;
}

- (void)memoryWarning
{
    [_arrWebPage enumerateObjectsUsingBlock:^(UIWebPage *webPage, NSUInteger idx, BOOL *stop) {
        if (idx!=_currWebPageIndex) {
            [webPage snapshot];
        }
    }];
}

#pragma mark - public methods
- (void)newWebPageWithFrame:(CGRect)frame
{
    [self newWebPageAndReturnWithFrame:frame];
}

- (UIWebPage *)newWebPageAndReturnWithFrame:(CGRect)frame
{
    UIWebPage *webPage = [[UIWebPage alloc] initWithFrame:frame];
    webPage.fontScale = _fontScale;
    webPage.noImageMode = _noImageMode;
    webPage.shouldShowProgress = YES;
    webPage.delegate = self;
    webPage.clipsToBounds = YES;
    [_arrWebPage addObject:webPage];
    return webPage;
}

- (void)removeAtIndex:(NSInteger)index
{
    UIWebPage *webpage = _arrWebPage[index];
    webpage.webView.delegate = nil;
    webpage.delegate = nil;
    [webpage stop];
    [_arrWebPage removeObjectAtIndex:index];
}

/**
 *  删除最后一个对象（网页）（add by david at 2014.08.06 17:07:05）
 */
- (void)removeLastObject
{
    [self removeAtIndex:MAX(0, _arrWebPage.count-1)];
}

/**
 *  删除网页
 *
 *  @param webPage UIWebPage
 */
- (void)removeWebPage:(UIWebPage *)webPage
{
    NSInteger index = [_arrWebPage indexOfObject:webPage];
    if (index>=0 && index<_arrWebPage.count) {
        [self removeAtIndex:index];
    }
}

/**
 *  从顶部删除一个（排除currWebPage）
 */
- (void)removeAtTopExceptCurrWebPage
{
    if (_arrWebPage.count<2) {
        return;
    }
    
    if (_currWebPageIndex==0) {
        [self removeAtIndex:1];
    }
    else {
        [self removeAtIndex:0];
    }
}

- (UIWebPage *)webPageAtIndex:(NSInteger)index
{
    return _arrWebPage[index];
}

/**
 *  用一个新网页来替换某个索引处的网页（add by david at 2014.08.06 17:07:05）
 *
 *  @param index 即将替换的网页的索引
 *
 *  @return 返回一个已经替换的网页
 */
- (UIWebPage *)replaceWithNewWebPageAtIndex:(NSInteger)index
{
    if (index<0||index>=_arrWebPage.count) {
        return nil;
    }
    return [self replaceWithNewWebPage:_arrWebPage[index]];
}

/**
 *  用一个新网页来替换某个索引处的网页（add by david at 2014.08.06 17:07:05）
 *
 *  @param webPage 即将替换的网页
 *
 *  @return 返回一个已经替换的网页
 */
- (UIWebPage *)replaceWithNewWebPage:(UIWebPage *)webPage
{
    NSInteger index = [_arrWebPage indexOfObject:webPage];
    
    UIWebPage *webPageNew = [[UIWebPage alloc] initWithFrame:webPage.frame];
    webPageNew.clipsToBounds = YES;
    webPageNew.fontScale = _fontScale;
    webPageNew.noImageMode = _noImageMode;
    webPageNew.shouldShowProgress = YES;
    webPageNew.delegate = self;
    
    if (webPage.superview) {
        // 检查是有在某个view上，如果在，也需要替换在view上的
        NSInteger i = [webPage.superview.subviews indexOfObject:webPage];
        [webPage.superview insertSubview:webPageNew atIndex:i];
        [webPage removeFromSuperview];
    }
    
    webPage.webView.delegate = nil;
    webPage.delegate = nil;
    [webPage stop];
    
    [_arrWebPage removeObjectAtIndex:index];
    [_arrWebPage insertObject:webPageNew atIndex:index];
    
    return webPageNew;
}

/**
 *  将当前网页移动到最底部
 */
- (void)moveCurrPageToLast
{
    if (_currWebPageIndex<(_arrWebPage.count-1)) {
        UIWebPage *currWebPage = [self currWebPage];
        [_arrWebPage removeObjectAtIndex:_currWebPageIndex];
        [_arrWebPage addObject:currWebPage];
    }
}

/**
 *  将当前网页移动到顶部
 */
- (void)moveCurrPageToHead
{
    if (_currWebPageIndex!=0) {
        UIWebPage *currWebPage = [self currWebPage];
        [_arrWebPage removeObjectAtIndex:_currWebPageIndex];
        [_arrWebPage insertObject:currWebPage atIndex:0];
    }
}

#pragma mark - UIWebPageDelegate;
- (void)webPage:(UIWebPage *)webPage reqLink:(NSString *)link UrlOpenStyle:(UrlOpenStyle)UrlOpenStyle
{
    if ([_delegate respondsToSelector:@selector(webPageManage:reqLink:UrlOpenStyle:)])
        [_delegate webPageManage:self reqLink:link UrlOpenStyle:UrlOpenStyle];
}

- (void)webPageDidStartLoad:(UIWebPage *)webPage
{
    if ([_delegate respondsToSelector:@selector(webPageManageDidStartLoad:atIndex:)])
        [_delegate webPageManageDidStartLoad:self atIndex:[_arrWebPage indexOfObject:webPage]];
}

- (void)webPageDidEndLoad:(UIWebPage *)webPage
{
    if ([_delegate respondsToSelector:@selector(webPageManageDidEndLoad:atIndex:)])
         [_delegate webPageManageDidEndLoad:self atIndex:[_arrWebPage indexOfObject:webPage]];
}

- (void)webPage:(UIWebPage *)webPage didUpdateTitle:(NSString *)title
{
    if ([_delegate respondsToSelector:@selector(webPageManage:didUpdateTitle:atIndex:)])
        [_delegate webPageManage:self didUpdateTitle:title atIndex:[_arrWebPage indexOfObject:webPage]];
}

- (void)webPage:(UIWebPage *)webPage didUpdateLink:(NSString *)link
{
    if ([_delegate respondsToSelector:@selector(webPageManage:didUpdateLink:atIndex:)])
        [_delegate webPageManage:self didUpdateLink:link atIndex:[_arrWebPage indexOfObject:webPage]];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([_delegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [_delegate scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([_delegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [_delegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

/**
 *  松手回到首页
 *
 *  @param webPage UIWebPage
 */
- (void)webPageWillEndDragBackHome:(UIWebPage *)webPage
{
    if ([_delegate respondsToSelector:@selector(webPageManageWillEndDragBackHome:atInex:)]) {
        [_delegate webPageManageWillEndDragBackHome:self atInex:[_arrWebPage indexOfObject:webPage]];
    }
}

@end
