//
//  HotViewCollectionCell.h
//  MixApp
//
//  Created by 陈雪丹 on 16/7/22.
//  Copyright © 2016年 cxd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^IconClickBlock)(NSInteger index);

@interface HotViewCollectionCell : UICollectionViewCell

- (void)buildContentViewWithArray:(NSArray *)modelArray iconClick:(IconClickBlock)block;

@end
