//
//  TopBannerView.m
//  MixApp
//
//  Created by 陈雪丹 on 2017/3/10.
//  Copyright © 2017年 cxd. All rights reserved.
//

#import "TopBannerView.h"

@interface TopBannerView ()


@end

@implementation TopBannerView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"TopBannerView" owner:self options:nil] lastObject];
        self.frame = frame;
    }
    return self;
}

- (void)setDataModel:(NewsTopStoriesModel *)dataModel {
    if (_dataModel != dataModel) {
        _dataModel = dataModel;
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:_dataModel.image]];
        self.titleLabel.text = _dataModel.title;
    }
}


@end
