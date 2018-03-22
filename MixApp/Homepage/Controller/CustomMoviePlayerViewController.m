//
//  CustomMoviePlayerViewController.m
//  MixApp
//
//  Created by 陈雪丹 on 2017/2/27.
//  Copyright © 2017年 cxd. All rights reserved.
//

#import "CustomMoviePlayerViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

#define MovieURL @"http://cdnbbbd.shoujiduoduo.com/bb/video/10000048/343684003.mp4"

#define MoviePlayerURL @"https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"

@interface CustomMoviePlayerViewController ()

@property (nonatomic, strong)MPMoviePlayerController *playerController;

@end

@implementation CustomMoviePlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self thumbnailImageRequest:10.0];
    [self buildOnlineVideo];
}

//网络视频
- (void)buildOnlineVideo {
    _playerController = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:MovieURL]];
    _playerController.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth * (9.0/16.0));
    [self.view addSubview:_playerController.view];
    _playerController.controlStyle = MPMovieControlStyleEmbedded;
    _playerController.shouldAutoplay = YES;
    _playerController.repeatMode = MPMovieRepeatModeOne;//重复播放
    [_playerController setFullscreen:YES];
    [_playerController prepareToPlay];//缓存  准备播放,加载视频数据到缓存，当调用play方法时如果没有准备好会自动调用此方法
    [_playerController play];
}
//直播
- (void)buildLiveStreaming {
    _playerController = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:@"http://live.hkstv.hk.lxdns.com/live/hks/playlist.m3u8"]];
    [self.view addSubview:_playerController.view];
    _playerController.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth * (9.0/16.0));
    _playerController.movieSourceType = MPMovieSourceTypeStreaming;//直播
    [_playerController prepareToPlay];
}
/**
 *  截取指定时间的视频缩略图
 *
 *  @param timeBySecond 时间点
 */
//如果仅仅是为了生成缩略图而不精性视频播放的话，使用AVFoundation框架中的AVAssetImageGenerator获取视频缩略图
- (void)thumbnailImageRequest:(CGFloat)timeBySecond {
    //创建URL
    NSURL *url = [NSURL URLWithString:MovieURL];
    //根据url创建AVURLAsset
    AVURLAsset *urlAsset = [AVURLAsset assetWithURL:url];
    //根据AVURLAsset创建AVAssetImageGenerator
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    /*截图
     * requestTime:缩略图创建时间
     * actualTime:缩略图实际生成的时间
     */
    NSError *error = nil;
    CMTime time = CMTimeMakeWithSeconds(timeBySecond, 10);//CMTime是表示电影时间信息的结构体，第一个参数表示是视频第几秒，第二个参数表示每秒帧数，(如果要活的某一秒的第几帧可以使用CMTimeMake方法)
    CMTime actualTime;
    CGImageRef cgImage = [imageGenerator copyCGImageAtTime:time actualTime:&actualTime error:&error];
    if (error) {
        NSLog(@"截取视频缩略图时发生错误,错误信息:%@",error.localizedDescription);
        return;
    }
    CMTimeShow(actualTime);
    UIImage *image = [UIImage imageWithCGImage:cgImage];//转化为UIImage
    //保存到相册
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    CGImageRelease(cgImage);
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kScreenWidth * (9.0 / 16.0), kScreenWidth, 200)];
    [imageView setImage:image];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
}


@end
