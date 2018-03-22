//
//  CXDPlayerView.m
//  MixApp
//
//  Created by 陈雪丹 on 2017/3/3.
//  Copyright © 2017年 cxd. All rights reserved.
//

#import "CXDPlayerView.h"
#import <AVFoundation/AVFoundation.h>
#import "RotationScreen.h"

@interface CXDPlayerView () {
    BOOL _isShowToolbar; // 是否显示工具条
}

//管理和调控
@property (nonatomic, strong)AVPlayer *player;
//视频信息
@property (nonatomic, strong)AVPlayerItem *playerItem;
//显示视频
@property (nonatomic, strong)AVPlayerLayer *playerLayer;


//观察者
@property (nonatomic, strong)id playTimeObserver;
//顶部视图
@property (nonatomic, strong)UIView *topView;
//返回按钮
@property (nonatomic, strong)UIButton *backBtn;
//更多按钮
@property (nonatomic, strong)UIButton *moreBtn;

//底部视图  控制视频播放暂停等
@property (nonatomic, strong)UIView *bottomView;
//播放和暂停按钮
@property (nonatomic, strong)UIButton *playButton;
//视频进度时间显示  播放了多长时间
@property (nonatomic, strong)UILabel *beginLabel;
//视频总时间显示
@property (nonatomic, strong)UILabel *endLabel;
//缓冲进度条
@property (nonatomic, strong)UIProgressView *loadedProgress;
//播放进度
@property (nonatomic, strong)UISlider *playProgress;
//屏幕旋转按钮
@property (nonatomic, strong)UIButton *rotationBtn;
//大视图  电视播放和暂停
@property (nonatomic, strong)UIButton *bigPlayerBtn;
//活动指示器
@property (nonatomic, strong)UIActivityIndicatorView *activityView;

@end

@implementation CXDPlayerView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorFromHexCode:@"#000000"];
        [self buildAVPlayer];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    }
    return self;
}

- (void)buildAVPlayer {
    _player = [AVPlayer playerWithPlayerItem:_playerItem];
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    _playerLayer.frame = self.bounds;
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.layer addSublayer:_playerLayer];
    [self buildUI];
    [self portraitShow];
}

- (void)updatePlayerWithURL:(NSURL *)url {
    AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:url options:nil];
    _playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    [_player replaceCurrentItemWithPlayerItem:_playerItem];
    [self addObserveAndNotification];
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
            //刷新UI 更新Slider
        WeakSelf.playProgress.value = currentPlayTime;
        WeakSelf.beginLabel.text = [WeakSelf convertTime:currentPlayTime];
    }];
}

- (void)addNotification {
    //播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinish:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}
//播放完成之后的处理
- (void)playbackFinish:(NSNotification *)notification {
    _playerItem = [notification object];
    //是否无限循环
    [_playerItem seekToTime:kCMTimeZero];//跳转到初始
    [_player play];//是否无限循环
}

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
            [self.activityView stopAnimating];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

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
        [self.loadedProgress setProgress:timeInterval / totalDuration animated:YES];
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
    [self.playButton setImage:[UIImage imageNamed:@"Stop"] forState:UIControlStateNormal];
    [self.bigPlayerBtn setImage:[UIImage imageNamed:@"player_pause_iphone_window"] forState:UIControlStateNormal];
}
//播放器暂停
- (void)pause {
    _isPlaying = NO;
    [_player pause];
    [self.playButton setImage:[UIImage imageNamed:@"Play"] forState:UIControlStateNormal];
    [self.bigPlayerBtn setImage:[UIImage imageNamed:@"player_start_iphone_window"] forState:UIControlStateNormal];
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
//播放暂停按钮的点击事件
- (void)playButtonDidClicked {
    if (_isPlaying) {
        [self pause];
    }else {
        [self play];
    }
}

//移除观察者和通知
- (void)dealloc {
    [_player replaceCurrentItemWithPlayerItem:nil];
    [_playerItem removeObserver:self forKeyPath:@"status"];
    [_playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    _playTimeObserver = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_player removeTimeObserver:_playTimeObserver];
}

- (void)buildUI {
    [self addSubview:self.topView];
    [self.topView addSubview:self.backBtn];
    [self addSubview:self.bottomView];
    [self.bottomView addSubview:self.playButton];
    [self.bottomView addSubview:self.beginLabel];
    [self.bottomView addSubview:self.loadedProgress];
    [self.bottomView addSubview:self.playProgress];
    [self.bottomView addSubview:self.endLabel];
    [self.bottomView addSubview:self.rotationBtn];
    [self addSubview:self.bigPlayerBtn];
    [self addSubview:self.activityView];
    [self.activityView startAnimating];
    [self setSubviewContants];
}
//触摸事件
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (_isShowToolbar) {
        [self portraitHide];
    }else {
        [self portraitShow];
    }
}
//隐藏工具条
- (void)portraitHide {
    _isShowToolbar = NO;
    __weak typeof(self) WeakSelf = self;
    [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(WeakSelf.mas_top).offset(-40);
    }];
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(WeakSelf.mas_bottom).offset(0);
    }];

    [UIView animateWithDuration:0.1 animations:^{
        self.topView.alpha = 0;
        self.bottomView.alpha = 0;
        self.bigPlayerBtn.alpha = 0;

//        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
    
    if ([RotationScreen isOrientationLandscape]) { // 如果是横屏，
        //显示状态条
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
}
//显示工具条
- (void)portraitShow {
    _isShowToolbar = YES;
    __weak typeof(self) WeakSelf = self;
    [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(WeakSelf.mas_top);
    }];
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(WeakSelf.mas_bottom);
    }];

    [UIView animateWithDuration:0.1 animations:^{
        self.topView.alpha = 1;
        self.bottomView.alpha = 1;
        self.bigPlayerBtn.alpha = 1;
//        [self layoutIfNeeded];

    } completion:^(BOOL finished) {

    }];
    
    if ([RotationScreen isOrientationLandscape]) { // 如果是横屏，
        //隐藏状态条
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }

}

