//
//  CXDAssetModel.h
//  MixApp
//
//  Created by 陈雪丹 on 2017/4/7.
//  Copyright © 2017年 cxd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CXDAssetModel : NSObject

@property (nonatomic, strong)id asset;
@property (nonatomic, assign)BOOL isSelected;

@property (nonatomic, copy)NSString *timeLength;

+ (instancetype)modelWithAsset:(id)asset ;

+ (instancetype)modelWithAsset:(id)asset timeLength:(NSString *)timeLength;

@end
