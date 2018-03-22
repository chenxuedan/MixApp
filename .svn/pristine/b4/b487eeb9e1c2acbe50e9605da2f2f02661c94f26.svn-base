//
//  RAMAnimatedTabBarItem.m
//  MixApp
//
//  Created by 陈雪丹 on 16/7/20.
//  Copyright © 2016年 cxd. All rights reserved.
//

#import "RAMAnimatedTabBarItem.h"

@interface RAMAnimatedTabBarItem ()

@property (nonatomic, strong)UIColor *textColor;

@end

@implementation RAMAnimatedTabBarItem

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage {
    self = [super initWithTitle:title image:image selectedImage:selectedImage];
    if (self) {
        self.animation = [[RAMItemAnimation alloc] init];
        _textColor = [UIColor grayColor];
    }
    return self;
}

- (void)playAnimation:(UIImageView *)icon textLabel:(UILabel *)textLabel {
    [self.animation playAnimation:icon textLabel:textLabel];
}

- (void)deselectAnimation:(UIImageView *)icon textLabel:(UILabel *)textLabel {
    [self.animation deselectAnimation:icon textLabel:textLabel defaultTextColor:self.textColor];
}

- (void)selectedState:(UIImageView *)icon textLabel:(UILabel *)textLabel {
    [self.animation selectedState:icon textLabel:textLabel];
}

@end