- (void)videoBackBtnClick {
    if ([RotationScreen isOrientationLandscape]) { // 如果是横屏，
        [RotationScreen forceOrientation:(UIInterfaceOrientationPortrait)]; // 切换为竖屏
    }
}

//旋转按钮
- (void)rotationBtnDidClick {
    if ([RotationScreen isOrientationLandscape]) { // 如果是横屏，
        [RotationScreen forceOrientation:(UIInterfaceOrientationPortrait)]; // 切换为竖屏
    } else {
        [RotationScreen forceOrientation:(UIInterfaceOrientationLandscapeRight)]; // 否则，切换为横屏
    }
}

#pragma mark - sizeClass 横竖屏约束
// sizeClass 横竖屏切换时，执行
- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    //横竖屏切换时添加约束
    CGRect bounds = [UIScreen mainScreen].bounds;
    //横竖屏判断
    if (self.traitCollection.verticalSizeClass != UIUserInterfaceSizeClassCompact) {//竖屏
        self.viewController.navigationController.navigationBar.hidden = NO;
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(@(0));
            make.width.equalTo(@(bounds.size.width));
            make.height.equalTo(@(kScreenWidth * (14.0/25.0)));
        }];
        [self.loadedProgress mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(@(150));
        }];
        [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(40);
        }];
        
        _playerLayer.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth * (14.0/25.0));
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

    }else {//横屏
        self.viewController.navigationController.navigationBar.hidden = YES;
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(@(0));
            make.width.equalTo(@(bounds.size.width));
            make.height.equalTo(@(bounds.size.height));
        }];
        [self.loadedProgress mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(@(240));
        }];
        [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(60);
        }];

        _playerLayer.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
}

#pragma mark - 左上下滑动更改屏幕亮度



#pragma mark - 右上下滑动更改声音大小

//布局子视图 添加约束
- (void)setSubviewContants {
    __weak typeof(self) WeakSelf = self;
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(WeakSelf.mas_top);
        make.left.mas_equalTo(WeakSelf.mas_left);
        make.right.mas_equalTo(WeakSelf.mas_right);
        make.height.mas_equalTo(40);
    }];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(WeakSelf.topView.mas_left).offset(10);
        make.bottom.mas_equalTo(WeakSelf.topView.mas_bottom).offset(-8);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(WeakSelf.mas_bottom);
        make.left.mas_equalTo(WeakSelf.mas_left);
        make.right.mas_equalTo(WeakSelf.mas_right);
        make.height.mas_equalTo(36);
    }];
    
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(WeakSelf.bottomView.mas_left).mas_equalTo(10);
        make.centerY.mas_equalTo(WeakSelf.bottomView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(13, 15));
    }];
    
    [self.beginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(WeakSelf.playButton.mas_right).offset(10);
        make.centerY.mas_equalTo(WeakSelf.bottomView.mas_centerY);
        make.width.mas_greaterThanOrEqualTo(40);
    }];
    
    [self.loadedProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(WeakSelf.beginLabel.mas_right).offset(10);
        make.centerY.mas_equalTo(WeakSelf.bottomView.mas_centerY);
        make.width.mas_equalTo(150);
    }];
    
    [self.playProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(WeakSelf.loadedProgress.mas_left);
        make.right.mas_equalTo(WeakSelf.loadedProgress.mas_right);
        make.centerY.mas_equalTo(WeakSelf.loadedProgress.mas_centerY);
    }];
    
    [self.endLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(WeakSelf.loadedProgress.mas_right).offset(10);
        make.centerY.mas_equalTo(WeakSelf.bottomView.mas_centerY);
    }];
    
    [self.rotationBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(WeakSelf.bottomView.mas_right).offset(-10);
        make.centerY.mas_equalTo(WeakSelf.bottomView.mas_centerY);
    }];
    
    [self.bigPlayerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(WeakSelf.bottomView.mas_top).offset(-10);
        make.right.mas_equalTo(WeakSelf.mas_right).offset(-15);
    }];
    
    [self.activityView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(WeakSelf.mas_centerX);
        make.centerY.mas_equalTo(WeakSelf.mas_centerY);
    }];

}

