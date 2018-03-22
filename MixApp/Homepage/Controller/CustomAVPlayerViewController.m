//
//  CustomAVPlayerViewController.m
//  MixApp
//
//  Created by 陈雪丹 on 2017/2/28.
//  Copyright © 2017年 cxd. All rights reserved.
//

#import "CustomAVPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>

#define MovieURL @"http://cdnbbbd.shoujiduoduo.com/bb/video/10000048/343684003.mp4"

@interface CustomAVPlayerViewController ()
//管理和调控
@property (nonatomic, strong)AVPlayer *player;
//视频信息
@property (nonatomic, strong)AVPlayerItem *playerItem;
//显示视频
@property (nonatomic, strong)AVPlayerLayer *playerLayer;
//缓冲进度条
@property (nonatomic, strong)UIProgressView *loadedProgress;
//播放进度
@property (nonatomic, strong)UISlider *playProgress;
//视频进度时间显示
@property (nonatomic, strong)UILabel *beginLabel;
//视频总时间显示
@property (nonatomic, strong)UILabel *endLabel;
//播放按钮 暂停按钮
@property (nonatomic, strong)UIButton *playButton;
//观察者
@property (nonatomic, strong)id playTimeObserver;
//
@property (nonatomic, strong)UIView *topView;
@property (nonatomic, strong)UIView *bottomView;


@end

@implementation CustomAVPlayerViewController
/* 有的时候需要自定义播放器的样式
 * AVPlayer存在于AVFoundation中，它更加接近于底层，所以灵活性更强
 *  AVPlayer本身并不能显示视频，而且它不像MPMoviePlayerController有一个view属性。
 *  如果AVPlayer要显示必须创建一个播放器层AVPlayerLayer用于展示，播放器层继承于CALayer，有了AVPlayerLayer之添加到控制器视图的layer中即可。
 *   要使用AVPlayer首先了解一下几个常用的类
 *AVAsset:主要用于获取多媒体信息，是一个抽象类，不能直接使用
 *AVURLAsset:AVAsset的子类,可以根据一个URL路径创建一个包含媒体信息的AVURLAsset对象
 *AVPlayerItem:一个媒体资源管理对象,管理着视频的一些基本信息和状态，一个AVPlayerItem对应一个视频资源;有一个属性为asset,起到观察和管理视频信息的作用，比如，asset，tracks,status,duration,loadedTimeRange等
 *
 */

/*
 *  使用AVPlayer的时候，一定要注意AVPlayer、AVPlayerLayer和AVPlayerItem三者之间的关系。AVPlayer负责控制播放,layer显示播放,item提供数据,当前播放时间，已加载情况。item中一些基本的属性,status、duration、loadedTimeRanges、currentTime(当前播放时间)
 *
 */
/*
 *整个播放视频的步骤
 *1.首先，得到视频的URL
 *2.根据URL创建AVPlayerItem
 *3.把AVPlayerItem提供给AVPlayer
 *4.AVPlayerLayer显示视频
 *5.AVPlayer控制视频,播放,暂停,跳转等等
 *6.播放过程中获取缓冲进度，获取播放进度
 *7.视频播放完成之后做些什么，是暂停还是循环播放，还是获取最后一帧图像
 *
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"视频播放";
    [self buildAVPlayer];
}

- (void)buildAVPlayer {
    AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:MovieURL] options:nil];
    _playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    
    _player = [AVPlayer playerWithPlayerItem:_playerItem];
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    _playerLayer.frame = CGRectMake(0, 0, kScreenWidth,kScreenWidth * (9.0/16.0) );
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.view.layer addSublayer:_playerLayer];
    [self.view addSubview:self.playButton];
    [self.view addSubview:self.beginLabel];
    [self.view addSubview:self.playProgress];
    [self.view addSubview:self.endLabel];
    [self.playProgress addSubview:self.loadedProgress];
    [self addObserveAndNotification];
    [_player play];
}

- (void)addGestures {
    //添加一个手势，隐藏和显示进度条
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shiftStatus)];
    [self.view addGestureRecognizer:tap];
}

- (void)shiftStatus {

}

- (void)updatePlayerWithURL:(NSURL *)url {
    AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:url options:nil];
    _playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    [_player replaceCurrentItemWithPlayerItem:_playerItem];
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

//观察播放进度
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

- (void)play {
    [_player play];
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

- (void)playButtonDidClicked {
    _playButton.selected = !_playButton.selected;
    if (_playButton.selected) {
        [_player pause];
    }else {
        [_player play];
    }
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

#pragma mark - lanjiazai
- (UIButton *)playButton {
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _playButton.frame = CGRectMake(10, kScreenWidth * (9.0/16.0) + 20, 20, 20);
        [_playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [_playButton setImage:[UIImage imageNamed:@"suspend"] forState:UIControlStateSelected];
        [_playButton addTarget:self action:@selector(playButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}

- (UILabel *)beginLabel {
    if (!_beginLabel) {
        _beginLabel = [[UILabel alloc] init];
        _beginLabel.frame = CGRectMake(_playButton.right + 10, kScreenWidth * (9.0/16.0) + 20, 60, 20);
        _beginLabel.font = [UIFont systemFontOfSize:14];
        _beginLabel.textColor = [UIColor grayColor];
    }
    return _beginLabel;
}

- (UISlider *)playProgress {
    if (!_playProgress) {
        _playProgress = [[UISlider alloc] initWithFrame:CGRectMake(_beginLabel.right, kScreenWidth * (9.0/16.0) + 20, 200, 20)];
        //不能改变滑块上的圆圈的大小，但是可以通过设置滑块的图片来增加或减小滑块的大小
        [_playProgress setThumbImage:[UIImage imageNamed:@"icmpv_thumb_light"] forState:UIControlStateNormal];
        _playProgress.minimumTrackTintColor = [UIColor greenSeaColor];
        _playProgress.maximumTrackTintColor = [UIColor clearColor];
        [_playProgress addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _playProgress;
}

- (UILabel *)endLabel {
    if (!_endLabel) {
        _endLabel = [[UILabel alloc] init];
        _endLabel.frame = CGRectMake(_playProgress.right, kScreenWidth * (9.0/16.0) + 20, 60, 20);
        _endLabel.font = [UIFont systemFontOfSize:14];
        _endLabel.textColor = [UIColor grayColor];
    }
    return _endLabel;
}

- (UIProgressView *)loadedProgress {
    if (!_loadedProgress) {
        //它的高度默认是9
        _loadedProgress = [[UIProgressView alloc] initWithFrame:CGRectMake(0,9, 200, 20)];
        //设置它的风格为默认的
        _loadedProgress.trackTintColor = [UIColor colorFromHexCode:@"#cccccc"];
        //设置轨道的颜色
        _loadedProgress.progressTintColor = [UIColor cyanColor];
    }
    return _loadedProgress;
}

@end
