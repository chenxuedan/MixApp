//
//  CustomWeekdayTopView.m
//  MixApp
//
//  Created by 陈雪丹 on 2017/2/24.
//  Copyright © 2017年 cxd. All rights reserved.
//

#import "CustomWeekdayTopView.h"

@interface CustomWeekdayTopView ()

@end

@implementation CustomWeekdayTopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self buildUI];
    }
    return self;
}

- (void)buildUI {
    NSArray *weekArray = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    CGFloat width = (kScreenWidth - 20) / 7;
    for (int i = 0; i < 7; i++) {
        UILabel *weekLabel = [[UILabel alloc] initWithFrame:CGRectMake(LeftDistance + width * i, 5, width, 20)];
        weekLabel.text = weekArray[i];
        weekLabel.textAlignment = NSTextAlignmentCenter;
        weekLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.f];
        if (i == 0 || i == 6) {
            weekLabel.textColor = [UIColor colorFromHexCode:@"#ff9300"];
        }else {
            weekLabel.textColor = [UIColor colorFromHexCode:@"222222"];
        }
        [self addSubview:weekLabel];
    }
}

@end
