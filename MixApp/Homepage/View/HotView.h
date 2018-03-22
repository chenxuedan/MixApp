//
//  HotView.h
//  MixApp
//
//  Created by 陈雪丹 on 16/7/22.
//  Copyright © 2016年 cxd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^IconClickBlock)(NSInteger index);

@interface HotView : UIView

- (instancetype)initWithFrame:(CGRect)frame iconClick:(IconClickBlock)block;

@end
