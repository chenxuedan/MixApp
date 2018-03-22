//
//  MainTabBarController.m
//  MixApp
//
//  Created by 陈雪丹 on 16/7/19.
//  Copyright © 2016年 cxd. All rights reserved.
//

#import "MainTabBarController.h"
#import "MainNavigationController.h"
#import "RAMAnimatedTabBarItem.h"
#import "RAMBounceAnimation.h"
#import "InterTransitionNavigationController.h"

@interface MainTabBarController () <UITabBarControllerDelegate>

@end

@implementation MainTabBarController
- (void)viewDidLoad {
    [super viewDidLoad];
    if (iOS7) {
        /**
         *   在iOS 7中，苹果引入了一个新的属性，叫做[UIViewController setEdgesForExtendedLayout:]，它的默认值为UIRectEdgeAll。当你的容器是navigation controller时，默认的布局将从navigation bar的顶部开始。这就是为什么所有的UI元素都往上漂移了44pt。
         修复这个问题的快速方法就是在方法- (void)viewDidLoad中添加如下一行代码：
         self.edgesForExtendedLayout = UIRectEdgeNone;
         这样问题就修复了。
         */
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self setImageViewAnimation];
    [self addAllChildViewControllers];
}

//实现启动图图片的放大消失功能
-(void)setImageViewAnimation{
    
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    NSString *viewOrientation = @"Portrait";    //横屏请设置成 @"Landscape"
    NSString *launchImage = nil;
    
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary *dict in imagesDict)
    {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
        {
            launchImage = dict[@"UILaunchImageName"];
        }
    }
    
    UIImageView *launchView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:launchImage]];
    UIButton *timeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    timeBtn.frame = CGRectMake(kScreenWidth - 120, 80, 100, 30);
    timeBtn.layer.cornerRadius = 15.f;
    timeBtn.layer.masksToBounds = YES;
    timeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [timeBtn setTitle:@"停留1秒钟" forState:UIControlStateNormal];
    [timeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    timeBtn.backgroundColor = RGBA(0, 0, 0, 0.4);
    [launchView addSubview:timeBtn];
    launchView.frame = [UIScreen mainScreen].bounds;
    launchView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:launchView];
    
    [UIView animateWithDuration:1.0f
                          delay:0.0f
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         launchView.layer.transform = CATransform3DScale(CATransform3DIdentity, 1.2, 1.2, 1);
                         launchView.alpha = 0.0f;
                     } completion:^(BOOL finished) {
                         [launchView removeFromSuperview];
                     }];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSDictionary *containers = [self createViewContainers];
    [self createCustomIcons:containers];
}

- (void)addAllChildViewControllers{
    NSArray *titleArray = @[@"首页",@"闪电超市",@"新鲜预定",@"购物车",@"我的"];
    NSArray *imageArray = @[@"v2_home", @"v2_order",@"freshReservation", @"shopCart",@"v2_my"];
    NSArray *selectedImageArray = @[@"v2_home_r", @"v2_order_r",@"freshReservation_r", @"shopCart_r",@"v2_my_r"];
    NSArray *classes = @[@"HomePageController",@"SuperMarketController",@"FreshReservationController",@"ShoppingCartController",@"MineViewController"];
    for (NSInteger index = 0; index < titleArray.count; index++) {
        Class cls = NSClassFromString(classes[index]);
        UIViewController *customViewController = [[cls alloc] init];
        customViewController.title = titleArray[index];
        RAMAnimatedTabBarItem *vcItem = [[RAMAnimatedTabBarItem alloc] initWithTitle:titleArray[index] image:[UIImage imageNamed:imageArray[index]] selectedImage:[UIImage imageNamed:selectedImageArray[index]]];
        vcItem.tag = index;
        vcItem.animation = [[RAMBounceAnimation alloc] init];
        customViewController.tabBarItem = vcItem;
        [UITabBar appearance].backgroundColor = [UIColor whiteColor];

        MainNavigationController *mainNav = [[MainNavigationController alloc] initWithRootViewController:customViewController];
        [self addChildViewController:mainNav];
    }
}

- (void)addChildViewController:(UIViewController *)customViewController image:(NSString *)image selectedImage:(NSString *)selectedImage{

    [[RAMAnimatedTabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [[RAMAnimatedTabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:RGB(253, 212, 49),NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    if (iOS7) {
        customViewController.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        customViewController.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }else{
        customViewController.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    }
}

@end
