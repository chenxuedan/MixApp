//
//  AnimationViewController.m
//  MixApp
//
//  Created by 陈雪丹 on 16/8/4.
//  Copyright © 2016年 cxd. All rights reserved.
//

#import "AnimationViewController.h"
#import "ShopCarRedDotView.h"

@interface AnimationViewController () <CAAnimationDelegate>

@end

@implementation AnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)addProductsAnimation:(UIImageView *)imageView {
    if (_animationLayers == nil) {
        _animationLayers = [NSMutableArray arrayWithCapacity:0];
    }
    CGRect frame = [imageView convertRect:imageView.bounds toView:[UIApplication sharedApplication].keyWindow];
    CALayer *transitionLayer = [[CALayer alloc] init];
    transitionLayer.frame = frame;
    transitionLayer.contents = imageView.layer.contents;
    [[UIApplication sharedApplication].keyWindow.layer addSublayer:transitionLayer];
    [self.animationLayers addObject:transitionLayer];
    
//    ShopCarRedDotView *redView = [ShopCarRedDotView singleton];
    CGPoint p1 = transitionLayer.position;
//    CGPoint p3 = CGPointMake(self.view.width - self.view.width / 5 - self.view.width / 10 - 6, self.view.layer.bounds.size.height - 25);
    CGPoint p3 = CGPointMake(kScreenWidth - kScreenWidth / 5 - kScreenWidth / 10, kScreenHeight - 25);
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, p1.x, p1.y);
    CGPathAddCurveToPoint(path, nil, p1.x, p1.y + 25, p3.x, p1.y + 25, p3.x, p3.y);
    positionAnimation.path = path;
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @1;
    opacityAnimation.toValue = @0.9;
    opacityAnimation.fillMode = kCAFillModeForwards;
    opacityAnimation.removedOnCompletion = YES;
    
    CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    transformAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    transformAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 0.2, 0.2, 1)];
    
    CAAnimationGroup *groupAnimation = [[CAAnimationGroup alloc] init];
    groupAnimation.animations = @[positionAnimation,transformAnimation,opacityAnimation];
    groupAnimation.duration = 0.8;
    groupAnimation.delegate = self;
    [transitionLayer addAnimation:groupAnimation forKey:@"cartParabola"];
}

- (void)addProductsToBigShopCarAnimation:(UIImageView *)imageView {
    if (_animationBigLayers == nil) {
        _animationBigLayers = [NSMutableArray arrayWithCapacity:0];
    }
    CGRect frame = [imageView convertRect:imageView.bounds toView:self.view];
    CALayer *transitionLayer = [[CALayer alloc] init];
    transitionLayer.frame = frame;
    transitionLayer.contents = imageView.layer.contents;
    [self.view.layer addSublayer:transitionLayer];
    [_animationBigLayers addObject:transitionLayer];
    
    CGPoint p1 = transitionLayer.position;
    CGPoint p3 = CGPointMake(self.view.width - 25, self.view.layer.bounds.size.height - 25);
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, p1.x, p1.y);
    CGPathAddCurveToPoint(path, nil, p1.x, p1.y - 30, p3.x, p1.y - 30, p3.x, p3.y);
    positionAnimation.path = path;
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @1;
    opacityAnimation.toValue = @0.9;
    opacityAnimation.fillMode = kCAFillModeForwards;
    opacityAnimation.removedOnCompletion = YES;
    
    CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    transformAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    transformAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 0.2, 0.2, 1)];
    
    CAAnimationGroup *groupAnimation = [[CAAnimationGroup alloc] init];
    groupAnimation.animations = @[positionAnimation,transformAnimation,opacityAnimation];
    groupAnimation.duration = 0.8;
//    groupAnimation.delegate = self;
    [transitionLayer addAnimation:groupAnimation forKey:@"BigShopCarAnimation"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (self.animationLayers.count > 0) {
        CALayer *transitionLayer = _animationLayers[0];
        transitionLayer.hidden = YES;
        [transitionLayer removeFromSuperlayer];
        [_animationLayers removeObjectAtIndex:0];
        [self.view.layer removeAnimationForKey:@"cartParabola"];
    }
    if (self.animationBigLayers.count > 0) {
        CALayer *transitionLayer = _animationBigLayers[0];
        transitionLayer.hidden = YES;
        [transitionLayer removeFromSuperlayer];
        [_animationBigLayers removeObjectAtIndex:0];
        [self.view.layer removeAnimationForKey:@"BigShopCarAnimation"];
    }
}

@end
