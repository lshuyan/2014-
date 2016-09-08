//
//  UIViewFMPlayer.m
//  ChinaBrowser
//
//  Created by David on 14/11/19.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIViewFMPlayer.h"

#import "ModelModeProgram.h"
#import "ModelProgram.h"

#import "ModelPlayItem.h"

#import "ADOModeProgram.h"

#import "BlockUI.h"

#import "CBAudioPlayer.h"

@interface UIViewFMPlayer ()
{
    IBOutlet UIImageView *_imageViewBgPlayer;
    IBOutlet UIView *_viewContentPlayer;
    IBOutlet UIImageView *_imageViewWave;
    IBOutlet UIButton *_btnAdd;
    
    UIImageView *_bgFM;
    IBOutlet UILabel *_labelFM;
    IBOutlet UILabel *_labelTitle;
    IBOutlet UILabel *_labelNextTitle;
    IBOutlet UILabel *_labelTime;
    IBOutlet UIButton *_btnPlayPause;
    
    // 当前模式 节目列表 计时器
    NSTimer *_timerPList;
    // 选择 播放的 模式id
    NSInteger _modePkid;
    ModelPlayItem *_playItemNext;
    NSArray *_arrModeProgram;
    NSLock *_lockPList;
    
    NSTimer *_timerWave;
    NSArray *_arrWaveImage;
    NSInteger _iWaveIndex;
}

@end

@implementation UIViewFMPlayer

#pragma mark - instance
+ (instancetype)viewFromXib
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}

