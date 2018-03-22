//
//  DIscountPriceView.m
//  MixApp
//
//  Created by 陈雪丹 on 16/7/28.
//  Copyright © 2016年 cxd. All rights reserved.
//

#import "DiscountPriceView.h"

@interface DiscountPriceView ()

@property (nonatomic, strong)UILabel *partnerPriceLabel;
@property (nonatomic, strong)UILabel *marketPriceLabel;
@property (nonatomic, strong)UIView *lineView;
@property (nonatomic, assign)BOOL hasMarketPrice;
//@property (nonatomic, strong)UIColor *priceColor;
//@property (nonatomic, strong)UIColor *marketPriceColor;

@end

@implementation DiscountPriceView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self buildCustomView];
    }
    return self;
}

- (void)buildCustomView {
    [self addSubview:self.partnerPriceLabel];
    [self addSubview:self.marketPriceLabel];
    [self.marketPriceLabel addSubview:self.lineView];
}

- (instancetype)initWithPrice:(NSString *)price marketPrice:(NSString *)marketPrice {
    self = [super init];
    if (self) {
        if (price != nil) {
            self.partnerPriceLabel.text =[NSString stringWithFormat:@"$%@",[price cleanDecimalPointZear]];
            [self.partnerPriceLabel sizeToFit];
        }
        if (marketPrice != nil) {
            self.marketPriceLabel.text = [NSString stringWithFormat:@"$%@",[marketPrice cleanDecimalPointZear]];
            [self.marketPriceLabel sizeToFit];
        }else {
            self.hasMarketPrice = NO;
        }
        if (marketPrice == price) {
            self.hasMarketPrice = NO;
        }else {
            self.hasMarketPrice = YES;
        }
        self.marketPriceLabel.hidden = !self.hasMarketPrice;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.partnerPriceLabel.frame = CGRectMake(0, 0, self.partnerPriceLabel.width, self.height);
    if (self.hasMarketPrice) {
        self.marketPriceLabel.frame = CGRectMake(CGRectGetMaxX(self.partnerPriceLabel.frame) + 5, 0, self.marketPriceLabel.width, self.height);
        self.lineView.frame = CGRectMake(0, self.marketPriceLabel.height * 0.5 - 0.5, self.marketPriceLabel.width, 1);
    }
}

#pragma mark - 懒加载
- (UILabel *)partnerPriceLabel {
    if (!_partnerPriceLabel) {
        _partnerPriceLabel = [[UILabel alloc] init];
        _partnerPriceLabel.textColor = [UIColor redColor];
        _partnerPriceLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    return _partnerPriceLabel;
}

- (UILabel *)marketPriceLabel {
    if (!_marketPriceLabel) {
        _marketPriceLabel = [[UILabel alloc] init];
        _marketPriceLabel.textColor = RGB(80, 80, 80);
        _marketPriceLabel.font = [UIFont systemFontOfSize:14];
    }
    return _marketPriceLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = RGB(80, 80, 80);
    }
    return _lineView;
}

@end
