//
//  CycleScrollView.h
//  MixApp
//
//  Created by 陈雪丹 on 2017/3/9.
//  Copyright © 2017年 cxd. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat const animationDuration = 5.0;


typedef void(^TouchUpTopView)(id topStory);

@interface CycleScrollView : UIView

@property (nonatomic, copy) TouchUpTopView topViewBlock;
@property (nonatomic, strong)NSArray *topStories;

@end
