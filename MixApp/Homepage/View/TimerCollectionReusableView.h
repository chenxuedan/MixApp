//
//  TimerCollectionReusableView.h
//  MixApp
//
//  Created by 陈雪丹 on 2017/2/23.
//  Copyright © 2017年 cxd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimerCollectionReusableView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

- (void)updateTimer:(NSArray *)array;

@end
