//
//  RotationScreen.h
//  MixApp
//
//  Created by 陈雪丹 on 2017/3/3.
//  Copyright © 2017年 cxd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RotationScreen : NSObject

/**
 *  切换横竖屏
 *
 *  @param orientation UIInterfaceOrientation
 */
+ (void)forceOrientation:(UIInterfaceOrientation)orientation;

/**
 *  是否是横屏
 *
 *  @return 是 返回yes
 */
+ (BOOL)isOrientationLandscape;

@end
