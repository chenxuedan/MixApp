//
//  ConnectTipView.m
//  MixApp
//
//  Created by 陈雪丹 on 16/7/22.
//  Copyright © 2016年 cxd. All rights reserved.
//

#import "ConnectTipView.h"

@interface ConnectTipView ()

@property (nonatomic, strong)UIImageView *shopImageView;
@property (nonatomic, strong)UILabel *emptyLabel;
@property (nonatomic, strong)UIButton *emptyButton;
@property (nonatomic, copy)ButtonDidClick block;
@property (nonatomic, copy)NSString *imageName;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *btnTip;

@end

@implementation ConnectTipView

- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)imageName title:(NSString *)title buttonTitle:(NSString *)btnTip buttonBlock:(ButtonDidClick)block{
    self = [super initWithFrame:frame];
    if (self) {
        self.block = block;
        self.imageName = imageName;
        self.title = title;
        self.btnTip = btnTip;
        [self createCustomView];
    }
    return self;
}

- (void)createCustomView {
    [self addSubview:self.shopImageView];
    [self addSubview:self.emptyLabel];
    [self addSubview:self.emptyButton];
}
#pragma mark -懒加载
- (UIImageView *)shopImageView {
    if (!_shopImageView) {
        _shopImageView = [[UIImageView alloc] init];
        _shopImageView.image = [UIImage imageNamed:self.imageName];
        _shopImageView.contentMode = UIViewContentModeCenter;
        _shopImageView.frame = CGRectMake((self.width - _shopImageView.width) * 0.5, 64 + self.height * 0.25, _shopImageView.width, _shopImageView.height);
    }
    return _shopImageView;
}

- (UILabel *)emptyLabel {
    if (!_emptyLabel) {
        _emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.shopImageView.frame) + 55, self.width, 50)];
        _emptyLabel.text = self.title;
        _emptyLabel.textColor = RGB(100, 100, 100);
        _emptyLabel.textAlignment = NSTextAlignmentCenter;
        _emptyLabel.font = [UIFont systemFontOfSize:16];
    }
    return _emptyLabel;
}

- (UIButton *)emptyButton {
    if (!_emptyButton) {
        _emptyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _emptyButton.frame = CGRectMake((self.width - 150) * 0.5, CGRectGetMaxY(self.emptyLabel.frame) + 15, 150, 30);
        [_emptyButton setBackgroundImage:[UIImage imageNamed:@"btn.png"] forState:UIControlStateNormal];
        [_emptyButton setTitle:self.btnTip forState:UIControlStateNormal];
        [_emptyButton setTitleColor:RGB(100, 100, 100) forState:UIControlStateNormal];
        [_emptyButton addTarget:self action:@selector(leftNavigitonItemClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _emptyButton;
}

- (void)leftNavigitonItemClick {
    if (self.block) {
        self.block();
    }
}


@end
