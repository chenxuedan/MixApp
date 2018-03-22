//
//  NSURL+RuntimeURL.m
//  MixApp
//
//  Created by 陈雪丹 on 2017/4/18.
//  Copyright © 2017年 cxd. All rights reserved.
//

#import "NSURL+RuntimeURL.h"

@implementation NSURL (RuntimeURL)

/*
    class_getClassMethod：获取类方法
    class_getInstanceMethod：获取对象方法
 
 */
+ (void)load {
    Method URLWithStr = class_getClassMethod([NSURL class], @selector(URLWithString:));
    Method CXDURLWithStr = class_getClassMethod([NSURL class], @selector(CXDURLWithStr:));
    method_exchangeImplementations(URLWithStr, CXDURLWithStr);
}

+ (instancetype)CXDURLWithStr:(NSString *)URLString {
    NSURL *url = [self CXDURLWithStr:URLString];
    if (url == nil) {
        NSLog(@"url是空");
    }
    return url;
}

@end
