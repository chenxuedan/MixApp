//
//  BuyVIew.h
//  MixApp
//
//  Created by 陈雪丹 on 16/7/29.
//  Copyright © 2016年 cxd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductInfomationModel.h"

typedef void(^clickAddShopCar)(void);

@interface BuyView : UIView

/** 商品模型 */
@property (nonatomic, strong)ProductInfomationModel *goods;
@property (nonatomic, copy)clickAddShopCar clickAddShopCarBlock;

@end
