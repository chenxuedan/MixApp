//
//  IconTextView.m
//  MixApp
//
//  Created by 陈雪丹 on 16/7/22.
//  Copyright © 2016年 cxd. All rights reserved.
//

#import "IconTextView.h"

@interface IconTextView ()

@property (nonatomic, strong)UIImageView *imageView;
@property (nonatomic, strong)UILabel *textLabel;
@property (nonatomic, strong)UIImage *placeholderImage;
@property (nonatomic, copy)NSString *titleName;
@property (nonatomic, copy)NSString *imageName;

@end

@implementation IconTextView

- (instancetype)initWithFrame:(CGRect)frame titleName:(NSString *)title imageName:(NSString *)imageName placeholderImage:(UIImage *)placeholderImage {
    self = [super initWithFrame:frame];
    if (self) {
        self.titleName = title;
        self.imageName = imageName;
        self.placeholderImage = placeholderImage;
        [self createCustomView];
    }
    return self;
}

- (void)createCustomView {
    if (_imageView) {
        return;
    }
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, self.width - 10, self.height - 30)];
    _imageView.userInteractionEnabled = NO;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:_imageName] placeholderImage:_placeholderImage];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_imageView];
    
    _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, self.height - 25, _imageView.width, 20)];
    _textLabel.text = self.titleName;
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.font = [UIFont systemFontOfSize:12];
    _textLabel.textColor = [UIColor blackColor];
    _textLabel.userInteractionEnabled = false;
    [self addSubview:_textLabel];
}


@end
