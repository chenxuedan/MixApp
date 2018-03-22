//
//  CXDAssetModel.m
//  MixApp
//
//  Created by 陈雪丹 on 2017/4/7.
//  Copyright © 2017年 cxd. All rights reserved.
//

#import "CXDAssetModel.h"

@implementation CXDAssetModel

+ (instancetype)modelWithAsset:(id)asset {
    CXDAssetModel *model = [[CXDAssetModel alloc] init];
    model.asset = asset;
    model.isSelected = NO;
    return model;
}

+ (instancetype)modelWithAsset:(id)asset timeLength:(NSString *)timeLength {
    CXDAssetModel *model = [self modelWithAsset:asset];
    model.timeLength = timeLength;
    return model;
}


@end