- (void)dealloc
{
    [[CBAudioPlayer player] removeObserver:self forKeyPath:@"playbackState"];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [CBAudioPlayer player].playerDelegate = self;;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerPlaybackStateDidChangeNotification:)
                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification
                                               object:nil];
    
    _playItemNext = nil;
    
    NSMutableArray *arrImage = [NSMutableArray arrayWithCapacity:24];;
    for (NSInteger i=1; i<=24; i++) {
        [arrImage addObject:[UIImage imageWithBundleFile:[NSString stringWithFormat:@"iPhone/FM/wave_%ld.png", (long)i]]];
    }
    _arrWaveImage = arrImage;
    _imageViewWave.image = _arrWaveImage[0];
    
    _imageViewBgPlayer.image = [UIImage imageWithBundleFile:@"iPhone/FM/bg_player.png"];
    
    [_btnAdd setImage:[UIImage imageWithBundleFile:@"iPhone/FM/add_0.png"] forState:UIControlStateNormal];
    [_btnAdd setImage:[UIImage imageWithBundleFile:@"iPhone/FM/add_1.png"] forState:UIControlStateHighlighted];
    
    [_btnPlayPause setImage:[UIImage imageWithBundleFile:@"iPhone/FM/play_0.png"] forState:UIControlStateNormal];
    [_btnPlayPause setImage:[UIImage imageWithBundleFile:@"iPhone/FM/play_1.png"] forState:UIControlStateHighlighted];
    
    _labelFM.textColor = [UIColor grayColor];
    _bgFM = [[UIImageView alloc] initWithImage:[[UIImage imageWithBundleFile:@"iPhone/FM/bg_fm_0.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:10]];
    [_viewContentPlayer insertSubview:_bgFM belowSubview:_labelFM];
    
    CAShapeLayer *mask = [CAShapeLayer layer];
    mask.frame = _viewContentPlayer.bounds;
    mask.path = [UIBezierPath bezierPathWithRoundedRect:_viewContentPlayer.bounds cornerRadius:MIN(_viewContentPlayer.width, _viewContentPlayer.height)/2].CGPath;
    _viewContentPlayer.layer.mask = mask;
    
    // 开启计时器
    _lockPList = [[NSLock alloc] init];
    _timerPList = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(checkPlayList) userInfo:nil repeats:YES];;
    [[NSRunLoop currentRunLoop] addTimer:_timerPList forMode:NSRunLoopCommonModes];
    
    [self updatePlayState];
}

- (void)playerPlaybackStateDidChangeNotification:(NSNotification *)notification
{
    _DEBUG_LOG(@"%s===state:%ld", __FUNCTION__, (long)[CBAudioPlayer player].playbackState);
    
    [self updatePlayState];
}

// ------------------- 波形图 begin
/**
 *  开始波形图动画
 */
- (void)startWaveAnimation
{
    if (_timerWave.isValid) {
        return;
    }
    _timerWave = [NSTimer scheduledTimerWithTimeInterval:0.08 target:self selector:@selector(waveAnimating) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timerWave forMode:NSRunLoopCommonModes];
}

/**
 *  停止波形图动画
 */
- (void)stopWaveAnimation
{
    [_timerWave invalidate];
    _timerWave = nil;
}

- (void)waveAnimating
{
    _iWaveIndex++;
    if (_iWaveIndex>=_arrWaveImage.count) {
        _iWaveIndex = 0;
    }
    _imageViewWave.image = _arrWaveImage[_iWaveIndex];
}
// ----------------- 波形图 end

#pragma mark - private methods
/**
 *  添加 模式 事件
 */
- (IBAction)onTouchAdd
{
    if (_callbackWillAdd) {
        _callbackWillAdd();
    }
}

/**
 *  播放 或 暂停
 */
- (IBAction)onTouchPlayOrPause
{
    if ([CBAudioPlayer isPlaying]) {
        [CBAudioPlayer pause];
    }
    else {
        [CBAudioPlayer play];
    }
    
    if ([CBAudioPlayer isPlaying]) {
        [_btnPlayPause setImage:[UIImage imageWithBundleFile:@"iPhone/FM/stop_0.png"] forState:UIControlStateNormal];
        [_btnPlayPause setImage:[UIImage imageWithBundleFile:@"iPhone/FM/stop_1.png"] forState:UIControlStateHighlighted];
    }
    else {
        [_btnPlayPause setImage:[UIImage imageWithBundleFile:@"iPhone/FM/play_0.png"] forState:UIControlStateNormal];
        [_btnPlayPause setImage:[UIImage imageWithBundleFile:@"iPhone/FM/play_1.png"] forState:UIControlStateHighlighted];
    }
}

/**
 *  检查播放列表，并更新时间
 */
- (void)checkPlayList
{
    NSDateComponents *dateComp = [[NSCalendar currentCalendar] components:NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:[NSDate date]];
    NSInteger timestmp = dateComp.hour*3600+dateComp.minute*60+dateComp.second;
    
    _labelTime.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)dateComp.hour, (long)dateComp.minute, (long)dateComp.second];
    
    if (0==timestmp && _modePkid>0) {
        // 新的一天开始了，该更新播放列表了
        [self setModePkid:_modePkid];
    }
}

/**
 *  查找某个时间点的 节目
 *
 *  @param time 一天内的时间戳 < 24*60*60
 *
 *  @return ModelModeProgram 节目
 */
- (ModelModeProgram *)findPlayItemAtTime:(NSInteger)time
{
    ModelModeProgram *modelAlertTmp = nil;
    if (_arrModeProgram.count>0) {
        [_lockPList lock];
        for (ModelModeProgram *modeProgram in _arrModeProgram) {
            if (time==modeProgram.time) {
                modelAlertTmp = modeProgram;
                break;
            }
        }
        [_lockPList unlock];
    }
    return modelAlertTmp;
}

/**
 *  根据当天内的时间戳查找 指定时间段 应该播放的节目
 *
 *
 *  @return ModelModeProgram 应该播放的节目
 */
