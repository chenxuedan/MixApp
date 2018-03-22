//
//  SupermarketModel.h
//  MixApp
//
//  Created by 陈雪丹 on 16/7/27.
//  Copyright © 2016年 cxd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductsModel.h"
#import "CategoriesModel.h"

@interface SupermarketModel : NSObject

@property (nonatomic, copy)NSString *code;
@property (nonatomic, copy)NSString *msg;
@property (nonatomic, copy)NSString *reqid;
@property (nonatomic, strong)NSMutableArray *categories;
@property (nonatomic, strong)ProductsModel *products;

@end
