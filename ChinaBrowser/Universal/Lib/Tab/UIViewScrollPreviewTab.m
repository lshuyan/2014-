//
//  UIViewScrollPreviewTab.m
//  TaoKe
//
//  Created by David on 14-1-17.
//  Copyright (c) 2014年 KOTO. All rights reserved.
//

#import "UIViewScrollPreviewTab.h"

#import "UIViewPreviewTab.h"
#import <QuartzCore/QuartzCore.h>

#define TitleHeight 15.0f

@interface UIViewScrollPreviewTab () <UIViewPreviewTabDelegate>

- (void)setup;

/**
 *  根据当前 网页 缩略图 的偏移量，自动计算 当前应该显示的 UIViewPreviewTab，并设置对应标签高亮
 *
 */
- (void)setHighlightTabIndexByThumbOffset;

- (void)createPreview:(NSArray *)arrView;

- (CGFloat)thumbW;
- (CGFloat)thumbH;

@end

@implementation UIViewScrollPreviewTab
{
    UILabel *_labelIndexInfo;
}

- (CGFloat)thumbW
{
    return _previewTabScale*_rcOrigin.size.width;
}

- (CGFloat)thumbH
{
    return _previewTabScale*_rcOrigin.size.height;
}

- (CGRect)previewFrame
{
    return CGRectApplyAffineTransform(_rcOrigin, CGAffineTransformMakeScale(_previewTabScale, _previewTabScale));
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

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}

#pragma mark - private methods
- (void)setup
{
    self.delegate = self;
    _previewTabScale = 0.5;
    _previewTabSpace = 20.0f;
    
    _labelIndexInfo = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, TitleHeight)];
    _labelIndexInfo.textColor = [UIColor whiteColor];
    _labelIndexInfo.font = [UIFont systemFontOfSize:12];
    _labelIndexInfo.backgroundColor = [UIColor clearColor];
    _labelIndexInfo.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:_labelIndexInfo];
}

/**
 *  根据当前 网页 缩略图 的偏移量，自动计算 当前应该显示的 UIViewPreviewTab，并设置对应标签高亮
 *
 */
- (void)setHighlightTabIndexByThumbOffset
{
    if (!self.superview) return;
    
    CGPoint center = CGPointMake(self.contentOffset.x+self.bounds.size.width/2,
                                 self.bounds.size.height/2);
    __block BOOL find = NO;
    [_arrPreviewTab enumerateObjectsUsingBlock:^(UIViewPreviewTab *viewPreviewTab, NSUInteger idx, BOOL *stop) {
        if (find) {
            viewPreviewTab.labelTitle.highlighted = NO;
        }
        else {
            CGRect rc = CGRectInset(viewPreviewTab.frame, -_previewTabSpace/2, 0);
            if (CGRectContainsPoint(rc, center)) {
                _selectedIndex = [_arrPreviewTab indexOfObject:viewPreviewTab];
                viewPreviewTab.labelTitle.highlighted = YES;
                find = YES;
            }
            else {
                viewPreviewTab.labelTitle.highlighted = NO;
            }
        }
    }];
}

- (void)createPreview:(NSArray *)arrView
{
    if (arrView.count>0) {
        _arrPreviewTab = [NSMutableArray arrayWithCapacity:arrView.count];
        [arrView enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
            UIViewPreviewTab *viewPreviewTab = [UIViewPreviewTab viewPreviewTabWithView:view scale:1];
            viewPreviewTab.delegate = self;
            viewPreviewTab.alpha = 0;
            viewPreviewTab.viewPreview.userInteractionEnabled = NO;
            viewPreviewTab.labelTitle.text = [_delegatePreviewTab titleForTabViewScrollPreviewTab:self atIndex:idx];
            [_arrPreviewTab addObject:viewPreviewTab];
        }];
    }
}


#pragma mark - public
/**
 *  显示
 *
 *  @param view             现在到的目标视图，将自己插入到父视图的最底层，index=0 的位置
 *  @param arrView          arrView
 *  @param selectIndex      选中缩略索引
 *  @param complation       动画结束
 */
