//
//  UIControllerImageAssets.h
//  ChinaBrowser
//
//  Created by HHY on 14/12/6.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//  获取相册里的图片


#import "UIControllerImageGroup.h"

@protocol UIControllerImageAssetsDelegate;

@interface UIControllerImageAssets : UIControllerBase
{
    IBOutlet UIScrollView *_scrollView;
    
    UIViewNav *_viewNav;
}

@property(strong, nonatomic)ALAssetsGroup *assetsGroup;

@property(weak, nonatomic)id<UIControllerImageAssetsDelegate> delegate;

@end

@protocol UIControllerImageAssetsDelegate <NSObject>

- (void)controller:(UIControllerImageAssets *)picker didFinishPickingAssets:(ALAsset *)assets;

@end
