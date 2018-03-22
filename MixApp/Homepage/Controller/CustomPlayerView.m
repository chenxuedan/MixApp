//
//  CustomPlayerView.m
//  MixApp
//
//  Created by 陈雪丹 on 2017/3/6.
//  Copyright © 2017年 cxd. All rights reserved.
//

#import "CustomPlayerView.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "RotationScreen.h"

@interface CustomPlayerView () {
    BOOL _isShowToolbar;//是否显示工具条
    BOOL _isSliding;//是否正在滑动
}

@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIView *playerView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *playBottomBtn;
@property (weak, nonatomic) IBOutlet UILabel *beginTimeLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *loadedProgressView;
@property (weak, nonatomic) IBOutlet UISlider *playProgress;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;
@property (weak, nonatomic) IBOutlet UIButton *rotationBtn;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIView *inspectorView;
@property (weak, nonatomic) IBOutlet UILabel *inspectorLabel;
//约束动画
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *downViewBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inspectorViewHeight;

//管理和调控
@property (nonatomic, strong)AVPlayer *player;
//视频信息
@property (nonatomic, strong)AVPlayerItem *playerItem;
//显示视频
@property (nonatomic, strong)AVPlayerLayer *playerLayer;
//观察者
@property (nonatomic, strong)id playTimeObserver;

@end

@implementation CustomPlayerView
//xib加载时调用
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initData];
    }
    return self;
}

- (void)initData {
    
    self.playProgress.value = 0.0;
    [self.playProgress setThumbImage:[UIImage imageNamed:@"icmpv_thumb_light"] forState:UIControlStateNormal];
    //设置progress
    self.loadedProgressView.progress = 0.0;
    // inspectorBackgroundColor
    self.inspectorView.backgroundColor = [RGB(203, 201, 204) colorWithAlphaComponent:0.5];//不影响子视图的透明度
    [self.playProgress addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];

    self.player = [[AVPlayer alloc] init];
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    [self.playerView.layer addSublayer:_playerLayer];
    
    // bringFront
    [self.playerView bringSubviewToFront:_topView];
    [self.playerView bringSubviewToFront:_bottomView];
    [self.playerView bringSubviewToFront:_playBtn];
    [self.playerView bringSubviewToFront:_playProgress];
    
    //
    [self.playerView sendSubviewToBack:_inspectorView];
    // setPortraintLayout
    [self setProtraitLayout];
    
    NSLog(@"%d %.2f %.2f", __LINE__, self.playerView.bounds.size.width, self.playerView.bounds.size.height);

}

//xib加载完成后 与fileOwner 建立连接调用
- (void)awakeFromNib {
    [super awakeFromNib];
    //slider
    self.playProgress.value = 0.0;
    [self.playProgress setThumbImage:[UIImage imageNamed:@"icmpv_thumb_light"] forState:UIControlStateNormal];
    //设置progress
    self.loadedProgressView.progress = 0.0;
    // inspectorBackgroundColor
    self.inspectorView.backgroundColor = [RGB(203, 201, 204) colorWithAlphaComponent:0.5];//不影响子视图的透明度
    [self.playProgress addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.mainView = [[[NSBundle mainBundle] loadNibNamed:@"CustomPlayerView" owner:self options:nil] lastObject];
        [self addSubview:self.mainView];
        [self initData];
    }
    return self;
}

