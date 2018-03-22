//
//  Factory.m
//  Demo1
//
//  Created by 陈雪丹 on 16/3/14.
//  Copyright © 2016年 chenxuedan. All rights reserved.
//

#import "Factory.h"
#import "MyHelper.h"

@implementation Factory

+ (UIButton *)createButtonWithTitle:(NSString *)title frame:(CGRect)frame target:(id)target selector:(SEL)selector {
    return [self createButtonWithTitle:title frame:frame backgroundColor:RGB(75, 200, 255) target:target selector:selector];
}

+ (UIButton *)createButtonWithTitle:(NSString *)title frame:(CGRect)frame backgroundColor:(UIColor *)color target:(id)target selector:(SEL)selector {
    return [self createButtonWithTitle:title frame:frame backgroundColor:color fontSize:14.f target:target selector:selector];
}

+ (UIButton *)createButtonWithTitle:(NSString *)title frame:(CGRect)frame backgroundColor:(UIColor *)color fontSize:(CGFloat)size target:(id)target selector:(SEL)selector {
    return [self createButtonWithTitle:title frame:frame backgroundColor:color fontSize:size image:nil target:target selector:selector];
}

+ (UIButton *)createButtonWithTitle:(NSString *)title frame:(CGRect)frame backgroundColor:(UIColor *)color fontSize:(CGFloat)size image:(UIImage *)image target:(id)target selector:(SEL)selector {
    return [self createButtonWithTitle:title frame:frame backgroundColor:color fontSize:size image:image backgroundImage:nil target:target selector:selector];
}

+ (UIButton *)createButtonWithTitle:(NSString *)title frame:(CGRect)frame backgroundColor:(UIColor *)color fontSize:(CGFloat)size backgroundImage:(UIImage *)bgImage target:(id)target selector:(SEL)selector {
    return [self createButtonWithTitle:title frame:frame backgroundColor:color fontSize:size backgroundImage:bgImage target:target selector:selector];
}

+ (UIButton *)createButtonWithTitle:(NSString *)title
                              frame:(CGRect)frame
                    backgroundColor:(UIColor *)color
                           fontSize:(CGFloat)size
                              image:(UIImage *)image
                    backgroundImage:(UIImage *)backgroundImage
                             target:(id)target
                           selector:(SEL)selector {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    
    button.layer.cornerRadius = 3.f;
    button.layer.masksToBounds = YES;
    
    button.titleLabel.font = [UIFont systemFontOfSize:size];
    button.backgroundColor = color;
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateNormal];
    [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}


+ (UILabel *)createLabelWithTitle:(NSString *)title frame:(CGRect)frame {
    return [self createLabelWithTitle:title frame:frame fontSize:14.f];
}

+ (UILabel *)createLabelWithTitle:(NSString *)title frame:(CGRect)frame textColor:(UIColor *)color {
    return [self createLabelWithTitle:title frame:frame textColor:color fontSize:14.f];
}

+ (UILabel *)createLabelWithTitle:(NSString *)title frame:(CGRect)frame fontSize:(CGFloat)size {
    return [self createLabelWithTitle:title frame:frame textColor:[UIColor blackColor] fontSize:size];
}

+ (UILabel *)createLabelWithTitle:(NSString *)title frame:(CGRect)frame textColor:(UIColor *)color fontSize:(CGFloat)size {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = title;
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:size];
    return label;
}

+ (UIView *)createViewWithBackgroundColor:(UIColor *)color frame:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = color;
    return view;
}

+ (UITextField *)createViewWithText:(NSString *)text frame:(CGRect)frame placeholder:(NSString *)placeholder textColor:(UIColor *)color borderStyle:(UITextBorderStyle)borderStyle {
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.placeholder = placeholder;
    textField.borderStyle = borderStyle;
    textField.text = text;
    textField.textColor = color;
    return textField;
}

@end
