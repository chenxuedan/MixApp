//
//  main.m
//  MixApp
//
//  Created by 陈雪丹 on 16/7/19.
//  Copyright © 2016年 cxd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        //UIApplication(代表着我们的应用程序) 单例！！
        //内部肯定有一个死循环
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}


//Runloop：运行循环--死循环
//1.开启一条线程！这条线程就是这个APP的主线程！！
//2.这个主线程是一个常驻线程！因为这条线程上面的Runloop被开启了
//


/*
 runloop的作用：
 1.保证线程不退出！！
 2.负责监听所有的事件！！iOS中的触摸\时钟\网络事件
 3.Runloop负责绘制UI
 
 */


/*
 Source：事件源（输入源） 按照函数调用栈分为：
 source0:非系统内核事件
 source1:系统内核事件
 
 */
