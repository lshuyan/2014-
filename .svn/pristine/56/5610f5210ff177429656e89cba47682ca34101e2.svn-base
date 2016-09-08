//
//  UIScrollViewRecommend.m
//  ChinaBrowser
//
//  Created by David on 14-9-29.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIScrollViewRecommend.h"

#import "UIViewBanner.h"
#import "UIControlItem.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "KTAnimationKit.h"
#import "UIScrollViewNews.h"

#import "ModelBanner.h"
#import "ModelRecommend.h"

#import "MJRefreshHeaderView.h"

// 竖屏横幅广告栏的高度，宽度=屏幕宽
#define kVBanenrH   (134.0f)
// 横屏横幅广告栏的高度，宽度=高度
#define kHBannerH   (110.0f)

#define kMinCateItemW (90.0f)
#define kMinPaddingTB (10.0f)

#define kMinPaddingLR2 (20.0f)
#define kSpaceXY2 (24)

#define kMinPaddingLR3 (15.0f)
#define kSpaceXY3 (5)

#define kMinPaddingLR4 (10.0f)
#define kSpaceXY4 (4)

// 轮动新闻高度
#define kScrollNewsHeight (34.0f)

@interface UIScrollViewRecommend () <UIViewBannerDelegate>

@end

@implementation UIScrollViewRecommend
{
    UIViewBanner *_viewBanner;
    UIScrollViewNews *_scrollViewNews;
    
    NSMutableArray *_arrDicBanner;
    NSMutableArray *_arrCate;
    NSMutableArray *_arrViewCateItem;
    /**
     *  每次旋转都需要重新排序，因为横竖屏布局不一样
     */
    
    AFJSONRequestOperation *_afReqAd;
    AFJSONRequestOperation *_afReqCate;
    AFJSONRequestOperation *_afReqScrollNews;
    
    /**
     *  分类项的宽高，左右填充，上下间隔，128*2,108*3,90*4
     */
    CGFloat _itemW;
    CGFloat _itemH;
    CGFloat _paddingLR;
    CGFloat _spaceXY;
    NSInteger _colCount;
}

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
    
    [self setup];
}

- (void)dealloc
{
    [_afReqAd cancel];
    [_afReqCate cancel];
    
    _afReqAd = nil;
    _afReqCate = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - super methods
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [self resizeItem];
    
    _DEBUG_LOG(@"%s", __FUNCTION__);
}

#pragma mark - AppLanguageProtocol
- (void)updateByLanguage
{
    [self reqAd];
    [self reqCate];
    [self reqScrollNews];
}

#pragma mark - private methods
- (void)setup
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resizeItem) name:KNotificationDidChanageDesktopStyle object:nil];
    
    _arrDicBanner = [NSMutableArray array];
    _arrCate = [NSMutableArray array];
    _arrViewCateItem = [NSMutableArray array];
    
    _scrollViewNews = [[UIScrollViewNews alloc] initWithFrame:CGRectMake(0, 0, self.width, kScrollNewsHeight)];
    _scrollViewNews.backgroundColor = [UIColor whiteColor];
    _scrollViewNews.hidden = YES;
    __weak typeof(self) wSelf = self;
    [_scrollViewNews setCallbackReqLink:^(NSString *link) {
        [wSelf.delegateRecommend scrollViewRecommend:wSelf reqLink:link];
    }];
    [_scrollViewNews setCallbackClose:^{
        [wSelf onTouchBtnClose];
    }];
    [self addSubview:_scrollViewNews];
    
    CGRect rc = self.bounds;
    rc.size.height = IsPortrait?kVBanenrH:kHBannerH;
    _viewBanner = [[UIViewBanner alloc] initWithFrame:rc];
    _viewBanner.delegate = self;
    _viewBanner.shouldShowCloseBtn = NO;
    _viewBanner.shouldShowPageControl = YES;
    _viewBanner.viewContentMode = UIViewContentModeScaleToFill;
    [_viewBanner startAutoScroll:7];
    [self addSubview:_viewBanner];
    
    [self updateByLanguage];
}

