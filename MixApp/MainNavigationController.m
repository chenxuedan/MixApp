//
//  MainNavigationController.m
//  MixApp
//
//  Created by 陈雪丹 on 16/7/19.
//  Copyright © 2016年 cxd. All rights reserved.
//

#import "MainNavigationController.h"

@interface MainNavigationController ()

@property (nonatomic, strong)UIButton *backBtn;

@end

@implementation MainNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置title字体颜色
    self.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
    self.navigationBar.translucent = NO;
    self.navigationBar.barTintColor = RGB(253, 212, 49);
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"v2_goback"] forState:UIControlStateNormal];
        _backBtn.titleLabel.hidden = YES;
        [_backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        CGFloat btnW = kScreenHeight > 667 ? 50 : 44;
        _backBtn.frame = CGRectMake(0, 0, btnW, 40);
    }
    return _backBtn;
}

- (void)backBtnClick {
    [self popViewControllerAnimated:YES];
}

#pragma mark - 隐藏tabbar
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    }
    [super pushViewController:viewController animated:animated];
}

@end
