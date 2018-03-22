//
//  NSTimer+Addition.h
//  MixApp
//
//  Created by 陈雪丹 on 2017/3/9.
//  Copyright © 2017年 cxd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Addition)

- (void)pauseTimer;
- (void)resumeTimer;
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval;

@end
