//
//  CustomizeNavBar.m
//  MixApp
//
//  Created by 陈雪丹 on 2017/3/29.
//  Copyright © 2017年 cxd. All rights reserved.
//

#import "CustomizeNavBar.h"

@interface CustomizeNavBar ()

@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UIButton *backBtn;

@end

@implementation CustomizeNavBar
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        self.frame = CGRectMake(0, 0, kScreenWidth, 64);
        [self buildUI];
    }
    return self;
}

- (void)buildUI {
    [self addSubview:self.titleLabel];
    [self addSubview:self.backBtn];
    self.titleLabel.hidden = YES;
}

- (void)setBarHidden:(BOOL)barHidden {
    _barHidden = barHidden;
    if (barHidden) {
        self.titleLabel.hidden = YES;
        [UIView animateWithDuration:0.3 animations:^{
            self.backgroundColor = [UIColor clearColor];
        }];
    }else {
        self.titleLabel.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.backgroundColor = RGB(253, 212, 49);
        }];
    }
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = _title;
}

#pragma mark - 懒加载
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - 100, 20, 200, 44)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:17];
    }
    return _titleLabel;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.frame = CGRectMake(0, 20, 40, 44);
        [_backBtn setImage:[UIImage imageNamed:@"v2_goback"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnDidClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}


#pragma mark - 事件处理
- (void)backBtnDidClicked {
    [self.viewController.navigationController popViewControllerAnimated:YES];
}

@end
