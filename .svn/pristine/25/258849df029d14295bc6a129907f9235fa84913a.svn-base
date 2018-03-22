//
//  UserShopCarTool.m
//  MixApp
//
//  Created by 陈雪丹 on 16/8/3.
//  Copyright © 2016年 cxd. All rights reserved.
//

#import "UserShopCarTool.h"
#import "ShopCarRedDotView.h"

static UserShopCarTool*singleton = nil;

@interface UserShopCarTool ()

@property (nonatomic, strong)NSMutableArray *supermarketProducts;

@end

@implementation UserShopCarTool

+ (UserShopCarTool *)singleton {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] init];
    });
    return singleton;
}

- (int)userShopCarProductsNumber {
    return [ShopCarRedDotView singleton].buyNumber;
}

- (BOOL)isEmpty {
    return (_supermarketProducts.count == 0);
}

- (void)addSupermarkProductToShopCar:(ProductInfomationModel *)model {
    for (ProductInfomationModel *product in _supermarketProducts) {
        if (product.productID == model.productID) {
            return;
        }
    }
    [_supermarketProducts addObject:model];
}

- (NSMutableArray *)getShopCarProducts {
    return _supermarketProducts;
}

- (NSInteger)getShopCarProductsClassifNumber {
    return _supermarketProducts.count;
}

- (void)removeSupermarketProduct:(ProductInfomationModel *)goods {
    for (int i = 0; i < _supermarketProducts.count; i++) {
        ProductInfomationModel *everyDoods = _supermarketProducts[i];
        if (everyDoods.productID == goods.productID) {
            [_supermarketProducts removeObjectAtIndex:i];
            [[NSNotificationCenter defaultCenter] postNotificationName:kShopCarDidRemoveProductNSNotification object:nil userInfo:nil];
            return;
        }
    }
}

- (NSString *)getAllProductsPrice {
    CGFloat allPrice = 0;
    for (ProductInfomationModel *model in _supermarketProducts) {
//        allPrice = allPrice + [model.partner_price floatValue]* ([model.userBuyNumber integerValue]);
    }
    return [NSString stringWithFormat:@"%f",allPrice].cleanDecimalPointZear;
}

@end
