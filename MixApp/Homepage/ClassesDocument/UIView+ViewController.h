//
//  UIView+ViewController.h
//  MixApp
//
//  Created by 陈雪丹 on 2017/3/29.
//  Copyright © 2017年 cxd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ViewController)


/**
 *  获取当前控制器
 *
 *  @return
 */
-(UIViewController *)viewController;

/**
 *  获取当前navigationController
 *
 *  @return
 */
- (UINavigationController *)navigationController;

/**
 *  获取当前tabBarController
 *
 *  @return
 */
- (UITabBarController *)tabBarController;




@end