#pragma mark - 横竖屏约束
- (void)setProtraitLayout {
    _isLandscape = NO;
    //不隐藏工具条
    [self portraitShow];
    //hideInspector
    self.inspectorViewHeight.constant = 0;
    [self layoutIfNeeded];
}
//显示工具条
- (void)portraitShow {
    _isShowToolbar = YES;//显示工具条置为Yes
    
    //约束动画
    self.topViewTop.constant = 0;
    self.downViewBottom.constant = 0;
    [UIView animateWithDuration:0.1 animations:^{
        [self layoutIfNeeded];
        self.topView.alpha = 1;
        self.bottomView.alpha = 1;
        self.playBtn.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}
//隐藏工具条
- (void)portraitHide {
    _isShowToolbar = NO;
    //约束动画
    self.topViewTop.constant = -(self.topView.frame.size.height);
    self.downViewBottom.constant = -(self.bottomView.frame.size.height);
    [UIView animateWithDuration:0.1 animations:^{
        [self layoutIfNeeded];
        self.topView.alpha = 0;
        self.bottomView.alpha = 0;
        self.playBtn.alpha = 0;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark inspectorView动画
- (void)inspectorViewShow {
    [self.inspectorView.layer removeAllAnimations];
    //更改文字
    if (_isPlaying) {
        self.inspectorLabel.text = @"继续播放";
    }else {
        self.inspectorLabel.text = @"暂停播放";
    }
    //约束动画
    self.inspectorViewHeight.constant = 20.0f;
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self performSelector:@selector(inspectorViewHide) withObject:nil afterDelay:1];//0.2秒后隐藏
    }];
}

- (void)inspectorViewHide {
    self.inspectorViewHeight.constant = 0.0f;
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    _playerLayer.frame = self.bounds;
}

#pragma mark - sizeClass 横竖屏约束
//sizeClass 横竖屏切换时，执行
- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    //横竖屏切换时重新添加约束
    CGRect bounds = [UIScreen mainScreen].bounds;
    [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@(0));
        make.width.equalTo(@(bounds.size.width));
        make.height.equalTo(@(bounds.size.height));
    }];
    //横竖屏判断
    if (self.traitCollection.verticalSizeClass != UIUserInterfaceSizeClassCompact) {//竖屏
        self.bottomView.backgroundColor = self.topView.backgroundColor = [UIColor clearColor];
        [self.rotationBtn setImage:[UIImage imageNamed:@"player_fullScreen_iphone"] forState:UIControlStateNormal];
    }else {//横屏
        self.bottomView.backgroundColor = self.topView.backgroundColor = RGB(89, 87, 90);
        [self.rotationBtn setImage:[UIImage imageNamed:@"player_window_iphone"] forState:UIControlStateNormal];
    }
    // iPhone 6s 6                  6sp     6p
    //竖屏情况下 compact * regular   compact * regular
    //横屏情况下 compact * compact   regular * compact
    //以 verticalClass 来判断横竖屏
}

#pragma mark - 横竖屏切换
- (IBAction)rotationAction:(id)sender {
    if ([RotationScreen isOrientationLandscape]) {//如果是横屏
        [RotationScreen forceOrientation:UIInterfaceOrientationPortrait];//切换为竖屏
    }else {
        [RotationScreen forceOrientation:UIInterfaceOrientationLandscapeRight];//否则，切换为横屏
    }
}

- (void)updatePlayerWithURL:(NSURL *)url {
    _playerItem = [AVPlayerItem playerItemWithURL:url];
    [_player replaceCurrentItemWithPlayerItem:_playerItem];
    [self addObserveAndNotification];//添加观察者。发布通知
}

