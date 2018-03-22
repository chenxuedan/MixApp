//
//  CustomPlayerView.h
//  MixApp
//
//  Created by 陈雪丹 on 2017/3/6.
//  Copyright © 2017年 cxd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TouchPlayerViewMode) {
    TouchPlayerViewModeNone, // 轻触
    TouchPlayerViewModeHorizontal, // 水平滑动
    TouchPlayerViewModeUnknow, // 未知
};


@interface CustomPlayerView : UIView {
    TouchPlayerViewMode _touchMode;
}

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

//播放状态
@property (nonatomic, assign)BOOL isPlaying;
//是否横屏
@property (nonatomic, assign)BOOL isLandscape;
//是否锁屏
@property (nonatomic, assign)BOOL isLock;
//传入视频地址
- (void)updatePlayerWithURL:(NSURL *)url;
//移除通知
//- (void)removeObserveAndNotification;
//切换为横屏
//- (void)setLandscapeLayout;
//切换为竖屏
- (void)setProtraitLayout;
//播放
- (void)play;
//暂停
- (void)pause;


@end
