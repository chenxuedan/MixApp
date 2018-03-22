//
//  UIView+Addition.m
//  Demo1
//
//  Created by 陈雪丹 on 16/3/14.
//  Copyright © 2016年 chenxuedan. All rights reserved.
//

#import "UIView+Addition.h"

@implementation UIView (Addition)

@dynamic x;
@dynamic y;
@dynamic centerX;
@dynamic centerY;

#pragma mark --------------Getters-------------
- (CGFloat)x{
    return self.frame.origin.x;
}

- (CGFloat)y{
    return self.frame.origin.y;
}

//宽
- (CGFloat)width {
    return self.frame.size.width;
}

//高
- (CGFloat)height {
    return self.frame.size.height;
}

//上
- (CGFloat)top {
    return self.frame.origin.y;
}

//下
- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

//左
- (CGFloat)left {
    return self.frame.origin.x;
}

//右
- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (CGFloat)centerY {
    return self.center.y;
}

#pragma mark ----------setter----------

- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

//设置宽
- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

//设置高
- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

//设置x
- (void)setXOffset:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

//设置y
- (void)setYOffset:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

//设置Origin
- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

//设置size
- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (void)setCenterX:(CGFloat)centerX{
    self.center = CGPointMake(centerX, self.center.y);
}

- (void)setCenterY:(CGFloat)centerY{
    self.center = CGPointMake(self.center.x, centerY);
}


@end
