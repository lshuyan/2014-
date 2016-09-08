//
//  UIControllerBase.m
//  ChinaBrowser
//
//  Created by David on 14-9-1.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIControllerBase.h"

@interface UIControllerBase ()



@end

@implementation UIControllerBase

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self layoutSubViewsWithInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation];
}

+ (instancetype)controllerFromXib
{
    Class aClass = [self class];
    return [[aClass alloc] initWithNibName:NSStringFromClass(aClass) bundle:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (IsiOS7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Applications should use supportedInterfaceOrientations and/or shouldAutorotate..
#pragma mark - autorotate -
// ------------------------------------------------------- rotate -----------------------------------------------------------------
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation NS_DEPRECATED_IOS(2_0, 6_0)
{
    if ([RotateUtil shareRotateUtil].rotateLock) {
        return NO;
    }
    else {
        return UIInterfaceOrientationPortraitUpsideDown!=toInterfaceOrientation;
    }
}

// New Autorotation support.
- (BOOL)shouldAutorotate NS_AVAILABLE_IOS(6_0)
{
    if ([RotateUtil shareRotateUtil].rotateLock) {
        return NO;
    }
    else {
        return YES;
    }
}

- (NSUInteger)supportedInterfaceOrientations NS_AVAILABLE_IOS(6_0)
{
    if ([RotateUtil shareRotateUtil].rotateLock) {
        return [RotateUtil shareRotateUtil].interfaceOrientationMask;
    }
    else {
        return UIInterfaceOrientationMaskLandscape|UIInterfaceOrientationMaskPortrait;
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
    else {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:duration animations:^{
            [self layoutSubViewsWithInterfaceOrientation:toInterfaceOrientation];
        }];
    });
}

//- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
//{
//    [UIView animateWithDuration:duration animations:^{
//        [self layoutSubViewsWithInterfaceOrientation:toInterfaceOrientation];
//    }];
//}

// ------------------------------------------------------- rotate -----------------------------------------------------------------
- (void)layoutSubViewsWithInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    
}

@end
