//
//  TopBannerView.h
//  MixApp
//
//  Created by 陈雪丹 on 2017/3/10.
//  Copyright © 2017年 cxd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsTopStoriesModel.h"

@interface TopBannerView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

//数据源
@property (nonatomic, strong)NewsTopStoriesModel *dataModel;

@end
