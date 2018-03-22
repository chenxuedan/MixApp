//
//  AnimationViewController.h
//  MixApp
//
//  Created by 陈雪丹 on 16/8/4.
//  Copyright © 2016年 cxd. All rights reserved.
//

#import "BaseViewController.h"

@interface AnimationViewController : BaseViewController

@property (nonatomic, strong)NSMutableArray *animationLayers;
@property (nonatomic, strong)NSMutableArray *animationBigLayers;

//商品添加到购物车动画
- (void)addProductsAnimation:(UIImageView *)imageView;

- (void)addProductsToBigShopCarAnimation:(UIImageView *)imageView;

@end
