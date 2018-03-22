//
//  ChooseTimeCollectionViewCell.m
//  MixApp
//
//  Created by 陈雪丹 on 2017/2/23.
//  Copyright © 2017年 cxd. All rights reserved.
//

#import "ChooseTimeCollectionViewCell.h"

@implementation ChooseTimeCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.timeLabel.layer.cornerRadius = 15.f;
    self.timeLabel.layer.masksToBounds = YES;
}

- (void)updateDay:(NSArray *)number outDate:(NSArray *)outdateArray selected:(NSInteger)judge currentDate:(NSArray *)newArray {
    NSInteger p_2 = [number componentsJoinedByString:@""].intValue;
    NSInteger p_1 = [newArray componentsJoinedByString:@""].intValue;
    
    if ([number[2] integerValue] > 0) {//从1开始的天数展示
        if (p_1 > p_2) {//处理今天之前的天数展示
            self.timeLabel.backgroundColor = [UIColor whiteColor];
            self.timeLabel.textColor = RGB(200, 200, 200);
            self.priceLabel.text = @"";
            self.userInteractionEnabled = NO;
        }else {//处理今天之后的天数展示情况
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"yyyy-MM-dd";
            NSDate *tempDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@-%@-%@",number[0],number[1],number[2]]];
            if ([[NSCalendar currentCalendar] isDateInWeekend:tempDate]) {
                self.timeLabel.textColor = [UIColor colorFromHexCode:@"#ff9300"];
            }else {
                self.timeLabel.textColor = [UIColor colorFromHexCode:@"#222222"];
            }
            self.timeLabel.backgroundColor = [UIColor whiteColor];
//            self.timeLabel.textColor = [UIColor colorFromHexCode:@"#1aa8ba"];
            self.priceLabel.text = @"";
            self.userInteractionEnabled = YES;
        }
    }else {//处理日历中的当月第一天的前几天的没有日期的数据展示
        self.timeLabel.backgroundColor = [UIColor whiteColor];
        self.timeLabel.textColor = [UIColor whiteColor];
        self.priceLabel.text = @"";
        self.userInteractionEnabled = NO;
    }
    
    if (outdateArray.count > 0) {
        NSInteger p_0 = [outdateArray componentsJoinedByString:@""].intValue;
        
        if (p_0 == p_2) {
            self.timeLabel.backgroundColor = [UIColor colorFromHexCode:@"#1aa8ba"];
            self.timeLabel.textColor = [UIColor whiteColor];
            self.priceLabel.text = @"出团";
        }
        
        if (judge > 0) {
            if (p_0 == judge && p_2 == judge) {
                self.timeLabel.backgroundColor = [UIColor colorFromHexCode:@"#1aa8ba"];
                self.timeLabel.textColor = [UIColor whiteColor];
                self.priceLabel.text = @"出团 返团";
            }else if (p_2 == judge) {
                self.timeLabel.backgroundColor = [UIColor colorFromHexCode:@"#1aa8ba"];
                self.timeLabel.textColor = [UIColor whiteColor];
                self.priceLabel.text = @"返团";
            }
            
            if (p_2 < judge && p_2 > p_0) {
                self.timeLabel.backgroundColor = [UIColor whiteColor];
                self.timeLabel.textColor = [UIColor colorFromHexCode:@"#1aa8ba"];
                self.priceLabel.text = @"";
            }
        }
    }
    
    if ([number[2] integerValue] >= 10) {//展示两位数的天数
        self.timeLabel.text = [NSString stringWithFormat:@"%@",number[2]];
    }else {//展示一位数的天数，并将前面的0去掉
        NSString *str = [NSString stringWithFormat:@"%@",number[2]];
        self.timeLabel.text = [str stringByReplacingOccurrencesOfString:@"0" withString:@""];
    }
//    self.currentArray = number;
}


@end
