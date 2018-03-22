//
//  RAMBounceAnimation.m
//  MixApp
//
//  Created by 陈雪丹 on 16/7/20.
//  Copyright © 2016年 cxd. All rights reserved.
//

#import "RAMBounceAnimation.h"

@implementation RAMBounceAnimation

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)playAnimation:(UIImageView *)icon textLabel:(UILabel *)textLabel {
    [self playBounceAnimation:icon];
    textLabel.textColor = self.textSelectedColor;
}

- (void)deselectAnimation:(UIImageView *)icon textLabel:(UILabel *)textLabel defaultTextColor:(UIColor *)defaultTextColor {
    textLabel.textColor = defaultTextColor;
    UIImage *iconImage = icon.image;
    UIImage *renderImage = [iconImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    icon.image = renderImage;
    icon.tintColor = defaultTextColor;
}

- (void)selectedState:(UIImageView *)icon textLabel:(UILabel *)textLabel {
    textLabel.textColor = self.textSelectedColor;
    UIImage *iconImage = icon.image;
    UIImage *renderImage = [iconImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    icon.image = renderImage;
    icon.tintColor = self.textSelectedColor;
}

- (void)playBounceAnimation:(UIImageView *)icon {
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    bounceAnimation.values = @[@1.0 ,@1.4, @0.9, @1.15, @0.95, @1.02, @1.0];
    bounceAnimation.duration = self.duration;
    bounceAnimation.calculationMode = kCAAnimationCubic;
    [icon.layer addAnimation:bounceAnimation forKey:@"bounceAnimation"];
    UIImage *iconImage = icon.image;
    UIImage *renderImage = [iconImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    icon.image = renderImage;
    icon.tintColor = self.iconSelectedColor;
}

@end
