//
//  CXDPlayerView.h
//  MixApp
//
//  Created by 陈雪丹 on 2017/3/3.
//  Copyright © 2017年 cxd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CXDPlayerView : UIView

//播放状态
@property (nonatomic, assign)BOOL isPlaying;

// 传入视频地址
- (void)updatePlayerWithURL:(NSURL *)url;

- (void)play;

@end
