//
//  UIControllerDrawView.h
//  DrawView
//
//  Created by HHY on 14-10-22.
//  Copyright (c) 2014年 koto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewDraw.h"
#import "UIControllerBase.h"
#import "UIControlItem.h"
@interface UIControllerDrawView : UIControllerBase
{
    //画板
    UIViewDraw *_viewDraw;
    IBOutlet UIView *_viewBg;
    
    //底部按钮View
    __weak IBOutlet UIView *_viewBottom;
    
    //下面5各按钮
    IBOutlet UIControlItem *_controlItemback;
    //画笔
    IBOutlet UIControlItem *_controlItemBrush;
    //橡皮
    

    IBOutlet UIControlItem *_controlItemEraser;
    //清除
    
    IBOutlet UIControlItem *_controlItemRedo;
    IBOutlet UIControlItem *_controlItemShare;
    
    
}
//是否保存过
+ (UIControllerDrawView *)UIControllerDrawViewFromXib;
@property(nonatomic,assign)BOOL isSave;
//截图
@property(nonatomic,strong)UIImage *bgImge;
@end
