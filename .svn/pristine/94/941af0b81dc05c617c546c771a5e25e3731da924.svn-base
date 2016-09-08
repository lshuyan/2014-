
//
//  UIScrollViewTravel.m
//  ChinaBrowser
//
//  Created by David on 14-9-18.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIScrollViewTravel.h"

#import "UIViewTravelItem.h"

#import "UIViewBanner.h"

#import "ModelBanner.h"
#import "ModelTravelProvince.h"

#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

#define kHWRate_iPhone (320.0f/640.0)

//
//#define kHWRate_iPad_V (496.0f/1536.0)
//#define kHWRate_iPad_H (496.0f/2048.0)

#define kHWRate_iPad_V (640.0f/1536.0)
#define kHWRate_iPad_H (640.0f/2048.0)


@interface UIScrollViewTravel () <UIViewBannerDelegate>

@end

@implementation UIScrollViewTravel
{
    UIViewBanner *_viewBanner;
    
    NSMutableArray *_arrDicBanner;
    NSMutableArray *_arrItem;
    NSMutableArray *_arrViewItem;
    
    UIWindow *_wnd;
    NSInteger _showIndex;
    
    AFJSONRequestOperation *_reqBanner;
    AFJSONRequestOperation *_reqProvince;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_reqBanner cancel];
    [_reqProvince cancel];
    
    _reqBanner = nil;
    _reqProvince = nil;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setup];
}

- (void)setup
{
    _paddingLR = _paddingTB = 0;
    _spacex = _spacey = 3;
    
    CGRect rc = CGRectZero;
    rc.origin.x = _paddingLR;
    rc.origin.y = _paddingTB;
    rc.size.width = self.bounds.size.width-rc.origin.x*2;
    rc.size.height = rc.size.width*(IsiPad?(IsPortrait?kHWRate_iPad_V:kHWRate_iPad_H):kHWRate_iPhone);
    _viewBanner = [[UIViewBanner alloc] initWithFrame:rc];
    _viewBanner.delegate = self;
    _viewBanner.shouldShowPageControl = NO;
    _viewBanner.shouldShowCloseBtn = NO;
    [_viewBanner startAutoScroll:7];
    [self addSubview:_viewBanner];
    
    _arrDicBanner = [NSMutableArray array];
    _arrViewItem = [NSMutableArray array];
    _arrItem = [NSMutableArray array];
    
    [self updateByLanguage];
}

- (void)setFrame:(CGRect)frame
{
    
    CGFloat offsetRate = 0;
    if (self.contentSize.height>0) {
        offsetRate = (self.contentOffset.y+self.height/2)/self.contentSize.height;
    }
    
    [super setFrame:frame];
    
    [self resizeItem];
    
    CGPoint offset = CGPointMake(0, offsetRate*self.contentSize.height-self.height/2);
    if (offset.y<0) {
        offset.y = 0;
    }
    else if (offset.y>self.contentSize.height-self.height) {
        offset.y = self.contentSize.height-self.height;
        if (offset.y<0) {
            offset.y = 0;
        }
    }
    self.contentOffset = offset;
}

- (void)resizeItem
{
    
    CGRect rc = CGRectMake(_paddingLR, _paddingTB, self.bounds.size.width-_paddingLR*2, 0);
    rc.size.height = rc.size.width*(IsiPad?(IsPortrait?kHWRate_iPad_V:kHWRate_iPad_H):kHWRate_iPhone);
    _viewBanner.frame = rc;
    
    if (IsiPad) {
        [self updateBanner];
    }
    
    if (_arrViewItem.count<=0) {
        self.contentSize = CGSizeMake(self.bounds.size.width, _viewBanner.bottom);
        return;
    }
    
    rc.size.width = (_viewBanner.bounds.size.width-_spacex)/2;
    CGFloat imageH = 0; // 计算


    CGFloat colHeight[2] = {0.0, 0.0};
    
    for (NSInteger i=0; i<_arrViewItem.count; i++) {
        UIViewTravelItem *viewTravelItem = _arrViewItem[i];
        ModelTravelProvince *model = _arrItem[i];
        CGFloat w = model.imageSize.width;
        CGFloat h = model.imageSize.height;
        if (h==0 || w==0) {
            viewTravelItem.alpha = 0;
            continue;
        }
        viewTravelItem.alpha = 1;
        imageH = h/w*rc.size.width;
        NSInteger col = colHeight[0]<=colHeight[1]?0:1;
        CGFloat colH = colHeight[col];
        rc.size.height = imageH;
        rc.origin.x = _paddingLR+(rc.size.width+_spacex)*col;
        rc.origin.y = _viewBanner.bottom+_spacey+colH;
        colHeight[col] = colH+imageH+_spacey;
        viewTravelItem.frame = CGRectIntegral(rc);
    }
    
    self.contentSize = CGSizeMake(self.bounds.size.width, _viewBanner.bottom+MAX(colHeight[0], colHeight[1])+5);
}

#pragma mark - AppLanguageProtocol
- (void)updateByLanguage
{
    [self reqBanner];
    [self reqProvince];
}

