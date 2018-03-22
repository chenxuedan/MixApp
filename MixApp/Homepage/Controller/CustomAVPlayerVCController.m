//
//  CustomAVPlayerVCController.m
//  MixApp
//
//  Created by 陈雪丹 on 2017/3/2.
//  Copyright © 2017年 cxd. All rights reserved.
//

#define MovieURL @"http://cdnbbbd.shoujiduoduo.com/bb/video/10000048/343684003.mp4"

#import "CustomAVPlayerVCController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface CustomAVPlayerVCController ()

@property (nonatomic, strong)AVPlayer *player;
@property (nonatomic, strong)AVPlayerViewController *playerView;

@end

@implementation CustomAVPlayerVCController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"视频播放";
    [self buildUI];
}

//AVPlayerViewController继承自UIViewController，一般适用于点击一个视频缩略图，modal出一个新的界面来进行播放的
- (void)buildUI {
    //初始化
    self.playerView = [[AVPlayerViewController alloc] init];
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:MovieURL]];
    self.player = [[AVPlayer alloc] initWithPlayerItem:item];
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    layer.frame = CGRectMake(0, 100, kScreenWidth, 200);
    //设置AVPlayer的填充模式
    layer.videoGravity = AVLayerVideoGravityResize;
    [self.view.layer addSublayer:layer];
    //设置AVPlayerViewController内部的AVPlayer为刚创建的AVPlayer
    self.playerView.player = self.player;
    //关闭AVPlayerViewController内部的约束
    self.playerView.view.translatesAutoresizingMaskIntoConstraints = YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self showViewController:self.playerView sender:nil];
}

@end