//注册观察者、通知、监听播放进度
- (void)addObserveAndNotification {
    //观察status属性 当status为ReadyToPlay的时候才可以正常使用
    [_playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //观察loadedTimeRanges,缓冲进度条，显示当前视频的缓存进度
    [_playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    [self monitoringPlayback:_playerItem];//监听播放
    [self addNotification];//添加通知
}
//观察播放进度 刷新UI界面
- (void)monitoringPlayback:(AVPlayerItem *)item {
    __weak typeof(self) WeakSelf = self;
    //观察间隔，CMTime为30分之一秒
    _playTimeObserver = [_player addPeriodicTimeObserverForInterval:CMTimeMake(1, 30.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        //当前播放秒
        float currentPlayTime = (double)item.currentTime.value / item.currentTime.timescale;
        // 更新slider, 如果正在滑动则不更新
        if (_isSliding == NO) {
            //刷新UI 更新Slider
            WeakSelf.playProgress.value = currentPlayTime;
            WeakSelf.beginTimeLabel.text = [WeakSelf convertTime:currentPlayTime];
        }
    }];
}
//添加通知
- (void)addNotification {
    //播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinish:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

//播放完成时执行的操作   是否循环播放
- (void)playbackFinish:(NSNotification *)notification {
    _playerItem = [notification object];
    //是否无限循环
    [_playerItem seekToTime:kCMTimeZero];//跳转到初始
    [_player play];//是否无限循环
}
#pragma mark - 观察者方法
//执行观察者方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    AVPlayerItem *item = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        //获取更改后的状态
        AVPlayerStatus status = [[change objectForKey:@"new"] intValue];
        if (status == AVPlayerStatusReadyToPlay) {
            CMTime duration = item.duration;//获取视频长度
            //设置视频时间
            [self setMaxDuration:CMTimeGetSeconds(duration)];
            //播放
            [self play];
        }else if (status == AVPlayerStatusFailed) {
            [SVProgressHUD showErrorWithStatus:@"加载失败"];
            NSLog(@"AVPlayerStatusFailed");
        }else if (status == AVPlayerStatusUnknown) {
            NSLog(@"AVPlayerStatusUnknown");
        }
    }else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSTimeInterval timeInterval = [self availableDurationRanges];//缓冲时间
        CGFloat totalDuration = CMTimeGetSeconds(_playerItem.duration);//总时间
        [self.loadedProgressView setProgress:timeInterval / totalDuration animated:YES];
    }
}
//获取缓冲时间
- (NSTimeInterval)availableDurationRanges {
    //获取item的缓冲数组
    NSArray *loadedTimeRanges = [_playerItem loadedTimeRanges];
    // discussion Returns an NSArray of NSValues containing CMTimeRanges
    // CMTimeRange 结构体 start duration 表示起始位置 和 持续时间
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];//获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;//计算总缓冲时间 = start + duration
    return result;
}
//播放器播放
- (void)play {
    _isPlaying = YES;
    [_player play];//调用AVPlayer的play方法
    [self.playBottomBtn setImage:[UIImage imageNamed:@"Stop"] forState:UIControlStateNormal];
    [self.playBtn setImage:[UIImage imageNamed:@"player_pause_iphone_window"] forState:UIControlStateNormal];
}
//播放器暂停
- (void)pause {
    _isPlaying = NO;
    [_player pause];
    [self.playBottomBtn setImage:[UIImage imageNamed:@"Play"] forState:UIControlStateNormal];
    [self.playBtn setImage:[UIImage imageNamed:@"player_start_iphone_window"] forState:UIControlStateNormal];
}

#pragma mark - 处理点击事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    _touchMode = TouchPlayerViewModeNone;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (_touchMode == TouchPlayerViewModeNone) {
        if (_isLandscape) { // 如果当前是横屏
            if (_isShowToolbar) {
                //                [self landscapeHide];
            } else {
                //                [self landscapeShow];
            }
        } else { // 如果是竖屏
            if (_isShowToolbar) {
                [self portraitHide];
            } else {
                [self portraitShow];
            }
        }
    }
}

//设置最大时间
- (void)setMaxDuration:(CGFloat)duration {
    NSLog(@"视频总时长duration  %f",duration);
    self.playProgress.maximumValue = duration;
    self.endLabel.text = [self convertTime:duration];
}
//时间转换
- (NSString *)convertTime:(CGFloat)second {
    //相对格林时间
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (second / 3600 >= 1) {
        [dateFormatter setDateFormat:@"HH:mm:ss"];
    }else {
        [dateFormatter setDateFormat:@"mm:ss"];
    }
    NSString *showTimeNew = [dateFormatter stringFromDate:date];
    return showTimeNew;
}
//拖动滑块 改变播放进度
- (void)sliderValueChanged:(UISlider *)slider {
    CMTime changedTime = CMTimeMakeWithSeconds(self.playProgress.value, 1.0);
    [_playerItem seekToTime:changedTime completionHandler:^(BOOL finished) {
        
    }];
}
//移除观察者和通知
- (void)dealloc {
    [_player replaceCurrentItemWithPlayerItem:nil];
    [_player removeTimeObserver:_playTimeObserver];
    _playTimeObserver = nil;
    [_playerItem removeObserver:self forKeyPath:@"status"];
    [_playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
