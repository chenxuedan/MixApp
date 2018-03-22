//
//  CategoryModel.h
//  MixApp
//
//  Created by 陈雪丹 on 16/7/25.
//  Copyright © 2016年 cxd. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "GoodsModel.h"

@interface CategoryModel : JSONModel

@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *category_color;
@property (nonatomic, strong)NSArray <GoodsModel>*goods;

@end
