//
//  GoodsModel.h
//  MixApp
//
//  Created by 陈雪丹 on 16/7/25.
//  Copyright © 2016年 cxd. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol GoodsModel <NSObject>

@end

@interface GoodsModel : JSONModel

@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *specifics;

@property (nonatomic, copy)NSString *market_price;
@property (nonatomic, copy)NSString *partner_price;
@property (nonatomic, copy)NSString *img;

@end
