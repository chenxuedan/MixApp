//
//  NewsDateNativeModel.m
//  MixApp
//
//  Created by 陈雪丹 on 2017/3/16.
//  Copyright © 2017年 cxd. All rights reserved.
//

#import "NewsDateNativeModel.h"

@implementation NewsDateNativeModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"top_stories":[NewsTopStoriesModel class]};
}

@end
