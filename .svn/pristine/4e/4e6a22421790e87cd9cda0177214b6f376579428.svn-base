//
//  UIViewNews.m
//  ChinaBrowser
//
//  Created by David on 14/11/5.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIViewNews.h"

#import "MJRefresh.h"
#import "UICellNews.h"
#import "UIViewSectionHeader.h"

#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

#import "ModelNews.h"

#import "ADONewsStatus.h"

@interface UIViewNews () <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *_tableView;
    MJRefreshHeaderView *_refreshView;
    
    NSMutableArray *_arrNews;
    AFJSONRequestOperation *_afReqNews;
    
    UIViewSectionHeader *_viewSectionHeader;
}

@end

@implementation UIViewNews

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (instancetype)viewFromXib
{
    return [[NSBundle mainBundle] loadNibNamed:@"UIViewNews" owner:nil options:nil][0];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _arrNews = [NSMutableArray array];
    
    _refreshView = [MJRefreshHeaderView header];
    _refreshView.scrollView = _tableView;
    
    __weak UIViewNews* wSelf = self;
    _refreshView.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 进入刷新状态就会回调这个Block
        [wSelf reqNews];
    };
}

- (void)dealloc
{
    _refreshView.beginRefreshingBlock = nil;
    _refreshView.scrollView = nil;
    [_afReqNews cancel];
    _afReqNews = nil;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrNews.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier = @"UICellNews";
    UICellNews *cell = (UICellNews *)[tableView dequeueReusableCellWithIdentifier:Identifier];
    if (!cell) {
        cell = [UICellNews viewFromXib];
        cell.imageViewIcon.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    ModelNews *model = _arrNews[indexPath.row];
    
    if (model.image.length>0) {
        cell.hasImage = YES;
        [cell.imageViewIcon setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"no_pic.png"]];
    }
    else {
        cell.hasImage = NO;
    }
    
    cell.isRead = [ADONewsStatus isReadWithNewsId:model.newsId];
    
    cell.labelTitle.text = model.title;
    cell.labelDescr.text = model.descr;
    cell.labelSource.text = [model.refinfo stringByAppendingFormat:@"    %@", model.time];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (!_viewSectionHeader) {
        _viewSectionHeader = [[UIViewSectionHeader alloc] initWithFrame:CGRectZero];
        _viewSectionHeader.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1];
        _viewSectionHeader.labelTitle.text = _cateName;
    }
    return _viewSectionHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 94;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = (indexPath.row%2)?[UIColor colorWithWhite:0.97 alpha:1]:[UIColor clearColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ModelNews *model = _arrNews[indexPath.row];
    if ([ADONewsStatus isExistWithNewsId:model.newsId]) {
        [ADONewsStatus updateReadStatusWithNewsId:model.newsId isRead:YES];
    }
    else {
        [ADONewsStatus addNewsStatusWithNewsId:model.newsId isRead:YES];
    }
    UICellNews *cell = (UICellNews *)[tableView cellForRowAtIndexPath:indexPath];
    cell.isRead = YES;
    
    [_delegate viewNews:self reqLink:[model.link urlEncodeNormal]];
}

#pragma mark - private methods
- (void)reqNews
{
    [_afReqNews cancel];
    _afReqNews = nil;
    
    BOOL (^resolveNews)(NSDictionary *)=^(NSDictionary *dicResult){
        [_arrNews removeAllObjects];
        
        BOOL ret = NO;
        do {
            if (![dicResult isKindOfClass:[NSDictionary class]]) break;
            NSArray *arrDicNews = dicResult[@"data"];
            if (![arrDicNews isKindOfClass:[NSArray class]]) break;
            for (NSDictionary *dicNews in arrDicNews) {
                ModelNews *model = [ModelNews modelWithDict:dicNews];
                [_arrNews addObject:model];
            }
            
            ret = _arrNews.count>0;
            
        } while (NO);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_refreshView endRefreshing];
            [_tableView reloadData];
        });
        
        return ret;
    };
    
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@""]];
    NSDictionary *dicParam = @{@"device":IsiPad?@"ipad":@"iphone",
                               @"catid":@(_cateId),
                               @"pagesize":@(30)};
    NSMutableURLRequest *req = [client requestWithMethod:@"GET" path:GetApiWithName(API_RecommendNews) parameters:dicParam];
    NSString *filepath = [GetCacheDataDir() stringByAppendingPathComponent:[req.URL.absoluteString fileNameMD5WithExtension:@"json"]];
    _afReqNews = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if (resolveNews(JSON)) {
            [_afReqNews.responseData writeToFile:filepath atomically:YES];
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSData *data = [NSData dataWithContentsOfFile:filepath];
        if (data) {
            resolveNews([NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil]);
        }
        else {
            resolveNews(nil);
        }
    }];
    
    [_afReqNews start];
}

#pragma mark - public methods
- (void)refreshData
{
    [_refreshView beginRefreshing];
}

@end