- (void)showInView:(UIView *)view arrView:(NSArray *)arrView selectIndex:(NSInteger)selectIndex rcOrigin:(CGRect)rcOrigin completion:(void(^)(void))completion
{
    _show = YES;
    self.delegate = self;
    _rcOrigin = rcOrigin;
    _arrPreviewTab = nil;
    
    [arrView enumerateObjectsUsingBlock:^(UIView *preview, NSUInteger idx, BOOL *stop) {
        if (![preview isKindOfClass:[UIImageView class]]) {
            preview.frame = rcOrigin;
        }
    }];
    
    [self createPreview:arrView];
    
    _selectedIndex = selectIndex;
    UIViewPreviewTab *viewPreviewTabSelected = _arrPreviewTab[_selectedIndex];
    viewPreviewTabSelected.alpha = 1;
    
    view.userInteractionEnabled = NO;
    // 1、移除所有 子视图
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.alpha = 1;
    
    // 2、添加到 指定的 view 上
    [view insertSubview:self atIndex:1];
    [self addSubview:_labelIndexInfo];
    
    // 3、设置 contentSize
    NSInteger pageCount = _arrPreviewTab.count;
    CGFloat paddingLR = floorf((self.width-[self thumbW])/2);
    CGFloat contentW = paddingLR*2+[self thumbW]*pageCount;
    if (pageCount>=1) {
        contentW+=_previewTabSpace*(pageCount-1);
    }
    self.contentSize = CGSizeMake(contentW, self.bounds.size.height);
    
    // 4、滚动到可视区域
    self.contentOffset = CGPointMake(paddingLR+(_previewTabSpace+[self thumbW])*_selectedIndex+([self thumbW]-self.width)/2, 0);
    
    // 5、计算 初始化 显示区域
    CGRect rcVisible = [view convertRect:rcOrigin toView:self];
    rcVisible.origin.x = self.contentOffset.x;
    viewPreviewTabSelected.frame = rcVisible;
    
    CGPoint center = _labelIndexInfo.center;
    center.x = MIN(MAX(self.contentOffset.x+self.width/2, self.width/2), self.contentSize.width-self.width/2);
    center.y = (self.height-[self thumbH])/2.0-_labelIndexInfo.height-5;
    _labelIndexInfo.center = center;
    _labelIndexInfo.text = [NSString stringWithFormat:@"%ld/%lu", (long)_selectedIndex+1, (unsigned long)_arrPreviewTab.count];
    
    // 6、添加到 缩略视图里面去，显示在 初始化显示区域
    CGAffineTransform tfScale = CGAffineTransformMakeScale(_previewTabScale, _previewTabScale);
    for (NSInteger i=0; i<pageCount; i++) {
        UIViewPreviewTab *viewPreviewTab = _arrPreviewTab[i];
        viewPreviewTab.labelTitle.highlighted = i==_selectedIndex;

        [self addSubview:viewPreviewTab];
        
        if (i!=selectIndex) {
            // 缩小、固定位置
            CGRect rc = CGRectApplyAffineTransform(rcVisible, tfScale);
            rc.origin.y = (self.height-[self thumbH])/2;
            rc.origin.x = paddingLR+(_previewTabSpace+[self thumbW])*i;
            viewPreviewTab.frame = rc;
            
            viewPreviewTab.labelTitle.alpha = 1;
            viewPreviewTab.labelTitle.hidden = NO;
        }
    }
    
    // 7、将当前标签对应的网页缩略图置顶
    [self bringSubviewToFront:viewPreviewTabSelected];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect rc = CGRectApplyAffineTransform(rcVisible, tfScale);
        rc.origin.y = (self.height-[self thumbH])/2;
        rc.origin.x = paddingLR+(_previewTabSpace+[self thumbW])*selectIndex;
        viewPreviewTabSelected.frame = rc;
        
        for (UIViewPreviewTab *viewPreviewTabItem in _arrPreviewTab) {
            if (viewPreviewTabSelected!=viewPreviewTabItem) {
                viewPreviewTabItem.alpha = 1;
            }
        }
    } completion:^(BOOL finished) {
        viewPreviewTabSelected.labelTitle.alpha = 0;
        viewPreviewTabSelected.labelTitle.hidden = NO;
        
        [UIView animateWithDuration:0.3 animations:^{
            viewPreviewTabSelected.labelTitle.alpha = 1;
        }];
        
        if (completion) {
            completion();
        }
        
        view.userInteractionEnabled = YES;
    }];
}

