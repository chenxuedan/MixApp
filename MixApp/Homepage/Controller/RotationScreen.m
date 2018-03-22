//
//  RotationScreen.m
//  MixApp
//
//  Created by 陈雪丹 on 2017/3/3.
//  Copyright © 2017年 cxd. All rights reserved.
//

#import "RotationScreen.h"

@implementation RotationScreen

/**
 *  切换横竖屏
 *
 *  @param orientation UIInterfaceOrientation
 */
+ (void)forceOrientation:(UIInterfaceOrientation)orientation {
    // setOrientation: 私有方法强制横屏
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

/**
 *  是否是横屏
 *
 *  @return 是 返回yes
 */
+ (BOOL)isOrientationLandscape {
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        return YES;
    }else {
        return NO;
    }
}

@end
