//
//  UIView+Addition.h
//  Demo1
//
//  Created by 陈雪丹 on 16/3/14.
//  Copyright © 2016年 chenxuedan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Addition)

@property (nonatomic, assign)CGFloat x;
@property (nonatomic, assign)CGFloat y;
@property (nonatomic, assign)CGFloat centerX;
@property (nonatomic, assign)CGFloat centerY;

//宽
- (CGFloat)width;

//高
- (CGFloat)height;

//上
- (CGFloat)top;

//下
- (CGFloat)bottom;

//左
- (CGFloat)left;

//右
- (CGFloat)right;

//设置宽
- (void)setWidth:(CGFloat)width;

//设置高
- (void)setHeight:(CGFloat)height;

//设置x
- (void)setXOffset:(CGFloat)x;

//设置y
- (void)setYOffset:(CGFloat)y;

//设置Origin
- (void)setOrigin:(CGPoint)origin;

//设置size
- (void)setSize:(CGSize)size;

@end
