//
//  UIViewBanner.m
//  DailyHeadlines
//
//  Created by David on 2011-12-16.
//  Copyright 2011年 com.veryapps. All rights reserved.
//

#import "UIViewBanner.h"
#import "ModelBanner.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "SMPageControl.h"
#import "iCarousel.h"

#define kDefaultTimeIntervalScroll  3

#pragma mark - UIViewBanner (private)

@interface UIViewBannerItem : UIView

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation UIViewBannerItem

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.clipsToBounds = YES;
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [self addSubview:_imageView];
    }
    return self;
}

@end

@interface UIViewBanner (private) <iCarouselDataSource, iCarouselDelegate>

// 自动滚动
- (void)autoScroll;

- (void)resizePageControl;

- (void)onTouchClose;

@end

#pragma mark - UIViewBanner

@implementation UIViewBanner
{
    UIButton *_btnClose;
    iCarousel *_carousel;
    SMPageControl *_pageControl;
    
    NSArray *_arrBanner;
    
    NSMutableArray *_arrBannerItems;
    
    // 自动滚动 相关
    NSTimer *_timerScroll;  // 自动滚动定时器器
}

@synthesize delegate = _delegate;

#pragma mark - Properties
- (void)setShouldShowCloseBtn:(BOOL)shouldShowCloseBtn
{
    _shouldShowCloseBtn = shouldShowCloseBtn;
    _btnClose.hidden = !_shouldShowCloseBtn;
}

- (void)setShouldShowPageControl:(BOOL)shouldShowPageControl
{
    _shouldShowPageControl = shouldShowPageControl;
    if (_shouldShowPageControl) {
        _pageControl.hidden = !(_arrBannerItems.count>1);
    }
    else {
        _pageControl.hidden = YES;
    }
}

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _arrBannerItems = [[NSMutableArray alloc] initWithCapacity:0];
        _viewContentMode = UIViewContentModeScaleAspectFill;
        
        _carousel = [[iCarousel alloc] initWithFrame:self.bounds];
        _carousel.delegate = self;
        _carousel.dataSource = self;
        _carousel.pagingEnabled = YES;
        _carousel.bounces = NO;
        _carousel.bounceDistance = 0;
        _carousel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
        _pageControl = [[SMPageControl alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-20, _carousel.bounds.size.width, 20)];
        _pageControl.userInteractionEnabled = NO;
        _pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:0.3 alpha:0.8];
        _pageControl.currentPageIndicatorTintColor = [UIColor colorWithWhite:0.9 alpha:0.8];
        _pageControl.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
        
        _btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnClose.frame = CGRectMake(0, 0, 30, 30);
        [_btnClose setImage:[UIImage imageWithBundleFile:@"ad_close.png"] forState:UIControlStateNormal];
        [_btnClose addTarget:self action:@selector(onTouchClose) forControlEvents:UIControlEventTouchUpInside];
        _btnClose.center = CGPointMake(self.bounds.size.width-_btnClose.bounds.size.width*0.5-5, self.bounds.size.height*0.5);
        _btnClose.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        
        [self addSubview:_carousel];
        [self addSubview:_pageControl];
        [self addSubview:_btnClose];
        
        _viewContentMode = UIViewContentModeScaleToFill;
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [_carousel reloadData];
    [self setNeedsDisplay];
}

// 自动滚动
- (void)autoScroll {
    if ([_arrBannerItems count]==0 || _carousel.isDragging) {
        return;
    }
    if (_pageControl.currentPage+1>=[_arrBannerItems count]) {
        _pageControl.currentPage = 0;
    }
    else {
        _pageControl.currentPage++;
    }
    [_carousel scrollToItemAtIndex:_pageControl.currentPage animated:YES];
}

- (void)resizePageControl {
    CGRect rc = _pageControl.frame;
    rc.size.width = self.bounds.size.width;
    rc.origin.x = 0;
    _pageControl.frame = rc;
    _pageControl.numberOfPages = [_arrBanner count];
    
    if (_shouldShowPageControl) {
        _pageControl.hidden = !(_pageControl.numberOfPages>1);
    }
    else {
        _pageControl.hidden = YES;
    }
}

