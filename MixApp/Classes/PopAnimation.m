//
//  PopAnimation.m
//  MixApp
//
//  Created by 陈雪丹 on 2017/2/16.
//  Copyright © 2017年 cxd. All rights reserved.
//

#import "PopAnimation.h"

@interface PopAnimation ()

@property (nonatomic, strong)id<UIViewControllerAnimatedTransitioning>transitionContext;

@end

@implementation PopAnimation

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    //这个方法返回动画执行的时间
    return 0.25;
}

/**
 *  transitionContext你可以看作是一个工具，用来获取一系列动画执行相关的对象，并且通知系统动画是否完成等功能。
 */
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    /**
     *  获取动画来自的那个控制器
     */
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewKey];
    /**
     *  获取转场到的那个控制器
     */
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewKey];
    /**
     *  转场动画是两个控制器视图之间的动画，需要一个containerView来作为一个“舞台”，让动画执行。
     */
    UIView *containerView = [transitionContext containerView];
    [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    /**
     *  执行动画，我们让fromVC的视图移动到屏幕最右侧
     */
    [UIView animateWithDuration:duration animations:^{
        fromViewController.view.transform = CGAffineTransformMakeTranslation([UIScreen mainScreen].bounds.size.width, 0);
    } completion:^(BOOL finished) {
        /**
         *  当你的动画执行完成，这个方法必须要调用，否则系统会认为你的其余任何操作都在动画执行过程中。
         */
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

//- (void)animationDidStop:(CATransition *)anim finished:(BOOL)flag {
//    [_transitionContext completeTransition:!_transitionContext.transitionWasCancelled];
//}

@end
