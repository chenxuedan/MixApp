//
//  Person.h
//  MixApp
//
//  Created by 陈雪丹 on 2017/4/18.
//  Copyright © 2017年 cxd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (nonatomic, copy)NSString *name;
@property (nonatomic, assign)NSUInteger age;
@property (nonatomic, copy)NSString *sex;

- (void)eat;

+ (void)eat;

+ (void)run;


@end
