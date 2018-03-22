//
//  ImageScrollCell.m
//  MixApp
//
//  Created by 陈雪丹 on 16/7/25.
//  Copyright © 2016年 cxd. All rights reserved.
//

#import "ImageScrollCell.h"
#import "ActRowsModel.h"

@interface ImageScrollCell ()

//@property (nonatomic, strong)

@end

@implementation ImageScrollCell

- (void)buildContentViewWithImageModel:(NSArray *)imageArray {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 150)];
    scrollView.showsHorizontalScrollIndicator = NO;
    for (NSInteger index; index < imageArray.count; index++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(121 * index, 0, 120, 150)];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(imageView.frame), 0, 1, 150)];
        view.backgroundColor = [UIColor colorFromHexCode:@"#f5f5f5"];
        ActRowsModel *rowModel = imageArray[index];
        [imageView sd_setImageWithURL:[NSURL URLWithString:rowModel.topimg]];
        [scrollView addSubview:view];
        [scrollView addSubview:imageView];
    }
    scrollView.contentSize = CGSizeMake(121 * imageArray.count, 150);
    [self.contentView addSubview:scrollView];
}

@end
