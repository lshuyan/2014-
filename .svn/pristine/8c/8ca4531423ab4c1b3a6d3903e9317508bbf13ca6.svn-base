//
//  UIControllerQRCode.m
//  ChinaBrowser
//
//  Created by David on 14-9-29.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIControllerQRCode.h"

#import "UIViewNav.h"

#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <AVFoundation/AVCaptureInput.h>
#import <AVFoundation/AVCaptureOutput.h>
#import <AVFoundation/AVCaptureSession.h>
#import <AVFoundation/AVCaptureVideoPreviewLayer.h>
#import <AVFoundation/AVMetadataObject.h>

@interface UIControllerQRCode () <AVCaptureMetadataOutputObjectsDelegate>

@end

@implementation UIControllerQRCode
{
    UIViewNav *_viewNav;
    
    IBOutlet UIView *_viewContent;
    IBOutlet UIImageView *_imageViewMask;
    IBOutlet UIImageView *_imageViewLine;
    
    CABasicAnimation *_animLine;
    
    AVCaptureDevice *_captureDevice;
    AVCaptureDeviceInput *_captureDeviceInput;
    AVCaptureMetadataOutput *_captureOutput;
    AVCaptureSession *_captureSession;
    AVCaptureVideoPreviewLayer *_capturePreviewLayer;
}

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
    
    [RotateUtil store];
    [RotateUtil shareRotateUtil].shouldShowRotateLock = NO;
    
    [self startAnimation];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [RotateUtil restore];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopAnimation) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startAnimation) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    _viewNav = [UIViewNav viewNav];
    _viewNav.title = self.title;
    _viewNav.backgroundColor = [_viewNav.backgroundColor colorWithAlphaComponent:0.5];
    
    UIButton *btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnLeft setTitle:LocalizedString(@"quxiao") forState:UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [btnLeft addTarget:self action:@selector(onTouchCancel) forControlEvents:UIControlEventTouchUpInside];
    [btnLeft sizeToFit];
    _viewNav.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    
    if ([[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo] isTorchAvailable]) {
        UIButton *btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnRight setImage:[UIImage imageWithBundleFile:@"iPhone/Home/flash_0.png"] forState:UIControlStateNormal];
        [btnRight setImage:[UIImage imageWithBundleFile:@"iPhone/Home/flash_1.png"] forState:UIControlStateSelected];
        [btnRight addTarget:self action:@selector(onTouchTorchMode:) forControlEvents:UIControlEventTouchUpInside];
        [btnRight sizeToFit];
        
        _viewNav.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
    }
    [self.view addSubview:_viewNav];
    
    _imageViewMask.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    
    // 将扫面区域调整成 storyboard 中看到的图片的位置大小
    
    _imageViewMask.image = [UIImage imageWithBundleFile:@"iPhone/QRCode/qr_frame.png"];
    [_imageViewMask sizeToFit];
    CGRect rc = _imageViewMask.frame;
    rc.origin.x = (_viewContent.width-_imageViewMask.width)*0.5;
    rc.origin.y = (_viewContent.height-_imageViewMask.height)*0.5;
    _imageViewMask.frame = rc;
    
    rc.origin.y = 0;
    rc.size.height = 2;
    rc.size.width -= 4;
    _imageViewLine.frame = rc;
    [_imageViewMask addSubview:_imageViewLine];
    
    [self setupCapture];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)layoutSubViewsWithInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    [_viewNav resizeWithOrientation:orientation];
    
    CGRect rc = _viewContent.frame;
    rc.origin.x = 0;
    rc.origin.y = _viewNav.bottom;
    rc.size.width = self.view.width;
    rc.size.height = self.view.height-rc.origin.y;
    _viewContent.frame = rc;
    _capturePreviewLayer.frame = self.view.bounds;
    
    if ([_capturePreviewLayer.connection isVideoOrientationSupported]) {
        _capturePreviewLayer.connection.videoOrientation = [self videoOrientationFromInterfaceOrientation:orientation];
    }
}


#pragma mark - private methods
- (void)onTouchCancel
{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)onTouchTorchMode:(UIButton *)btn
{
    btn.selected = !((BOOL)_captureDevice.torchMode);
    [_captureDevice lockForConfiguration:nil];
    _captureDevice.torchMode = btn.selected;
    [_captureDevice unlockForConfiguration];
}

- (void)setupCapture
{
    _captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    _captureDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:_captureDevice error:nil];
    _captureOutput = [[AVCaptureMetadataOutput alloc] init];
    _captureSession = [[AVCaptureSession alloc] init];
    _capturePreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_captureSession];
    
    [_captureSession addOutput:_captureOutput];
    
    if (_captureDeviceInput) {
        [_captureSession addInput:_captureDeviceInput];
    }
    
    NSMutableArray *arrType = [NSMutableArray array];
    NSArray *arrAvailableType = [_captureOutput availableMetadataObjectTypes];
    for (NSString *type in arrAvailableType) {
        [arrType addObject:type];
    }
    [_captureOutput setMetadataObjectTypes:arrType];
    [_captureOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    _capturePreviewLayer.frame = self.view.bounds;
    _capturePreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    
    [self.view.layer insertSublayer:_capturePreviewLayer atIndex:0];
    
    if ([_capturePreviewLayer.connection isVideoOrientationSupported]) {
        _capturePreviewLayer.connection.videoOrientation = [self videoOrientationFromInterfaceOrientation:self.interfaceOrientation];
    }
}

- (AVCaptureVideoOrientation)videoOrientationFromInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    switch (interfaceOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
            return AVCaptureVideoOrientationLandscapeLeft;
        case UIInterfaceOrientationLandscapeRight:
            return AVCaptureVideoOrientationLandscapeRight;
        case UIInterfaceOrientationPortrait:
            return AVCaptureVideoOrientationPortrait;
        default:
            return AVCaptureVideoOrientationPortraitUpsideDown;
    }
}

- (void)startScanning;
{
    if (![_captureSession isRunning]) {
        [_captureSession startRunning];
    }
}

- (void)stopScanning;
{
    if ([_captureSession isRunning]) {
        [_captureSession stopRunning];
    }
}

- (void)startAnimation
{
    _animLine = [CABasicAnimation animationWithKeyPath:@"position"];
    _animLine.fromValue = [NSValue valueWithCGPoint:CGPointMake(_imageViewMask.width*_imageViewLine.layer.anchorPoint.x, _imageViewLine.height*_imageViewLine.layer.anchorPoint.y+_imageViewLine.height)];
    _animLine.toValue = [NSValue valueWithCGPoint:CGPointMake(_imageViewMask.width*_imageViewLine.layer.anchorPoint.x, _imageViewMask.height-_imageViewLine.height*_imageViewLine.layer.anchorPoint.y-_imageViewLine.height)];
    _animLine.autoreverses = YES;
    _animLine.repeatCount = MAXFLOAT;
    _animLine.duration = 2;
    _animLine.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [_imageViewLine.layer addAnimation:_animLine forKey:@"position"];
    
    [self startScanning];
}

- (void)stopAnimation
{
    [_imageViewLine.layer removeAllAnimations];
    
    [self stopScanning];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    for(AVMetadataObject *current in metadataObjects) {
        if ([current isKindOfClass:[AVMetadataMachineReadableCodeObject class]]
            && [current.type isEqualToString:AVMetadataObjectTypeQRCode]) {
            NSString *scannedResult = [(AVMetadataMachineReadableCodeObject *) current stringValue];
            
            [_delegateQRCode controller:self didReadContent:scannedResult];
            break;
        }
    }
}

@end
