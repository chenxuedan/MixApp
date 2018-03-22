//
//  NSTimer+Addition.m
//  MixApp
//
//  Created by 陈雪丹 on 2017/3/9.
//  Copyright © 2017年 cxd. All rights reserved.
//

#import "NSTimer+Addition.h"

@implementation NSTimer (Addition)
//暂停定时器
- (void)pauseTimer {
    if (![self isValid]) {
        return;
    }
    //实现定时器停止
    [self setFireDate:[NSDate distantFuture]];
}
/*
 *  开启
 *  [self setFireDate:[NSDate distantPast]];
 */

//继续
- (void)resumeTimer {
    if (![self isValid]) {
        return;
    }
    //实现定时器运行
    [self setFireDate:[NSDate date]];
}

//一定的时间间隔后开启定时器
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval {
    if (![self isValid]) {
        return;
    }
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
}

@end
