//
//  CategoryCell.m
//  MixApp
//
//  Created by 陈雪丹 on 16/7/27.
//  Copyright © 2016年 cxd. All rights reserved.
//

#import "CategoryCell.h"

@interface CategoryCell ()

@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UIImageView *backImageView;
@property (nonatomic, strong)UIView *tipView;
@property (nonatomic, strong)UIView *lineView;

@end

@implementation CategoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self buildCustomView];
    }
    return self;
}

- (void)buildCustomView {
    [self.contentView addSubview:self.backImageView];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.tipView];
    [self.contentView addSubview:self.nameLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.nameLabel.highlighted = selected;
    self.backImageView.highlighted = selected;
    self.tipView.hidden = !selected;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.nameLabel.frame = self.bounds;
    self.backImageView.frame = CGRectMake(0, 0, self.width, self.height);
    self.tipView.frame = CGRectMake(0, self.height * 0.1, 5, self.height * 0.8);
    self.lineView.frame = CGRectMake(0, self.height - 1, self.width, 1);
}

- (void)buildContentViewWithModel:(CategoriesModel *)model {
    self.nameLabel.text = model.name;
}

#pragma mark - 懒加载
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = RGB(130, 130, 130);
        _nameLabel.highlightedTextColor = [UIColor blackColor];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont systemFontOfSize:14];
    }
    return _nameLabel;
}

- (UIImageView *)backImageView {
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] init];
        _backImageView.image = [UIImage imageNamed:@"llll"];
        _backImageView.highlightedImage = [UIImage imageNamed:@"kkkkkkk"];
    }
    return _backImageView;
}

- (UIView *)tipView {
    if (!_tipView) {
        _tipView = [[UIView alloc] init];
        _tipView.backgroundColor = RGB(253, 212, 49);
    }
    return _tipView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = RGB(225, 225, 225);
    }
    return _lineView;
}


@end
