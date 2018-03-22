//
//  MARefreshHeader.m
//  MixApp
//
//  Created by 陈雪丹 on 16/7/26.
//  Copyright © 2016年 cxd. All rights reserved.
//

#import "MARefreshHeader.h"

@implementation MARefreshHeader

- (void)prepare {
    [super prepare];
    self.stateLabel.hidden = NO;
    self.lastUpdatedTimeLabel.hidden = YES;
    
    [self setImages:@[[UIImage imageNamed:@"v2_pullRefresh1"]] forState:MJRefreshStateIdle];
    [self setImages:@[[UIImage imageNamed:@"v2_pullRefresh2"]] forState:MJRefreshStatePulling];
    [self setImages:@[[UIImage imageNamed:@"v2_pullRefresh1"],[UIImage imageNamed:@"v2_pullRefresh2"]] forState:MJRefreshStateRefreshing];
    [self setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [self setTitle:@"松手开始刷新" forState:MJRefreshStatePulling];
    [self setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
}

@end
