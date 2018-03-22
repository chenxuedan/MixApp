//
//  ShopCarRedDotView.m
//  MixApp
//
//  Created by 陈雪丹 on 16/8/3.
//  Copyright © 2016年 cxd. All rights reserved.
//

#import "ShopCarRedDotView.h"

static ShopCarRedDotView *singleton = nil;

@interface ShopCarRedDotView ()

@property (nonatomic, strong)UILabel *numberLabel;
@property (nonatomic, strong)UIImageView *redImageView;

@end

@implementation ShopCarRedDotView

+ (ShopCarRedDotView *)singleton {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] init];
    });
    return singleton;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.redImageView];
        [self addSubview:self.numberLabel];
        self.hidden = YES;
    }
    return self;
}

- (void)setBuyNumber:(int)buyNumber {
    _buyNumber = buyNumber;
    if (buyNumber == 0) {
        _numberLabel.text = @"";
        self.hidden= YES;
    }else {
        if (buyNumber > 99) {
            _numberLabel.font = [UIFont systemFontOfSize:8];
        }else {
            _numberLabel.font = [UIFont systemFontOfSize:10];
        }
        self.hidden = NO;
        _numberLabel.text = [NSString stringWithFormat:@"%d",buyNumber];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _redImageView.frame = self.bounds;
    _numberLabel.frame = CGRectMake(0, 0, self.width, self.height);
}

- (void)addProductToRedDotView:(BOOL)animation {
    self.buyNumber++;
    if (animation) {
        [self reddotAnimation];
    }
}

- (void)reduceProductToRedDotView:(BOOL)animation {
    if (self.buyNumber > 0) {
        self.buyNumber--;
    }
    if (animation) {
        [self reddotAnimation];
    }
}

- (void)reddotAnimation {
    [UIView animateWithDuration:0.2 animations:^{
        self.transform = CGAffineTransformMakeScale(1.5, 1.5);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
}

#pragma mark -懒加载
- (UIImageView *)redImageView {
    if (!_redImageView) {
        _redImageView = [[UIImageView alloc] init];
        [_redImageView setImage:[UIImage imageNamed:@"reddot"]];
    }
    return _redImageView;
}

- (UILabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.font = [UIFont systemFontOfSize:10];
        _numberLabel.textColor = [UIColor whiteColor];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _numberLabel;
}

@end
