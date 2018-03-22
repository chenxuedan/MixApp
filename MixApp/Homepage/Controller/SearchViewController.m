//
//  SearchViewController.m
//  MixApp
//
//  Created by 陈雪丹 on 16/7/27.
//  Copyright © 2016年 cxd. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()

@property (nonatomic, strong)NSArray *titleArray;
@property (nonatomic, assign)CGFloat lastX;
@property (nonatomic, assign)CGFloat lastY;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initData {
    _lastX = 0;
    _lastY = 100;
    _titleArray = @[@"年货大集",@"酸奶",@"水",@"车厘子",@"洽洽瓜子",@"维他",@"香烟",@"周黑鸭",@"草莓",@"星巴克",@"卤味",@"星巴克咖啡"];
}

- (void)createView {
    CGFloat btnW = 0;
    CGFloat btnH = 30;
    CGFloat addW = 30;
    CGFloat marginX = 10;
    CGFloat marginY = 10;
    for (NSInteger index = 0; index < _titleArray.count; index++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:_titleArray[index] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn.titleLabel sizeToFit];
        btn.backgroundColor = [UIColor whiteColor];
        btn.layer.cornerRadius = 15;
        btn.layer.masksToBounds = YES;
        btn.layer.borderWidth = 0.5;
        btn.layer.borderColor = RGB(200, 200, 200).CGColor;
        [btn addTarget:self action:@selector(btnDidClick:) forControlEvents:UIControlEventTouchUpInside];
        
        btnW = btn.titleLabel.width + addW;
        if (kScreenWidth - _lastX > btnW) {
            btn.frame = CGRectMake(_lastX , _lastY, btnW, btnH);
        }else {
            btn.frame = CGRectMake(0, _lastY + marginY + btnH, btnW, btnH);
        }
        _lastX = CGRectGetMaxX(btn.frame) + marginX;
        _lastY = btn.y;
        [self.view addSubview:btn];
    }
}

- (void)btnDidClick:(UIButton *)sender {
    
}


@end
