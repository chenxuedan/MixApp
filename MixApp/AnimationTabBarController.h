//
//  AnimationTabBarController.h
//  MixApp
//
//  Created by 陈雪丹 on 16/7/19.
//  Copyright © 2016年 cxd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnimationTabBarController : UITabBarController

- (NSDictionary *)createViewContainers;

- (UIView *)createViewContainer:(NSInteger)index;

- (void)createCustomIcons:(NSDictionary *)containers;

- (void)setSelectIndexFrom:(NSInteger)from to:(NSInteger)to;

@end
