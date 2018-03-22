//
//  ActInfoModel.h
//  MixApp
//
//  Created by 陈雪丹 on 16/7/22.
//  Copyright © 2016年 cxd. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "ActRowsModel.h"

@interface ActInfoModel : JSONModel

@property (nonatomic, strong)NSArray <ActRowsModel>*act_rows;
@property (nonatomic, copy)NSString *type;
@property (nonatomic, copy)NSString *sort;

@end
