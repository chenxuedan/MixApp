//
//  RAMItemAnimation.h
//  MixApp
//
//  Created by 陈雪丹 on 16/7/20.
//  Copyright © 2016年 cxd. All rights reserved.
//

#import <Foundation/Foundation.h>

//@protocol RAMItemAnimationProtocol <NSObject>
//
//- (void)playAnimation:(UIImageView *)icon textLabel:(UILabel *)textLabel;
//
//- (void)deselectAnimation:(UIImageView *)icon textLabel:(UILabel *)textLabel defaultTextColor:(UIColor *)defaultTextColor;
//
//- (void)selectedState:(UIImageView *)icon textLabel:(UILabel *)textLabel;
//
//@end

@interface RAMItemAnimation : NSObject
//<RAMItemAnimationProtocol>

//动画时间
@property (nonatomic, assign)CGFloat duration;
//选中时的文字颜色
@property (nonatomic, strong)UIColor *textSelectedColor;
//选中时的图片颜色
@property (nonatomic, strong)UIColor *iconSelectedColor;

- (void)playAnimation:(UIImageView *)icon textLabel:(UILabel *)textLabel;

- (void)deselectAnimation:(UIImageView *)icon textLabel:(UILabel *)textLabel defaultTextColor:(UIColor *)defaultTextColor;

- (void)selectedState:(UIImageView *)icon textLabel:(UILabel *)textLabel;

@end