- (void)reqAd
{
    [_afReqAd cancel];
    _afReqAd = nil;
    
    NSString *device = IsiPad?@"ipad":@"iphone";
    NSDictionary *dicParam = @{@"device":device};
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@""]];
    NSMutableURLRequest *req = [client requestWithMethod:@"GET" path:GetApiWithName(API_RecommendAd) parameters:dicParam];
    NSString *filepath = [GetCacheDataDir() stringByAppendingPathComponent:[req.URL.absoluteString fileNameMD5WithExtension:@"json"]];
    
    BOOL (^showAd)(NSDictionary *) = ^(NSDictionary *dicResult){
        [_arrDicBanner removeAllObjects];
        
        BOOL retVal = NO;
        do {
            if (![dicResult isKindOfClass:[NSDictionary class]]) break;
            
            NSArray *arrDicBanner = dicResult[@"data"];
            if (![arrDicBanner isKindOfClass:[NSArray class]]) break;
            
            [_arrDicBanner addObjectsFromArray:arrDicBanner];
            
            retVal = _arrDicBanner.count>0;
        } while (NO);
        
        [self updateBanner];
        _viewBanner.hidden = !retVal;
        return retVal;
    };
    
    _afReqAd = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if (showAd(JSON)) {
            [_afReqAd.responseData writeToFile:filepath atomically:YES];
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSData *data = [NSData dataWithContentsOfFile:filepath];
        if (data) {
            showAd([NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil]);
        }
        else {
            showAd(nil);
        }
    }];
    [_afReqAd start];
}

- (void)reqCate
{
    [_afReqCate cancel];
    _afReqCate = nil;
    
    NSString *device = IsiPad?@"ipad":@"iphone";
    NSDictionary *dicParam = @{@"device":device};
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@""]];
    NSMutableURLRequest *req = [client requestWithMethod:@"GET" path:GetApiWithName(API_RecommendCate) parameters:dicParam];
    NSString *filepath = [GetCacheDataDir() stringByAppendingPathComponent:[req.URL.absoluteString fileNameMD5WithExtension:@"json"]];
    
    BOOL (^showCate)(NSDictionary *) = ^(NSDictionary *dicResult){
        [_arrViewCateItem makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [_arrViewCateItem removeAllObjects];
        [_arrCate removeAllObjects];
        
        BOOL retVal = NO;
        do {
            if (![dicResult isKindOfClass:[NSDictionary class]]) break;
            
            NSArray *arrDicCate = dicResult[@"data"];
            if (![arrDicCate isKindOfClass:[NSArray class]]) break;
            
            // 解析成模型对象
            for (NSDictionary *dicCate in arrDicCate) {
                ModelRecommend *model = [ModelRecommend modelWithDict:dicCate];
                [_arrCate addObject:model];
                
                UIControlItem *viewCateItem = [UIControlItem viewFromXibWithType:ControlItemTypeRecommendCate];
//                viewCateItem.imageViewIcon.contentMode = UIViewContentModeScaleAspectFit;
//                viewCateItem.imageViewIcon.backgroundColor = [UIColor randomColor];
                __unsafe_unretained UIImageView *wImageViewIcon = viewCateItem.imageViewIcon;
                [viewCateItem.imageViewIcon setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:nil usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                    wImageViewIcon.image = image;//[UIImage imageWithData:UIImagePNGRepresentation(image) scale:[UIScreen mainScreen].scale];
                    [KTAnimationKit animationEaseIn:wImageViewIcon];
                }];
                
                viewCateItem.labelTitle.text = model.name;
                [viewCateItem addTarget:self action:@selector(onTouchItem:) forControlEvents:UIControlEventTouchUpInside];
                [_arrViewCateItem addObject:viewCateItem];
                [self addSubview:viewCateItem];
                
                UIColor *bgColor = [UIColor clearColor];
                [viewCateItem setBgColorNormal:bgColor highlighted:[UIColor colorWithWhite:0.96 alpha:0.05]];
                [viewCateItem setTextColorNormal:[UIColor whiteColor]
                                     highlighted:[UIColor colorWithWhite:0.94 alpha:1]
                                        selected:nil];
                
//                viewCateItem.layer.allowsEdgeAntialiasing = NO;
//                viewCateItem.layer.shouldRasterize = NO;
//                viewCateItem.layer.borderWidth = 0.5;
//                viewCateItem.layer.borderColor = [UIColor colorWithWhite:0.85 alpha:0.3].CGColor;
            }
            
            [self resizeItem];
            
            retVal = _arrCate.count>0;
        } while (NO);
        
        return retVal;
    };
    
    _afReqCate = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if (showCate(JSON)) {
            [_afReqCate.responseData writeToFile:filepath atomically:YES];
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSData *data = [NSData dataWithContentsOfFile:filepath];
        if (data) {
            showCate([NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil]);
        }
        else {
            showCate(nil);
        }
    }];
    [_afReqCate start];
}

