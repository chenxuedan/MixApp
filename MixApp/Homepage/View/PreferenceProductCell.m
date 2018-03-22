//
//  PreferenceProductCell.m
//  MixApp
//
//  Created by 陈雪丹 on 16/7/25.
//  Copyright © 2016年 cxd. All rights reserved.
//

#import "PreferenceProductCell.h"
#import "GoodsModel.h"

@implementation PreferenceProductCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"PreferenceProductCell" owner:self options:nil] lastObject];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)buildContentInformation:(ActRowsModel *)model {
    CategoryModel *cateModel = model.category_detail;
    self.tipView.backgroundColor = [UIColor colorFromHexCode:cateModel.category_color];
    self.categoryName.text = cateModel.name;
    self.categoryName.textColor = [UIColor colorFromHexCode:cateModel.category_color];
    [self.topImageView sd_setImageWithURL:[NSURL URLWithString:model.topimg]];
    GoodsModel *fModel = cateModel.goods[0];
    [self.firstGoodsImg sd_setImageWithURL:[NSURL URLWithString:fModel.img]];
    self.firstGoodsName.text = fModel.name;
    self.firstGoodsSpecifics.text = fModel.specifics;
    self.firstPartnerPrice.text = [NSString stringWithFormat:@"¥%@",fModel.partner_price];
    self.firstMarketPrice.text = [NSString stringWithFormat:@"¥%@",fModel.market_price];
    
    GoodsModel *sModel = cateModel.goods[1];
    [self.secondGoodsImg sd_setImageWithURL:[NSURL URLWithString:sModel.img]];
    self.secondGoodsName.text = sModel.name;
    self.secondGoodsSpecifics.text = sModel.specifics;
    self.secondPartnerPrice.text = [NSString stringWithFormat:@"¥%@",sModel.partner_price];
    self.secondMarketPrice.text = [NSString stringWithFormat:@"¥%@",sModel.market_price];

    GoodsModel *tModel = cateModel.goods[2];
    [self.thirdGoodsImg sd_setImageWithURL:[NSURL URLWithString:tModel.img]];
    self.thirdGoodsName.text = tModel.name;
    self.thirdGoodsSpecifics.text = tModel.specifics;
    self.thirdPartnerPrice.text = [NSString stringWithFormat:@"¥%@",tModel.partner_price];
    self.thirdMarketPrice.text = [NSString stringWithFormat:@"¥%@",tModel.market_price];
    
}

@end
