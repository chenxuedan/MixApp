//
//  TimerCollectionReusableView.m
//  MixApp
//
//  Created by 陈雪丹 on 2017/2/23.
//  Copyright © 2017年 cxd. All rights reserved.
//

#import "TimerCollectionReusableView.h"

@implementation TimerCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)updateTimer:(NSArray *)array {
    if ([array[1] integerValue] >= 10) {//展示两位数的天数
        self.dateLabel.text = [NSString stringWithFormat:@"%@年%@月",array[0],array[1]];
    }else {//展示一位数的天数，并将前面的0去掉
        NSString *str = [NSString stringWithFormat:@"%@",array[1]];
        self.dateLabel.text = [NSString stringWithFormat:@"%@年%@月",array[0],[str stringByReplacingOccurrencesOfString:@"0" withString:@""]];
    }
}

@end