- (void)reqScrollNews
{
    [_afReqScrollNews cancel];
    _afReqScrollNews = nil;
    
    NSString *device = IsiPad?@"ipad":@"iphone";
    NSDictionary *dicParam = @{@"device":device};
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@""]];
    NSMutableURLRequest *req = [client requestWithMethod:@"GET" path:GetApiWithName(API_RecommendScrollNews) parameters:dicParam];
    NSString *filepath = [GetCacheDataDir() stringByAppendingPathComponent:[req.URL.absoluteString fileNameMD5WithExtension:@"json"]];
    
    BOOL (^resolve)(NSDictionary *dictResult) = ^(NSDictionary *dictResult){
        [_scrollViewNews setArrDictNews:nil];
        
        BOOL retVal = NO;
        do {
            if (![dictResult isKindOfClass:[NSDictionary class]]) break;
            
            NSArray *arrDictNews = dictResult[@"data"];
            if (![arrDictNews isKindOfClass:[NSArray class]]) break;
            
            [_scrollViewNews setArrDictNews:arrDictNews];
            retVal = arrDictNews.count>0;
        } while (NO);
        _scrollViewNews.hidden = !retVal;
        if (retVal) {
            [UIView animateWithDuration:0.35 animations:^{
                [self resizeItem];
            }];
        }
        return retVal;
    };
    
    _afReqScrollNews = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if (resolve(JSON)) {
            [_afReqScrollNews.responseData writeToFile:filepath atomically:YES];
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSData *data = [NSData dataWithContentsOfFile:filepath];
        if (data) {
            resolve([NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil]);
        }
        else {
            resolve(nil);
        }
    }];
    [_afReqScrollNews start];
}

- (void)updateBanner
{
    NSMutableArray *arrModelBanner = [NSMutableArray arrayWithCapacity:_arrDicBanner.count];
    for (NSDictionary *dicBanner in _arrDicBanner) {
        ModelBanner *model = [ModelBanner model];
        if (IsPortrait) {
            model.image = dicBanner[@"img_v"];
        }
        else {
            model.image = dicBanner[@"img_h"];
        }
        model.link = dicBanner[@"link"];
        [arrModelBanner addObject:model];
    }
    
    [_viewBanner setArrBanner:arrModelBanner];
}

