//
//  SupermarketModel.m
//  MixApp
//
//  Created by 陈雪丹 on 16/7/27.
//  Copyright © 2016年 cxd. All rights reserved.
//

#import "SupermarketModel.h"
#import "CategoriesModel.h"

@implementation SupermarketModel

// 实现这个方法的目的：告诉MJExtension框架categories数组里面装的是CategoriesModel模型
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"categories":[CategoriesModel class]};
}

// 实现这个方法的目的：告诉MJExtension框架模型中的属性名对应着字典的哪个key
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"categories":@"data.categories",@"products":@"data.products"};
}

@end
