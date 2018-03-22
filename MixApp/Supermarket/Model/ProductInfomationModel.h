//
//  ProductInfomationModel.h
//  MixApp
//
//  Created by 陈雪丹 on 16/7/27.
//  Copyright © 2016年 cxd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductInfomationModel : NSObject

@property (nonatomic, copy)NSString *productID;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *specifics;
@property (nonatomic, copy)NSString *partner_price;
@property (nonatomic, copy)NSString *market_price;
@property (nonatomic, copy)NSString *img;
@property (nonatomic, copy)NSString *pm_desc;
@property (nonatomic, copy)NSString *is_xf;
@property (nonatomic, assign)int number;
@property (nonatomic, assign)int userBuyNumber;

@end