- (NSInteger)getColCount
{
    // 默认按横屏允许的最小宽高计算列数
    CGFloat baseMinItemWidth = kMinCateItemW;
    if (IsPortrait) {
        // 竖屏时，需要根据App设置的桌面样式计算列数
        switch ([AppSetting shareAppSetting].desktopStyle) {
            case DesktopStyleCol2:
            {
                _paddingLR = kMinPaddingLR2;
                _spaceXY = kSpaceXY2;
            }break;
            case DesktopStyleCol3:
            {
                _paddingLR = kMinPaddingLR3;
                _spaceXY = kSpaceXY3;
            }break;
            case DesktopStyleCol4:
            {
                _paddingLR = kMinPaddingLR4;
                _spaceXY = kSpaceXY4;
            }break;
            default:
                break;
        }
        
        NSInteger colTotal = (NSInteger)[AppSetting shareAppSetting].desktopStyle;
        CGFloat width = self.width-_paddingLR*2;
        if (colTotal>1) {
            width -= (colTotal-1)*_spaceXY;
        }
        baseMinItemWidth = floorf(width/colTotal);
    }
    else {
        _paddingLR = kMinPaddingLR4;
        _spaceXY = kSpaceXY4;
    }
    CGFloat w = _paddingLR+baseMinItemWidth;
    NSInteger colCount = 0;
    while (w+_paddingLR<=self.bounds.size.width) {
        colCount++;
        w+=baseMinItemWidth;
    }
    return colCount;
}

- (void)resizeItem
{
    _colCount = [self getColCount];
    CGFloat widthTotal = self.width-_paddingLR*2;
    if (_colCount>1) {
        widthTotal -= (_colCount-1)*_spaceXY;
    }
    _itemW = widthTotal/_colCount;
    _itemH = _itemW+20.0f;
    
    // 布局_viewBanner ------------------------
    [self updateBanner];
    
    CGRect rc = self.bounds;
    rc.origin = CGPointZero;
    rc.size.height = IsPortrait?kVBanenrH:kHBannerH;
    _viewBanner.frame = rc;
    
    rc = CGRectMake(0, _viewBanner.bottom, self.width, _scrollViewNews.height);
    _scrollViewNews.frame = rc;
    
    CGFloat originYBegin = 0;
    if (_scrollViewNews.superview) {
        originYBegin = _scrollViewNews.hidden?_viewBanner.bottom:_scrollViewNews.bottom;
    }
    else {
        originYBegin = _viewBanner.bottom;
    }
    
    if (_arrCate.count==0) {
        self.contentSize = CGSizeMake(self.width, originYBegin);
        return;
    }
    
    // 布局 cate Item ------------------------
    // 拆分成上下两组数据，一组是 非新闻分类，另一个组是 新闻分类
    NSMutableArray *arrNotNewCateIndex = [NSMutableArray array];
    NSMutableArray *arrResortCateIndex = [NSMutableArray array];
    for (NSInteger i=0; i<_arrCate.count; i++) {
        ModelRecommend *model = _arrCate[i];
        if (RecommendTypeNewsCate!=model.type && arrNotNewCateIndex.count<2) {
            [arrNotNewCateIndex addObject:@(i)];
        }
        else {
            [arrResortCateIndex addObject:@(i)];
        }
    }
    
    // 根据桌面样式，将 前两个 非新闻分类 分配到对应的布局索引
    NSArray *arrToIndex = nil;
    if (IsPortrait) {
        switch ([AppSetting shareAppSetting].desktopStyle) {
            case DesktopStyleCol2:
            {
                // 非新闻分类的前两项索引位置：0,1
                arrToIndex = @[@(0), @(1)];
            }break;
            case DesktopStyleCol3:
            {
                // 非新闻分类的前两项索引位置：1,4
                arrToIndex = @[@(0), @(1)];
            }break;
            case DesktopStyleCol4:
            {
                // 非新闻分类的前两项索引位置：1,4
                arrToIndex = @[@(1), @(2)];
            }break;
            default:
                break;
        }
    }
    else {
        arrToIndex = @[@(0), @(1)];
    }
    
    NSInteger countNotNewsCateIndex = MIN(2, arrNotNewCateIndex.count);
    for (NSInteger i=0; i<countNotNewsCateIndex; i++) {
        [arrResortCateIndex insertObject:arrNotNewCateIndex[i] atIndex:[arrToIndex[i] integerValue]];
    }
    
    NSInteger beginIndex = 0;
    CGFloat beingOriginY = originYBegin;
    
    /*
    if (!IsPortrait) {
        // 横屏
        beginIndex = arrToIndex.count;
        
        rc = CGRectMake(0, 0, kHBannerH, kHBannerH);
        UIView *view0 = _arrViewCateItem[[arrResortCateIndex[0] integerValue]];
        view0.frame = rc;
        
        rc.origin.x = _viewBanner.right;
        UIView *view1 = _arrViewCateItem[[arrResortCateIndex[1] integerValue]];
        view1.frame = rc;
    }
    else if (DesktopStyleCol4 == [AppSetting shareAppSetting].desktopStyle) {
        beginIndex = 6;
        beingOriginY = originYBegin+_itemW*2;
        for (NSInteger i=0; i<beginIndex; i++) {
            NSInteger col = GetColWithIndexCol(i, 3);
            NSInteger row = GetRowWithIndexCol(i, 3);
            
            rc = CGRectMake((_itemW*col),
                                   originYBegin+(_itemW)*row,
                                   _itemW,
                                   _itemW);
            if (1==col||4==col) {
                rc.size.width *= 2;
            }
            else if (2==col||5==col) {
                rc.origin.x += rc.size.width;
            }
            
            NSInteger viewCateItemIndex = [arrResortCateIndex[i] integerValue];
            UIView *viewCate = _arrViewCateItem[viewCateItemIndex];
            viewCate.frame = rc;
        }
    }
     */
    
    NSInteger itemCount = arrResortCateIndex.count;
    for (NSInteger i=beginIndex; i<itemCount; i++) {
        NSInteger newIndex = i-beginIndex;
        NSInteger col = GetColWithIndexCol(newIndex, _colCount);
        NSInteger row = GetRowWithIndexCol(newIndex, _colCount);
        rc = CGRectMake(_paddingLR+(_itemW+_spaceXY)*col,
                        kMinPaddingTB+beingOriginY+(_itemH+_spaceXY)*row,
                        _itemW,
                        _itemH);
        
        NSInteger viewCateItemIndex = [arrResortCateIndex[i] integerValue];
        UIView *viewCate = _arrViewCateItem[viewCateItemIndex];
        viewCate.frame = rc;
    }
    
    UIView *viewLast = _arrViewCateItem[[[arrResortCateIndex lastObject] integerValue]];
    self.contentSize = CGSizeMake(self.width, viewLast.bottom+kMinPaddingTB);
}

