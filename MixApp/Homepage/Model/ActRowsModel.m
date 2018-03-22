//
//  ActRowsModel.m
//  MixApp
//
//  Created by 陈雪丹 on 16/7/22.
//  Copyright © 2016年 cxd. All rights reserved.
//

#import "ActRowsModel.h"

@implementation ActRowsModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"activity.name":@"name",@"activity.topimg":@"topimg"}];
}

@end