- (ModelPlayItem *)findPlayItemDurationNow
{
    NSDateComponents *dateComp = [[NSCalendar currentCalendar] components:NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:[NSDate date]];
    NSInteger time = dateComp.hour*3600+dateComp.minute*60+dateComp.second;
    
    ModelPlayItem *playItem = nil;
    if (_arrModeProgram.count>0) {
        [_lockPList lock];
        ModelModeProgram *modeProgramNextTmp = nil;
        NSInteger count = _arrModeProgram.count;
        for (NSInteger i=0; i<count; i++) {
            ModelModeProgram *modeProgram = _arrModeProgram[i];
            if (ProgramSrcTypeFM!=modeProgram.modelProgram.srcType) {
                continue;
            }
            
            ModelModeProgram *modeProgramNext = ((i+1)<count)?_arrModeProgram[i+1]:nil;
            if (modeProgramNext.modelProgram.srcType!=ProgramSrcTypeFM) {
                modeProgramNext = nil;
            }
            
            if (modeProgramNext) {
                if (time>=modeProgram.time
                    && time<modeProgramNext.time) {
                    modeProgramNextTmp = modeProgram;
                    break;
                }
            }
            else if (time>=modeProgram.time) {
                modeProgramNextTmp = modeProgram;
            }
        }
        if (modeProgramNextTmp) {
            playItem = [ModelPlayItem modelWithTitle:modeProgramNextTmp.modelProgram.title
                                                link:modeProgramNextTmp.modelProgram.link
                                                  fm:modeProgramNextTmp.modelProgram.fm
                                                icon:nil];
        }
        [_lockPList unlock];
    }
    return playItem;
}

#pragma mark - public methods
/**
 *  设置模式，更新播放列表，如果设置的
 *
 *  @param modePkid                 modePkid description
 *  @param shouldUpdateNotification shouldUpdateNotification description
 */
- (void)setModePkid:(NSInteger)modePkid
{
    BOOL shouldReset = _modePkid!=modePkid;
    
    _modePkid = modePkid;
    [self updatePList];
    
    // 查找这个时候应该正在播放的 节目
    ModelPlayItem *playItemDurationNow = [self findPlayItemDurationNow];
    
    if (shouldReset) {
        // 切换了模式，需要清除当前正在播放的 资源
        _playItemNext = nil;
        [CBAudioPlayer reset];
        
        [[CBAudioPlayer player] setPlayItem:playItemDurationNow];
    }
    else {
        if (![CBAudioPlayer isPlaying]) {
            [[CBAudioPlayer player] setPlayItem:playItemDurationNow];
        }
    }
    [self updatePlayState];
    
    // 查找下一个节目
    [self showNextPlayItemAfterNow];
}

/**
 *  即将更新节目列表
 *
 *  @param modePkid
 */
- (void)updatePListIfNeedWithModePkid:(NSInteger)modePkid
{
    if (modePkid==_modePkid) {
        // 需要更新 通知
        [self setModePkid:modePkid];
    }
}

/**
 *  根据时间查找 下一个节目（节目预告）
 *
 */
- (void)showNextPlayItemAfterNow
{
    NSDateComponents *dateComp = [[NSCalendar currentCalendar] components:NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:[NSDate date]];
    NSInteger time = dateComp.hour*3600+dateComp.minute*60+dateComp.second;
    
    [_lockPList lock];
    ModelPlayItem *playItemNext = nil;
    
    for (ModelModeProgram *modeProgram in _arrModeProgram) {
        if (ProgramSrcTypeFM==modeProgram.modelProgram.srcType
            && modeProgram.time>time) {
            playItemNext = [ModelPlayItem modelWithTitle:modeProgram.modelProgram.title
                                                    link:modeProgram.modelProgram.link
                                                      fm:modeProgram.modelProgram.fm
                                                    icon:nil];
            break;
        }
    }
    
    if (playItemNext) {
        if (![_labelNextTitle.text isEqualToString:playItemNext.title]) {
            _labelNextTitle.text = [NSString stringWithFormat:@"%@: %@", LocalizedString(@"xiayijiemuyugao"), playItemNext.title];
        }
    }
    else {
        _labelNextTitle.text = [NSString stringWithFormat:@"%@: %@", LocalizedString(@"xiayijiemuyugao"), LocalizedString(@"zanwujiemu")];
    }
    _playItemNext = playItemNext;
    
    [_lockPList unlock];
    
}