- (void)onTouchItem:(UIControlItem *)item
{
    NSInteger index = [_arrViewCateItem indexOfObject:item];
    ModelRecommend *model = _arrCate[index];
    _DEBUG_LOG(@"%s:%@:%ld", __FUNCTION__, model.name, (long)model.type);
    switch (model.type) {
        case RecommendTypeNewsCate:
        {
            [_delegateRecommend scrollViewRecommend:self reqNewsWithCateId:model.catId cateName:model.name];
        }break;
        case RecommendTypeLink:
        {
            [_delegateRecommend scrollViewRecommend:self reqLink:model.link];
        }break;
        case RecommendTypeSubCate:
        {
            [_delegateRecommend scrollViewRecommend:self reqSubCateWithCateId:model.catId];
        }break;
        case RecommendTypeLiveStream:
        {
            
        }break;
            
        default:
            break;
    }
}

- (void)onTouchBtnClose
{
    [_scrollViewNews removeFromSuperview];
    [UIView animateWithDuration:0.35 animations:^{
        [self resizeItem];
    }];
}

#pragma mark - UIViewBannerDelegate
- (void)viewBannerDidClick:(NSInteger)index
{
    NSDictionary *dicBanner = _arrDicBanner[index];
    NSString *link = dicBanner[@"link"];
    if ([_delegateRecommend respondsToSelector:@selector(scrollViewRecommend:reqLink:)])
        [_delegateRecommend scrollViewRecommend:self reqLink:link];
}

@end
