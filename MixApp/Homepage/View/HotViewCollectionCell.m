//
//  HotViewCollectionCell.m
//  MixApp
//
//  Created by 陈雪丹 on 16/7/22.
//  Copyright © 2016年 cxd. All rights reserved.
//

#import "HotViewCollectionCell.h"
#import "IconTextView.h"
#import "ActRowsModel.h"

#define IconW (kScreenWidth - 2 * LeftDistance) * 0.25
#define IconH 80.f

@interface HotViewCollectionCell ()

@property (nonatomic, assign)NSInteger rows;
@property (nonatomic, copy)IconClickBlock block;

@end

@implementation HotViewCollectionCell

- (void)buildContentViewWithArray:(NSArray *)modelArray iconClick:(IconClickBlock)block {
    if (self.block) {
        return;
    }
    self.block = block;
    CGFloat iconX = 0;
    CGFloat iconY = 0;
    for (NSInteger index = 0; index < modelArray.count; index++) {
        ActRowsModel *model = modelArray[index];
        iconX = (index % 4) * IconW + LeftDistance;
        iconY = IconH * (index / 4);
        IconTextView *icon = [[IconTextView alloc] initWithFrame:CGRectMake(iconX, iconY, IconW, IconH) titleName:model.name imageName:model.topimg placeholderImage:[UIImage imageNamed:@"icon_icons_holder"]];
        icon.tag = index;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconClick:)];
        [icon addGestureRecognizer:tap];
        [self addSubview:icon];
    }
    if (modelArray.count % 4 != 0) {
        self.rows = modelArray.count / 4 + 1;
    }else {
        self.rows = modelArray.count / 4;
    }
}

- (void)iconClick:(UITapGestureRecognizer *)gesture {
    if (self.block) {
        self.block(gesture.view.tag);
    }
}

@end