- (void)dismissWithCompletion:(void(^)(void))completion
{
    self.delegate = nil;
    self.superview.userInteractionEnabled = NO;
    
    [_delegatePreviewTab viewScrollPreviewTabWillSelect:self selectIndex:_selectedIndex];
    
    if ([_delegatePreviewTab respondsToSelector:@selector(viewScrollPreviewTabWillDismiss:)]) {
        [_delegatePreviewTab viewScrollPreviewTabWillDismiss:self];
    }

    // 1、当前 标签 对应的 viewAnim
    UIViewPreviewTab *viewPreviewTabSelected = _arrPreviewTab[_selectedIndex];
    viewPreviewTabSelected.viewPreview.userInteractionEnabled = YES;
    
    // 2、设置相对屏幕的 中心点
    CGPoint centerOfViewWebThumbSelect = viewPreviewTabSelected.viewPreview.center;
    centerOfViewWebThumbSelect = [viewPreviewTabSelected convertPoint:centerOfViewWebThumbSelect toView:self.superview];
    viewPreviewTabSelected.viewPreview.center = centerOfViewWebThumbSelect;
    
    // 3、将 当前 UIViewPreviewTab 转移 到 superview 上
    [self.superview insertSubview:viewPreviewTabSelected.viewPreview aboveSubview:self];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        // 4、还原 viewAnim 大小
        viewPreviewTabSelected.viewPreview.transform = CGAffineTransformIdentity;
        viewPreviewTabSelected.viewPreview.center = CGPointMake(_rcOrigin.origin.x+_rcOrigin.size.width/2, _rcOrigin.origin.y+_rcOrigin.size.height/2);
        
        // 5、缩略图 容器 渐出
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        // 6、还原其他 缩略图 中的子视图（网页/首页）
        for (UIViewPreviewTab *viewPreviewTab in _arrPreviewTab) {
            if (viewPreviewTab!=viewPreviewTabSelected) {
                viewPreviewTab.viewPreview.transform = CGAffineTransformIdentity;
                
                [viewPreviewTab removeFromSuperview];
                [viewPreviewTab.viewPreview removeFromSuperview];
            }
        }
        
        [viewPreviewTabSelected removeFromSuperview];
        
        // 7、将缩略图容器移除
        self.superview.userInteractionEnabled = YES;
        [self removeFromSuperview];
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [_arrPreviewTab removeAllObjects];
        
        // 如果是图片就删掉
        if ([viewPreviewTabSelected.viewPreview isKindOfClass:[UIImageView class]]) {
            [viewPreviewTabSelected.viewPreview removeFromSuperview];
        }
        
        self.contentSize = self.bounds.size;
        self.contentOffset = CGPointZero;
        
        if ([_delegatePreviewTab respondsToSelector:@selector(viewScrollPreviewTabDidSelect:selectIndex:)]) {
            [_delegatePreviewTab viewScrollPreviewTabDidSelect:self selectIndex:_selectedIndex];
        }
        
        _show = NO;
        
        if (completion) completion();
        
    }];
}

/**
 *  滚动到某个缩略图位置，使其居中显示
 *
 *  @param index      缩略图索引
 *  @param animated   是否动画
 *  @param complation 动画结束
 */
- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated completion:(void(^)(void))completion
{
    self.superview.userInteractionEnabled = NO;
    _selectedIndex = index;
    CGFloat paddingLR = floorf((self.width-[self thumbW])/2);
    CGPoint centerOfViewWebPage = CGPointMake(paddingLR+(_previewTabSpace+[self thumbW])*index+[self thumbW]/2, self.bounds.size.height/2);
    CGRect rcVisible = CGRectMake(centerOfViewWebPage.x-self.width/2,
                                  0,
                                  self.bounds.size.width,
                                  self.bounds.size.height);
    
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            [self scrollRectToVisible:rcVisible animated:NO];
        } completion:^(BOOL finished) {
            self.superview.userInteractionEnabled = YES;
            if (completion) completion();
        }];
    }
    else {
        self.superview.userInteractionEnabled = YES;
        [self scrollRectToVisible:rcVisible animated:NO];
    }
}

/**
 *  删除 缩略图
 *
 *  @param index    缩略图索引
 */
- (void)removeThumbAtIndex:(NSInteger)index
{
    NSInteger indexWillRemove = index;
    
    UIViewPreviewTab *viewPreviewTab = _arrPreviewTab[indexWillRemove];
    [viewPreviewTab removeFromSuperview];
    [_arrPreviewTab removeObjectAtIndex:indexWillRemove];
    
    if (indexWillRemove<=_selectedIndex) {
        if (_arrPreviewTab.count>0) {
            _selectedIndex = MIN(_selectedIndex, _arrPreviewTab.count-1);
        }
        else {
            _selectedIndex = -1;
        }
    }
    
    if (_selectedIndex>=0) {
        _labelIndexInfo.text = [NSString stringWithFormat:@"%ld/%lu", (long)_selectedIndex+1, (unsigned long)_arrPreviewTab.count];
    }
    
    // 3、设置 contentSize
    NSInteger pageCount = _arrPreviewTab.count;
    CGFloat paddingLR = floorf((self.width-[self thumbW])/2);
    CGFloat contentW = paddingLR*2+[self thumbW]*pageCount;
    if (pageCount>=1) {
        contentW+=_previewTabSpace*(pageCount-1);
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.contentSize = CGSizeMake(contentW, self.bounds.size.height);
        [_arrPreviewTab enumerateObjectsUsingBlock:^(UIViewPreviewTab *viewPreviewTab, NSUInteger idx, BOOL *stop) {
            if (idx>=indexWillRemove) {
                CGPoint center = viewPreviewTab.center;
                center.x-=_previewTabSpace+[self thumbW];
                viewPreviewTab.center = center;
            }
            
            if (idx==_selectedIndex) {
                viewPreviewTab.labelTitle.highlighted = YES;
            }
        }];
    } completion:^(BOOL finished) {
        
    }];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissWithCompletion:) object:nil];
    if (_arrPreviewTab.count==1) {
        [self performSelector:@selector(dismissWithCompletion:) withObject:nil afterDelay:0.25];
    }
    [_delegatePreviewTab viewScrollPreviewTab:self didRemoveAtIndex:indexWillRemove newIndex:_selectedIndex];
}

