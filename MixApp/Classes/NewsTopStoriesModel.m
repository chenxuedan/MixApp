//
//  NewsTopStoriesModel.m
//  MixApp
//
//  Created by 陈雪丹 on 2017/3/16.
//  Copyright © 2017年 cxd. All rights reserved.
//

#import "NewsTopStoriesModel.h"

@implementation NewsTopStoriesModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"storyId":@"id"};
}

@end
