//
//  CXDAlbumModel.h
//  MixApp
//
//  Created by 陈雪丹 on 2017/4/7.
//  Copyright © 2017年 cxd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CXDAlbumModel : NSObject
//the album name
@property (nonatomic, copy)NSString *name;
// count of photos the album contain
@property (nonatomic, assign)NSInteger count;

@property (nonatomic, strong)id result;
@property (nonatomic, strong)NSArray *models;
@property (nonatomic, strong)NSArray *selectedModels;
@property (nonatomic, assign)NSUInteger selectedCount;

@end