- (void)newThumbWithPreviewView:(UIView *)view
{
    self.superview.userInteractionEnabled = NO;
    
    // 2、新建
    UIViewPreviewTab *viewPreviewTab = [UIViewPreviewTab viewPreviewTabWithView:view scale:_previewTabScale];
    viewPreviewTab.delegate = self;
    viewPreviewTab.viewPreview.userInteractionEnabled = NO;
    [_arrPreviewTab addObject:viewPreviewTab];
    
    // 3、设置 contentSize
    NSInteger pageCount = _arrPreviewTab.count;
    CGFloat paddingLR = floorf((self.width-[self thumbW])/2);
    CGFloat contentW = paddingLR*2+[self thumbW]*pageCount;
    if (pageCount>=1) {
        contentW+=_previewTabSpace*(pageCount-1);
    }
    self.contentSize = CGSizeMake(contentW, self.bounds.size.height);
    
    // 2、设置当前标签索引
    _selectedIndex = _arrPreviewTab.count-1;
    viewPreviewTab.labelTitle.text = [_delegatePreviewTab titleForTabViewScrollPreviewTab:self atIndex:_selectedIndex];
    
    // 4、添加到 缩略视图里面去，显示在 初始化显示区域 底部
    // 固定位置
    
    CGPoint centerInit = CGPointMake(paddingLR+(_previewTabSpace+[self thumbW])*_selectedIndex+[self thumbW]/2, self.height+[self thumbH]/2+viewPreviewTab.layer.shadowRadius*2-viewPreviewTab.layer.shadowOffset.height);
    CGAffineTransform tfScale = CGAffineTransformMakeScale(_previewTabScale, _previewTabScale);
    viewPreviewTab.frame = CGRectApplyAffineTransform(_rcOrigin, tfScale);
    viewPreviewTab.center = centerInit;
    
    [self addSubview:viewPreviewTab];
    
    // 5、滚动到可视区域
    [UIView animateWithDuration:0.3 animations:^{
        self.contentOffset = CGPointMake(centerInit.x-self.width/2, 0);
    } completion:^(BOOL finished) {
        CGPoint center = CGPointMake(centerInit.x, self.height/2);
        [UIView animateWithDuration:0.3 animations:^{
            viewPreviewTab.center = center;
        } completion:^(BOOL finished) {
            viewPreviewTab.labelTitle.highlighted = YES;
            viewPreviewTab.labelTitle.alpha = 0;
            viewPreviewTab.labelTitle.hidden = NO;
            
            [UIView animateWithDuration:0.3 animations:^{
                viewPreviewTab.labelTitle.alpha = 1;
            }];
            
            [self dismissWithCompletion:^{
                self.superview.userInteractionEnabled = YES;
            }];
        }];
    }];
}

- (void)updateTitle:(NSString *)title atIndex:(NSInteger)index
{
    UIViewPreviewTab *viewPreviewTab = _arrPreviewTab[index];
    viewPreviewTab.labelTitle.text = title;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self setHighlightTabIndexByThumbOffset];
//    self.superview.userInteractionEnabled = NO;
    
    CGPoint center = _labelIndexInfo.center;
    center.x = MIN(MAX(self.contentOffset.x+self.width/2, self.width/2), self.contentSize.width-self.width/2);
    _labelIndexInfo.center = center;
    _labelIndexInfo.text = [NSString stringWithFormat:@"%ld/%lu", (long)_selectedIndex+1, (unsigned long)_arrPreviewTab.count];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self setHighlightTabIndexByThumbOffset];
    // TODO: 滚动到合适的位置
    [self scrollToIndex:_selectedIndex animated:YES completion:nil];
    
//    self.superview.userInteractionEnabled = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self setHighlightTabIndexByThumbOffset];
        // TODO: 滚动到合适的位置
        [self scrollToIndex:_selectedIndex animated:YES completion:nil];
    }
}

#pragma mark - UIViewPreviewTabDelegate
- (void)viewPreviewTabWillSelect:(UIViewPreviewTab *)viewPreviewTab
{
    NSInteger selectIndex = [_arrPreviewTab indexOfObject:viewPreviewTab];
    if (_selectedIndex==selectIndex) {
        viewPreviewTab.viewPreview.userInteractionEnabled = YES;
        [self dismissWithCompletion:^{
            
        }];
    }
    else {
        _selectedIndex = selectIndex;
        [self scrollToIndex:_selectedIndex animated:YES completion:nil];
    }
}

- (void)viewPreviewTabWillRemove:(UIViewPreviewTab *)viewPreviewTab
{
    [self removeThumbAtIndex:[_arrPreviewTab indexOfObject:viewPreviewTab]];
}

- (void)viewPreviewTabWillBeginDragY:(UIViewPreviewTab *)viewPreviewTab
{
    [UIView animateWithDuration:0.3 animations:^{
        _labelIndexInfo.alpha = 0;
    }];
}

- (void)viewPreviewTabWillEndDragY:(UIViewPreviewTab *)viewPreviewTab
{
    [UIView animateWithDuration:0.3 animations:^{
        _labelIndexInfo.alpha = 1;
    }];
}

@end