#pragma mark - 懒加载
//头部视图  承载返回按钮
- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
//        _topView.backgroundColor = [UIColor clearColor];
        _topView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    }
    return _topView;
}
//返回按钮
- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(videoBackBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}
//底部视图  承载播放暂停按钮 进度条等
- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    }
    return _bottomView;
}
//播放暂停按钮
- (UIButton *)playButton {
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setImage:[UIImage imageNamed:@"Play"] forState:UIControlStateNormal];
        [_playButton setImage:[UIImage imageNamed:@"Stop"] forState:UIControlStateSelected];
        [_playButton addTarget:self action:@selector(playButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}
//视频当前播放进度
- (UILabel *)beginLabel {
    if (!_beginLabel) {
        _beginLabel = [[UILabel alloc] init];
        _beginLabel.font = [UIFont systemFontOfSize:14];
        _beginLabel.textColor = [UIColor whiteColor];
        _beginLabel.text = @"00:00";
    }
    return _beginLabel;
}
//播放控制条
- (UISlider *)playProgress {
    if (!_playProgress) {
        _playProgress = [[UISlider alloc] init];
        //不能改变滑块上的圆圈的大小，但是可以通过设置滑块的图片来增加或减小滑块的大小
        [_playProgress setThumbImage:[UIImage imageNamed:@"icmpv_thumb_light"] forState:UIControlStateNormal];
        _playProgress.minimumTrackTintColor = [UIColor clearColor];
        _playProgress.maximumTrackTintColor = [UIColor clearColor];
        [_playProgress addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _playProgress;
}
//视频总时长
- (UILabel *)endLabel {
    if (!_endLabel) {
        _endLabel = [[UILabel alloc] init];
        _endLabel.font = [UIFont systemFontOfSize:14];
        _endLabel.textColor = [UIColor whiteColor];
        _endLabel.text = @"00:00";
        [_endLabel sizeToFit];
    }
    return _endLabel;
}
//缓冲进度条
- (UIProgressView *)loadedProgress {
    if (!_loadedProgress) {
        //它的高度默认是9
        _loadedProgress = [[UIProgressView alloc] init];
        //设置它的风格为默认的
//        _loadedProgress.trackTintColor = [UIColor colorFromHexCode:@"#cccccc"];
        //设置轨道的颜色
        _loadedProgress.progressTintColor = [UIColor colorFromHexCode:@"ff8fbb"];
    }
    return _loadedProgress;
}
//大的电视播放按钮
- (UIButton *)bigPlayerBtn {
    if (!_bigPlayerBtn) {
        _bigPlayerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bigPlayerBtn setImage:[UIImage imageNamed:@"player_start_iphone_window.png"] forState:UIControlStateNormal];
        [_bigPlayerBtn addTarget:self action:@selector(playButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bigPlayerBtn;
}
//活动指示器
- (UIActivityIndicatorView *)activityView {
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] init];
        _activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        //如果希望指示器停止后自动隐藏，要设置hidesWhenStopped属性为YES.默认为YES,设置为NO，停止后指示器仍会显示
        _activityView.hidesWhenStopped = YES;
    }
    return _activityView;
}

- (UIButton *)rotationBtn {
    if (!_rotationBtn) {
        _rotationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rotationBtn setImage:[UIImage imageNamed:@"Rotation"] forState:UIControlStateNormal];
        [_rotationBtn addTarget:self action:@selector(rotationBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rotationBtn;
}

@end
