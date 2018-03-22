//
//  GuideCell.m
//  MixApp
//
//  Created by 陈雪丹 on 16/7/21.
//  Copyright © 2016年 cxd. All rights reserved.
//

#import "GuideCell.h"
#import "MainTabBarController.h"

@implementation GuideCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)createView {
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_imageView];
    
    _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextButton.frame = CGRectMake((kScreenWidth - 100)/2, kScreenHeight - 110, 100, 33);
    [_nextButton setBackgroundImage:[UIImage imageNamed:@"icon_next"] forState:UIControlStateNormal];
    [_nextButton addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _nextButton.hidden = YES;
    [self.contentView addSubview:_nextButton];
}

- (void)nextButtonClick {
    MainTabBarController *mainTabBar = [[MainTabBarController alloc] init];
    self.window.rootViewController = mainTabBar;
    [UIApplication sharedApplication].keyWindow.rootViewController = mainTabBar;
}

@end
