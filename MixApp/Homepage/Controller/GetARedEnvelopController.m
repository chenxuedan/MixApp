//
//  GetARedEnvelopController.m
//  MixApp
//
//  Created by 陈雪丹 on 2017/2/16.
//  Copyright © 2017年 cxd. All rights reserved.
//

#import "GetARedEnvelopController.h"

@interface GetARedEnvelopController () {

    CGPoint _startTouch;
}

@property (nonatomic, assign)BOOL isMoving;
//@property (nonatomic, weak)UIView *yellowView;

@end

@implementation GetARedEnvelopController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"领红包";
//    self.navigationController.navigationBar.hidden = YES;
//    UIView *yellowView = [[UIView alloc] init];
//    yellowView.backgroundColor = [UIColor redColor];
//    yellowView.frame = self.view.bounds;
//    [self.view addSubview:yellowView];
//    _yellowView = yellowView;
    
    self.view.backgroundColor = [UIColor greenSeaColor];
    //手势
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
    [self.view addGestureRecognizer:panGestureRecognizer];
    //这个方法必须实现
    [self setAnchorPoint:CGPointMake(0.5, 1.2) forView:self.view];
}

//手势执行的方法
- (void)panGestureRecognizer:(UIPanGestureRecognizer *)recognizer {
    CGPoint touchPoint = [recognizer locationInView:[[UIApplication sharedApplication] keyWindow]];
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        _isMoving = YES;
        _startTouch = touchPoint;
    }else if (recognizer.state == UIGestureRecognizerStateEnded) {
        //当x轴方向移动的值超过180
        if (touchPoint.x - _startTouch.x > 180) {
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:1910];
            } completion:^(BOOL finished) {
                _isMoving = NO;
//                [self.navigationController popViewControllerAnimated:YES];
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
        }else if (touchPoint.x - _startTouch.x < -180) {
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:-1910];
            } completion:^(BOOL finished) {
                _isMoving = NO;
//                [self.navigationController popViewControllerAnimated:YES];
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
        }else {
            [UIView animateWithDuration:0.3 animations:^{
                self.view.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                _isMoving = NO;
            }];
        }
        return;
    }else if (recognizer.state == UIGestureRecognizerStateCancelled) {
        [UIView animateWithDuration:0.3 animations:^{
            [self moveViewWithX:0];
        } completion:^(BOOL finished) {
            _isMoving = NO;
        }];
        return;
    }
    if (_isMoving) {
        [self moveViewWithX:touchPoint.x - _startTouch.x];
    }
}

//核心方法
//获取旋转角度
- (void)moveViewWithX:(float)x {
    //计算角度
    double r = M_PI / 6 * (x / 320);
    //旋转
    self.view.transform = CGAffineTransformMakeRotation(r);
}

//这里必须设置，不然view的旋转会不受控制
- (void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view {
    CGPoint oldOrigin = view.frame.origin;
    view.layer.anchorPoint = anchorPoint;
    CGPoint newOrigin = view.frame.origin;
    
    CGPoint transition;
    transition.x = newOrigin.x - oldOrigin.x;
    transition.y = newOrigin.y - oldOrigin.y;
    
    view.center = CGPointMake(view.center.x - transition.x, view.center.y - transition.y);
}


@end
