//
//  UIView+ViewController.m
//  MixApp
//
//  Created by 陈雪丹 on 2017/3/29.
//  Copyright © 2017年 cxd. All rights reserved.
//

#import "UIView+ViewController.h"

@implementation UIView (ViewController)

- (UIViewController *)viewController {
    id next = [self nextResponder];
    while (next) {
        next = [next nextResponder];
        if ([next isKindOfClass:[UIViewController class]]) {
            return next;
        }
    }
    return nil;
}

- (UINavigationController *)navigationController {
    UIResponder *next = self.nextResponder;
    do {
        if ([next isKindOfClass:[UINavigationController class]]) {
            return (UINavigationController *)next;
        }
        next = next.nextResponder;
    } while (next);
    return nil;
}

- (UITabBarController *)tabBarController {
    UIResponder *next = self.nextResponder;
    do {
        if ([next isKindOfClass:[UITabBarController class]]) {
            return (UITabBarController *)next;
        }
        next = next.nextResponder;
    } while (next);
    return nil;
}

@end
