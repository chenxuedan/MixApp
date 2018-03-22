//
//  CXDShineParams.h
//  MixApp
//
//  Created by 陈雪丹 on 2017/2/22.
//  Copyright © 2017年 cxd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CXDShineParams : NSObject

//shine是否随机颜色
@property (nonatomic, assign)BOOL allowRandomColor;
//shine动画时间，秒
@property (nonatomic, assign)CGFloat animDuration;
//大Shine的颜色
@property (nonatomic, strong)UIColor *bigShineColor;
//是否需要Flash效果
@property (nonatomic, assign)BOOL enableFlashing;
//shine的扩散的旋转的角度
//@property (nonatomic, as)

@end
