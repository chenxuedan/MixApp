//
//  ProductsCell.m
//  MixApp
//
//  Created by 陈雪丹 on 16/7/28.
//  Copyright © 2016年 cxd. All rights reserved.
//

#import "ProductsCell.h"
#import "BuyView.h"
#import "DiscountPriceView.h"

@interface ProductsCell ()

@property (nonatomic, strong)UIImageView *goodsImageView;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UIImageView *fineImageView;
@property (nonatomic, strong)UIImageView *giveImageView;
@property (nonatomic, strong)UILabel *specificsLabel;
@property (nonatomic, strong)UIView *lineView;
@property (nonatomic, strong)BuyView *buyView;
@property (nonatomic, strong)DiscountPriceView *discountPriceView;

@end

@implementation ProductsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self buildCustomView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        __weak typeof(self) WeakSelf = self;
        _buyView.clickAddShopCarBlock = ^{
            if (WeakSelf.addProductBlock) {
                WeakSelf.addProductBlock(WeakSelf.goodsImageView);
            }
        };
    }
    return self;
}

- (void)buildCustomView {
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.goodsImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.fineImageView];
    [self.contentView addSubview:self.giveImageView];
    [self.contentView addSubview:self.specificsLabel];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.buyView];
}

- (void)setModel:(ProductInfomationModel *)model {
    _model = model;
    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:model.img]];
    _nameLabel.text = model.name;
    _specificsLabel.text = model.specifics;
    if ([model.pm_desc isEqualToString:@"买一赠一"]) {
        _giveImageView.hidden = NO;
    }else {
        _giveImageView.hidden = YES;
    }
    if ([model.is_xf isEqualToString:@"1"]) {
        _fineImageView.hidden = NO;
    }else {
        _fineImageView.hidden = YES;
    }
    if (_discountPriceView) {
        [_discountPriceView removeFromSuperview];
    }
    _discountPriceView = [[DiscountPriceView alloc] initWithPrice:model.partner_price marketPrice:model.market_price];
    [self.contentView addSubview:self.discountPriceView];
    _buyView.goods = _model;

}

- (void)layoutSubviews {
    [super layoutSubviews];
    _goodsImageView.frame = CGRectMake(0, 0, self.height, self.height);
    _fineImageView.frame = CGRectMake(CGRectGetMaxX(_goodsImageView.frame), LeftDistance, 30, 16);
    if (_fineImageView.hidden) {
        _nameLabel.frame = CGRectMake(CGRectGetMaxX(_goodsImageView.frame) + 3, LeftDistance - 2, self.width - CGRectGetMaxX(_fineImageView.frame), 20);
    }else {
        _nameLabel.frame = CGRectMake(CGRectGetMaxX(_fineImageView.frame) + 3, LeftDistance - 2, self.width - CGRectGetMaxX(_fineImageView.frame), 20);
    }
    _giveImageView.frame = CGRectMake(CGRectGetMaxX(_goodsImageView.frame), CGRectGetMaxY(_nameLabel.frame), 35, 15);
    _specificsLabel.frame = CGRectMake(CGRectGetMaxX(_goodsImageView.frame), CGRectGetMaxY(_giveImageView.frame), self.width, 20);
    _discountPriceView.frame = CGRectMake(CGRectGetMaxX(_goodsImageView.frame), CGRectGetMaxY(_specificsLabel.frame), 60, self.height - CGRectGetMaxY(_specificsLabel.frame));
    _lineView.frame = CGRectMake(LeftDistance, self.height - 1, self.width - LeftDistance, 1);
    _buyView.frame = CGRectMake(self.width - 85, self.height - 30, 80, 25);
}
#pragma mark - 懒加载
- (UIImageView *)goodsImageView {
    if (!_goodsImageView) {
        _goodsImageView = [[UIImageView alloc] init];
    }
    return _goodsImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textColor = [UIColor blackColor];
    }
    return _nameLabel;
}

- (UIImageView *)fineImageView {
    if (!_fineImageView) {
        _fineImageView = [[UIImageView alloc] init];
        [_fineImageView setImage:[UIImage imageNamed:@"jingxuan.png"]];
    }
    return _fineImageView;
}

- (UIImageView *)giveImageView {
    if (!_giveImageView) {
        _giveImageView = [[UIImageView alloc] init];
        [_giveImageView setImage:[UIImage imageNamed:@"buyOne.png"]];
    }
    return _giveImageView;
}

- (UILabel *)specificsLabel {
    if (!_specificsLabel) {
        _specificsLabel = [[UILabel alloc] init];
        _specificsLabel.textColor = RGB(100, 100, 100);
        _specificsLabel.font = [UIFont systemFontOfSize:12];
        _specificsLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _specificsLabel;
}

-(UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = RGB(100, 100, 100);
        _lineView.alpha = 0.05;
    }
    return _lineView;
}

- (BuyView *)buyView {
    if (!_buyView) {
        _buyView = [[BuyView alloc] init];
    }
    return _buyView;
}

- (DiscountPriceView *)discountPriceView {
    if (!_discountPriceView) {
        _discountPriceView = [[DiscountPriceView alloc] init];
    }
    return _discountPriceView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
