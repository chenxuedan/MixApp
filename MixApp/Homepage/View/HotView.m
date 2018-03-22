//
//  HotView.m
//  MixApp
//
//  Created by 陈雪丹 on 16/7/22.
//  Copyright © 2016年 cxd. All rights reserved.
//

#import "HotView.h"
#import "IconTextView.h"

#define IconW (kScreenWidth - 2 * LeftDistance) * 0.25
#define IconH 80.f

@interface HotView ()

@property (nonatomic, strong)NSArray *imageData;
@property (nonatomic, assign)NSInteger rows;
@property (nonatomic, copy)IconClickBlock block;

@end

@implementation HotView

- (instancetype)initWithFrame:(CGRect)frame iconClick:(IconClickBlock)block {
    self = [super initWithFrame:frame];
    if (self) {
        self.block = block;
    }
    return self;
}

- (void)createCustomView {
    CGFloat iconX = 0;
    CGFloat iconY = 0;
    for (NSInteger index = 0; index < self.imageData.count; index++) {
        iconX = (index % 4) * IconW + LeftDistance;
        iconY = IconH * (index / 4);
        IconTextView *icon = [[IconTextView alloc] initWithFrame:CGRectMake(iconX, iconY, IconW, IconH) titleName:@"" imageName:@"" placeholderImage:[UIImage imageNamed:@""]];
        icon.tag = index;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconClick:)];
        [icon addGestureRecognizer:tap];
        [self addSubview:icon];
    }
}

- (void)iconClick:(UITapGestureRecognizer *)gesture {
    if (self.block) {
        self.block(gesture.view.tag);
    }
}

@end
