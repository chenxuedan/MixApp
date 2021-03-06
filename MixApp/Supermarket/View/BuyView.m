//
//  BuyVIew.m
//  MixApp
//
//  Created by 陈雪丹 on 16/7/29.
//  Copyright © 2016年 cxd. All rights reserved.
//

#import "BuyView.h"
#import "ShopCarRedDotView.h"
#import "UserShopCarTool.h"

@interface BuyView ()

@property (nonatomic, strong)UIButton *addGoodsButton;
@property (nonatomic, strong)UIButton *reduceGoodsButton;
@property (nonatomic, strong)UILabel *buyCountLabel;
@property (nonatomic, strong)UILabel *supplementLabel;

@end

@implementation BuyView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.addGoodsButton];
        [self addSubview:self.reduceGoodsButton];
        [self addSubview:self.buyCountLabel];
        [self addSubview:self.supplementLabel];
    }
    return self;
}

- (void)setGoods:(ProductInfomationModel *)goods {
    _goods = goods;
    _buyCountLabel.text = [NSString stringWithFormat:@"%d",_goods.userBuyNumber];
    if (goods.number <= 0) {
        [self showSupplementLabel];
    }else {
        [self hideSupplementLabel];
    }
    if (goods.userBuyNumber > 0) {
        _reduceGoodsButton.hidden = NO;
        _buyCountLabel.hidden = NO;
    }else {
        _reduceGoodsButton.hidden = YES;
        _buyCountLabel.hidden = YES;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat buyCountWidth = 25;
    _addGoodsButton.frame = CGRectMake(self.width - self.height - 2, 0, self.height, self.height);
    _buyCountLabel.frame = CGRectMake(CGRectGetMinX(_addGoodsButton.frame) - buyCountWidth, 0, buyCountWidth, self.height);
    _reduceGoodsButton.frame = CGRectMake(CGRectGetMinX(_buyCountLabel.frame) - self.height, 0, self.height, self.height);
    _supplementLabel.frame = CGRectMake(CGRectGetMinX(_reduceGoodsButton.frame), 0, self.height + buyCountWidth + self.height, self.height);
}
//显示补货中
- (void)showSupplementLabel {
    _supplementLabel.hidden = NO;
    _addGoodsButton.hidden = YES;
    _reduceGoodsButton.hidden = YES;
    _buyCountLabel.hidden = YES;
}
/// 隐藏补货中,显示添加按钮
- (void)hideSupplementLabel {
    _supplementLabel.hidden = YES;
    _addGoodsButton.hidden = NO;
    _reduceGoodsButton.hidden = NO;
    _buyCountLabel.hidden = NO;
}

- (void)addGoodsButtonClick {
    if (_goods.userBuyNumber >= _goods.number) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kHomeGoodsInventoryProblem object:_goods.name userInfo:nil];
        return;
    }
    _reduceGoodsButton.hidden = NO;
    _goods.userBuyNumber++;
    _buyCountLabel.text = [NSString stringWithFormat:@"%d",_goods.userBuyNumber];
    _buyCountLabel.hidden = NO;
    
    if (_clickAddShopCarBlock) {
        _clickAddShopCarBlock();
    }
    
    [[ShopCarRedDotView singleton] addProductToRedDotView:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:kShopCarBuyPriceDidChangeNotification object:nil userInfo:nil];
}

- (void)reduceGoodsButtonClick {
    if (_goods.userBuyNumber <= 0) {
        return;
    }
    self.goods.userBuyNumber--;
    if (_goods.userBuyNumber == 0) {
        _reduceGoodsButton.hidden = YES;
        _buyCountLabel.hidden = YES;
        _buyCountLabel.text = @"";
        [[UserShopCarTool singleton] removeSupermarketProduct:_goods];
    }else {
        _buyCountLabel.text = [NSString stringWithFormat:@"%ld",(long)_goods.userBuyNumber];
    }
    
    [[ShopCarRedDotView singleton] reduceProductToRedDotView:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:kShopCarBuyPriceDidChangeNotification object:nil userInfo:nil];
}

#pragma mark - 懒加载
- (UIButton *)addGoodsButton {
    if (!_addGoodsButton) {
        _addGoodsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addGoodsButton setImage:[UIImage imageNamed:@"v2_increase"] forState:UIControlStateNormal];
        [_addGoodsButton addTarget:self action:@selector(addGoodsButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addGoodsButton;
}

-(UIButton *)reduceGoodsButton {
    if (!_reduceGoodsButton) {
        _reduceGoodsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_reduceGoodsButton setImage:[UIImage imageNamed:@"v2_reduce"] forState:UIControlStateNormal];
        [_reduceGoodsButton addTarget:self action:@selector(reduceGoodsButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _reduceGoodsButton.hidden = NO;
    }
    return _reduceGoodsButton;
}

- (UILabel *)buyCountLabel {
    if (!_buyCountLabel) {
        _buyCountLabel = [[UILabel alloc] init];
        _buyCountLabel.hidden = NO;
        _buyCountLabel.text = @"0";
        _buyCountLabel.textColor = [UIColor blackColor];
        _buyCountLabel.textAlignment = NSTextAlignmentCenter;
        _buyCountLabel.font = [UIFont systemFontOfSize:14];
    }
    return _buyCountLabel;
}

- (UILabel *)supplementLabel {
    if (!_supplementLabel) {
        _supplementLabel = [[UILabel alloc] init];
        _supplementLabel.text = @"补货中";
        _supplementLabel.hidden = YES;
        _supplementLabel.textAlignment = NSTextAlignmentRight;
        _supplementLabel.textColor = [UIColor redColor];
        _supplementLabel.font = [UIFont systemFontOfSize:14];
    }
    return _supplementLabel;
}

@end
