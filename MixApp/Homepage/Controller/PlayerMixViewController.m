//
//  PlayerMixViewController.m
//  MixApp
//
//  Created by 陈雪丹 on 2017/3/8.
//  Copyright © 2017年 cxd. All rights reserved.
//

#import "PlayerMixViewController.h"
#import "CustomPlayerView.h"
#import "CXDPlayerView.h"

@interface PlayerMixViewController ()

@property (nonatomic, strong)CXDPlayerView *myPlayerView;

@property (nonatomic, strong)CustomPlayerView *playerView;

@end

@implementation PlayerMixViewController
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    self.navigationController.navigationBarHidden = NO;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"儿歌多多";
//    [self buildUI];
    
    [self.view addSubview:self.myPlayerView];
    [self.myPlayerView updatePlayerWithURL:[NSURL URLWithString:@"http://cdnbbbd.shoujiduoduo.com/bb/video/10000048/343684003.mp4"]];
//    [self.myPlayerView play];
}

- (void)buildUI {
    [self.view addSubview:self.playerView];
    [self.playerView updatePlayerWithURL:[NSURL URLWithString:@"http://cdnbbbd.shoujiduoduo.com/bb/video/10000048/343684003.mp4"]];
    [self.playerView play];
}

#pragma mark - 懒加载
- (CXDPlayerView *)myPlayerView {
    if (!_myPlayerView) {
        _myPlayerView = [[CXDPlayerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth * (14.0/25.0))];
    }
    return _myPlayerView;
}

- (CustomPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [[CustomPlayerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight * (9.0/16.0))];
    }
    return _playerView;
}


@end
