//
//  NewsDateNativeModel.h
//  MixApp
//
//  Created by 陈雪丹 on 2017/3/16.
//  Copyright © 2017年 cxd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsTopStoriesModel.h"

@interface NewsDateNativeModel : NSObject

@property (nonatomic, copy)NSString *date;
@property (nonatomic, strong)NSMutableArray *stories;
@property (nonatomic, strong)NSMutableArray *top_stories;

@end
