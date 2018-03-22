//
//  SupermarketHeadView.m
//  MixApp
//
//  Created by 陈雪丹 on 16/8/1.
//  Copyright © 2016年 cxd. All rights reserved.
//

#import "SupermarketHeadView.h"

@interface SupermarketHeadView ()


@end

@implementation SupermarketHeadView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundView = [[UIView alloc] init];
        self.backgroundView.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = RGBA(240, 240, 240, 0.8);
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _titleLabel.frame = CGRectMake(LeftDistance, 0, self.width - LeftDistance, self.height);
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textColor = RGB(100, 100, 100);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

@end