- (void)reqBanner
{
    [_reqBanner cancel];
    _reqBanner = nil;
    
    NSString *device = IsiPad?@"ipad":@"iphone";
    NSDictionary *dicParam = @{@"device":device};
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@""]];
    NSMutableURLRequest *req = [client requestWithMethod:@"GET" path:GetApiWithName(API_TravelAd) parameters:dicParam];
    NSString *filepath = [GetCacheDataDir() stringByAppendingPathComponent:[req.URL.absoluteString fileNameMD5WithExtension:@"json"]];
    
    BOOL (^showImage)(NSDictionary *dicResult)= ^(NSDictionary *dicResult){
        [_arrDicBanner removeAllObjects];
        
        BOOL retVal = NO;
        do {
            if (![dicResult isKindOfClass:[NSDictionary class]]) break;
            
            NSArray *arrData = dicResult[@"data"];
            if (![arrData isKindOfClass:[NSArray class]]) break;
            
            [_arrDicBanner addObjectsFromArray:arrData];
            retVal = _arrDicBanner.count>0;
        } while (NO);
        [self updateBanner];
        return retVal;
    };
    
    _reqBanner = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if (showImage(JSON)) {
            [_reqBanner.responseData writeToFile:filepath atomically:YES];
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSData *data = [NSData dataWithContentsOfFile:filepath];
        if (data) {
            showImage([NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil]);
        }
        else {
            showImage(nil);
        }
        
        _DEBUG_LOG(@"%s:%@", __FUNCTION__, error);
    }];
    [_reqBanner start];
}

- (void)reqProvince
{
    [_reqProvince cancel];
    _reqProvince = nil;
    
    NSString *device = IsiPad?@"ipad":@"iphone";
    NSDictionary *dicParam = @{@"device":device};
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@""]];
    NSMutableURLRequest *req = [client requestWithMethod:@"GET" path:GetApiWithName(API_Travel) parameters:dicParam];
    NSString *filepath = [GetCacheDataDir() stringByAppendingPathComponent:[req.URL.absoluteString fileNameMD5WithExtension:@"json"]];
    
    BOOL (^resetProvince)(NSDictionary *) = ^(NSDictionary *dicResult){
        [_arrViewItem makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [_arrViewItem removeAllObjects];
        [_arrItem removeAllObjects];
        
        BOOL retVal = NO;
        do {
            if (![dicResult isKindOfClass:[NSDictionary class]]) break;
            
            NSArray *arrDicProvince = dicResult[@"data"];
            if (![arrDicProvince isKindOfClass:[NSArray class]]) break;
            
            for (NSDictionary *dicProvince in arrDicProvince) {
                ModelTravelProvince *model = [ModelTravelProvince modelWithDict:dicProvince];
                [_arrItem addObject:model];
                CGRect rc = CGRectZero;
                rc.size = model.imageSize;
                
                UIViewTravelItem *viewTravelItem = [UIViewTravelItem viewFromXib];
                viewTravelItem.backgroundColor = [UIColor lightGrayColor];
                viewTravelItem.frame = rc;
                viewTravelItem.labelTitle.text = model.name;
                [viewTravelItem.imageView setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageWithBundleFile:@"home/ad_default.jpg"]];
                [viewTravelItem addTarget:self action:@selector(onTouchItem:) forControlEvents:UIControlEventTouchUpInside];
                
                [self addSubview:viewTravelItem];
                [_arrViewItem addObject:viewTravelItem];
            }
            
            [self resizeItem];
            
            retVal = _arrItem.count>0;
        } while (NO);
        
        return retVal;
    };
    
    _reqProvince = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if (resetProvince(JSON)) {
            [_reqProvince.responseData writeToFile:filepath atomically:YES];
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSData *data = [NSData dataWithContentsOfFile:filepath];
        if (data) {
            resetProvince([NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil]);
        }
        else {
            resetProvince(nil);
        }
        
        _DEBUG_LOG(@"%s:%@", __FUNCTION__, error);
    }];
    [_reqProvince start];
}

- (void)updateBanner
{
    NSMutableArray *arrModelBanner = [NSMutableArray arrayWithCapacity:_arrDicBanner.count];
    for (NSDictionary *dicBanner in _arrDicBanner) {
        ModelBanner *model = [ModelBanner model];
        if (IsiPad) {
            if (IsPortrait) {
                model.image = dicBanner[@"img_v"];
            }
            else {
                model.image = dicBanner[@"img_h"];
            }
        }
        else {
            model.image = dicBanner[@"img_v"];
        }
        model.link = dicBanner[@"link"];
        [arrModelBanner addObject:model];
    }
    
    [_viewBanner setArrBanner:arrModelBanner];
}

- (void)onTouchItem:(UIViewTravelItem *)item
{
    NSInteger index = [_arrViewItem indexOfObject:item];
    _showIndex = index;
    
    ModelTravelProvince *model = _arrItem[index];
    
    [_delegateTravel scrollViewTravel:self selectProvince:model];
}

#pragma mark - UIViewBannerDelegate
- (void)viewBannerDidClick:(NSInteger)index
{
    NSDictionary *dicBanner = _arrDicBanner[index];
    [_delegateTravel scrollViewTravel:self reqLink:dicBanner[@"link"]];
}

@end