/**
 *  更新播放状态: 标题、FM、播放按钮、声波图
 */
- (void)updatePlayState
{
    ModelPlayItem *playItem = [CBAudioPlayer player].playItem;
    
    if (playItem) {
        if (playItem.fm.length>0) {
            _bgFM.hidden = NO;
            _labelFM.hidden = NO;
            
            _labelFM.text = playItem.fm;
        }
        else {
            _bgFM.hidden =
            _labelFM.hidden = YES;
        }
        
        _labelTitle.text = playItem.title;
        if (_playItemNext) {
            _labelNextTitle.text = [NSString stringWithFormat:@"%@: %@", LocalizedString(@"xiayijiemuyugao"), _playItemNext.title];
        }
        else {
            _labelNextTitle.text = [NSString stringWithFormat:@"%@: %@", LocalizedString(@"xiayijiemuyugao"), LocalizedString(@"zanwujiemu")];
        }
        
        // 如果显示 FM 频道 信息，则需要重新调整布局
        if (!_bgFM.hidden) {
            CGFloat fY = _labelFM.top;
            CGFloat fH = _labelFM.height;
            [_labelFM sizeToFit];
            CGRect rc = _labelFM.frame;
            rc.size.height = fH;
            rc.size.width = MIN(_labelFM.width, 100);
            rc.origin.y = fY;
            rc.origin.x = (_viewContentPlayer.width-rc.size.width)*0.5;
            _labelFM.frame = rc;
            _bgFM.frame = CGRectOffset(CGRectIntegral(CGRectInset(_labelFM.frame, -5, (_labelFM.height-_bgFM.height)*0.5)), 0, 1);
        }
    }
    else {
        _labelTitle.text = LocalizedString(@"zanwujiemu");
        _labelNextTitle.text = [NSString stringWithFormat:@"%@: %@", LocalizedString(@"xiayijiemuyugao"), LocalizedString(@"zanwujiemu")];
        
        _bgFM.hidden =
        _labelFM.hidden = YES;
    }
    
    if ([CBAudioPlayer isPlaying]) {
        [_btnPlayPause setImage:[UIImage imageWithBundleFile:@"iPhone/FM/stop_0.png"] forState:UIControlStateNormal];
        [_btnPlayPause setImage:[UIImage imageWithBundleFile:@"iPhone/FM/stop_1.png"] forState:UIControlStateHighlighted];
        
        [self startWaveAnimation];
    }
    else {
        [_btnPlayPause setImage:[UIImage imageWithBundleFile:@"iPhone/FM/play_0.png"] forState:UIControlStateNormal];
        [_btnPlayPause setImage:[UIImage imageWithBundleFile:@"iPhone/FM/play_1.png"] forState:UIControlStateHighlighted];
        
        [self stopWaveAnimation];
    }
}

/**
 *  更新播放列表
 */
- (void)updatePList
{
    [_lockPList lock];
    _arrModeProgram = nil;
    NSArray *arrRepeat = @[@(RemindRepeatMode0),
                           @(RemindRepeatMode1),
                           @(RemindRepeatMode2),
                           @(RemindRepeatMode3),
                           @(RemindRepeatMode4),
                           @(RemindRepeatMode5),
                           @(RemindRepeatMode6)];
    NSDateComponents *comp = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    _arrModeProgram = [ADOModeProgram queryWithModePkid:_modePkid on:YES repeat:[arrRepeat[comp.weekday-1] integerValue]];
    [_lockPList unlock];
}

#pragma mark - AppLanguageProtocol
- (void)updateByLanguage
{
    _arrModeProgram = nil;
    _modePkid = 0;
    _playItemNext = nil;
    [CBAudioPlayer reset];
    [self updatePlayState];
}

@end
