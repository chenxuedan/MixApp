//
//  ConnectTipView.h
//  MixApp
//
//  Created by 陈雪丹 on 16/7/22.
//  Copyright © 2016年 cxd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ButtonDidClick)(void);

@interface ConnectTipView : UIView

- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)imageName title:(NSString *)title buttonTitle:(NSString *)btnTip buttonBlock:(ButtonDidClick)block;

@end
