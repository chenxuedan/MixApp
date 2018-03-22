//
//  BaseViewController.h
//  Demo1
//
//  Created by 陈雪丹 on 16/3/14.
//  Copyright © 2016年 chenxuedan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

//创建上导航的左侧按钮
- (void)createNavigationBarLeftBarButtonItemWithTitle:(NSString *)title;
- (void)createNavigationBarLeftBarButtonItemWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style;
- (void)createNavigationBarLeftBarButtonItemWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action;

//创建上导航左侧按钮(以view作模板)
- (void)createNavigationLeftButton:(id)view;

//创建上导航的右侧按钮
- (void)createNavigationBarRightBarButtonItemWithTitle:(NSString *)title;
- (void)createNavigationBarRightBarButtonItemWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style;
- (void)createNavigationBarRightBarButtonItemWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action;

//创建上导航右侧按钮(以view作模板)
- (void)createNavigationRightButton:(id)view;

//创建数据
- (void)initData;
//创建视图
- (void)createView;
//添加事件
- (void)addTouchAction;
//左侧行为
- (void)leftAction;
//右侧行为
- (void)rightAction;

//键盘弹出
- (void)keyboardShow:(NSNotification *)notification;
//键盘隐藏
- (void)keyboardHide:(NSNotification *)notification;


@end
