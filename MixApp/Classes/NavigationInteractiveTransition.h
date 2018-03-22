//
//  NavigationInteractiveTransition.h
//  MixApp
//
//  Created by 陈雪丹 on 2017/2/16.
//  Copyright © 2017年 cxd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIViewController,UIPercentDrivenInteractiveTransition;

@interface NavigationInteractiveTransition : NSObject <UINavigationControllerDelegate>

- (instancetype)initWithViewController:(UIViewController *)viewController;
- (void)handleControllerPop:(UIPanGestureRecognizer *)recognizer;
- (UIPercentDrivenInteractiveTransition *)interactivePopTransition;

@end
