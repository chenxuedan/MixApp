//
//  CategoriesModel.m
//  MixApp
//
//  Created by 陈雪丹 on 16/7/27.
//  Copyright © 2016年 cxd. All rights reserved.
//

#import "CategoriesModel.h"

@implementation CategoriesModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"categoriesID":@"id"};
}

@end
