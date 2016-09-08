//
//  VPImageCropperViewController.h
//  VPolor
//
//  Created by Vinson.D.Warm on 12/30/13.
//  Copyright (c) 2013 Huang Vinson. All rights reserved.
//

#import "UIControllerBase.h"

@class UIControllerScreenshotIcon;

@protocol UIControllerScreenshotIconDelegate <NSObject>

- (void)controllerScreenshotIcon:(UIControllerScreenshotIcon *)cropperViewController didFinished:(UIImage *)editedImage;

@end

@interface UIControllerScreenshotIcon : UIControllerBase

@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) id<UIControllerScreenshotIconDelegate> delegate;
@property (nonatomic, assign) CGRect cropFrame;

- (id)initWithImage:(UIImage *)originalImage;

@end