- (void)onTouchClose
{
    if ([_delegate respondsToSelector:@selector(viewBannerWillDismiss)])
        [_delegate viewBannerWillDismiss];
}

#pragma mark - public methods

- (void)startAutoScroll:(NSTimeInterval)tiScroll {
    [_timerScroll invalidate];
    _timerScroll = nil;
    
    _timerScroll = [NSTimer scheduledTimerWithTimeInterval:tiScroll
                                                    target:self
                                                  selector:@selector(autoScroll)
                                                  userInfo:nil
                                                   repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timerScroll forMode:NSRunLoopCommonModes];
}

- (void)stopAutoScroll {
    [_timerScroll invalidate];
    _timerScroll = nil;
}

- (void)setArrBanner:(NSArray *)arrBanner {
    
    BOOL shouldAutoScroll = _timerScroll!=nil;
    NSTimeInterval tiScroll = _timerScroll.timeInterval;
    [self stopAutoScroll];
    
    NSInteger countOld = [_arrBanner count];
    NSInteger countNew = [arrBanner count];
    
    _arrBanner = nil;
    _arrBanner = [NSArray arrayWithArray:arrBanner];
    
    if (countNew>countOld) {
        // 比以前多了
        for (NSInteger indexBanner=countOld; indexBanner<countNew; indexBanner++) {
            CGRect rc = self.bounds;
            rc.origin.x = indexBanner*rc.size.width;
            UIViewBannerItem *viewBannerItem = [[UIViewBannerItem alloc] initWithFrame:rc];
            viewBannerItem.imageView.contentMode = _viewContentMode;
            viewBannerItem.layer.masksToBounds = YES;
            viewBannerItem.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            [_arrBannerItems addObject:viewBannerItem];
        }
    }
    else {
        // 比以前少了
        for (NSInteger indexBanner=countNew; indexBanner<countOld; indexBanner++) {
            UIViewBannerItem *viewBannerItem = [_arrBannerItems objectAtIndex:countNew];
            [viewBannerItem  removeFromSuperview];
            [_arrBannerItems removeObjectAtIndex:countNew];
        }
    }
    
    for (NSInteger indexBanner=0; indexBanner<countNew; indexBanner++) {
        UIViewBannerItem *viewBannerItem = [_arrBannerItems objectAtIndex:indexBanner];
        viewBannerItem.imageView.contentMode = _viewContentMode;
        viewBannerItem.clipsToBounds = YES;
        ModelBanner *model = _arrBanner[indexBanner];
        if ([[model.image lowercaseString] hasPrefix:@"http://"]) {
            [viewBannerItem.imageView setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageWithBundleFile:@"ad_default.jpg"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        }
        else {
            viewBannerItem.imageView.image = [UIImage imageWithBundleFile:model.image];
        }
    }
    
    _pageControl.numberOfPages = _arrBanner.count;
    _pageControl.currentPage = MIN(_pageControl.currentPage, _pageControl.numberOfPages-1);
    [self resizePageControl];
    
    if (shouldAutoScroll) {
        [self startAutoScroll:tiScroll];
    }
    
    [_carousel reloadData];
}

#pragma mark - iCarouselDataSource, iCarouselDelegate
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return _arrBanner.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    
    if (_arrBannerItems.count>0) {
        view = _arrBannerItems[index];
    }
    view.frame = self.bounds;
    view.clipsToBounds = YES;
    return view;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    CGFloat retVal = value;
    switch (option) {
        case iCarouselOptionWrap:
        {
            retVal = _arrBannerItems.count>1;
        }break;
        default:
            break;
    }
    return retVal;
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    return self.width;
}

- (void)carouselDidEndDragging:(iCarousel *)carousel willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self carouselDidEndDecelerating:carousel];
    }
}

- (void)carouselDidEndDecelerating:(iCarousel *)carousel
{
    _pageControl.currentPage = carousel.currentItemIndex;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    if (index==carousel.currentItemIndex) {
        [_delegate viewBannerDidClick:index];
    }
    else {
        [carousel scrollToItemAtIndex:index animated:YES];
        _pageControl.currentPage = index;
    }
}

@end
