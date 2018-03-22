//
//  BannerCollectionCell.m
//  MixApp
//
//  Created by 陈雪丹 on 16/7/22.
//  Copyright © 2016年 cxd. All rights reserved.
//

#import "BannerCollectionCell.h"
#import "HYBLoopScrollView.h"
#import "ActRowsModel.h"

@interface BannerCollectionCell ()

@property (nonatomic, strong)HYBLoopScrollView *loopScrollView;
@property (nonatomic, strong)NSMutableArray *imageArray;

@end

@implementation BannerCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageArray = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (void)buildContentViewWithArray:(NSArray *)imageArray {
    if (_loopScrollView) {
        return;
    }
    if (self.imageArray) {
        [self.imageArray removeAllObjects];
    }
    for (NSInteger index = 0; index < imageArray.count; index++) {
        ActRowsModel *model = imageArray[index];
        NSLog(@"topimg   %@",model.topimg);
        [self.imageArray addObject:model.topimg];
    }
    _loopScrollView = [HYBLoopScrollView loopScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, 160) imageUrls:self.imageArray timeInterval:3.f didSelect:^(NSInteger atIndex) {
        
    } didScroll:^(NSInteger toIndex) {
        
    }];
    _loopScrollView.backgroundColor = [UIColor whiteColor];
    _loopScrollView.shouldAutoClipImageToViewSize = NO;
    _loopScrollView.alignment = kPageControlAlignRight;
    _loopScrollView.pageControl.currentPageIndicatorTintColor = RGB(253, 212, 49);
    _loopScrollView.pageControl.pageIndicatorTintColor = [UIColor colorFromHexCode:@"#f5f5f5"];
    [self.contentView addSubview:_loopScrollView];
}

@end
