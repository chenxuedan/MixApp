//
//  ChooseTimeCollectionViewCell.h
//  MixApp
//
//  Created by 陈雪丹 on 2017/2/23.
//  Copyright © 2017年 cxd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseTimeCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

/**
 *  更新布局
 *
 *  @param number   cell代表时间
 *  @param judge    选择出团时间
 *  @param judge    选择反团时间
 *  @param newArray 出团时间
 */
- (void)updateDay:(NSArray*)number outDate:(NSArray*)outdateArray selected:(NSInteger)judge currentDate:(NSArray*)newArray;

@end
