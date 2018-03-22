//
//  ActRowsModel.h
//  MixApp
//
//  Created by 陈雪丹 on 16/7/22.
//  Copyright © 2016年 cxd. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "CategoryModel.h"

@protocol ActRowsModel <NSObject>

@end

@interface ActRowsModel : JSONModel

@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *topimg;
@property (nonatomic, strong)CategoryModel <Optional>*category_detail;


@end
