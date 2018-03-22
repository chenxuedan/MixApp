//
//  TranslucentNavbar.h
//  MixApp
//
//  Created by 陈雪丹 on 16/7/26.
//  Copyright © 2016年 cxd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ScanBtnClick)(void);
typedef void(^AddressClick)(void);
typedef void(^SearchBtnClick)(void);

@interface TranslucentNavbar : UIView

- (instancetype)initWithFrame:(CGRect)frame scanClick:(ScanBtnClick)scanBlock addressClick:(AddressClick)addressBlock searchClick:(SearchBtnClick)searchBlock;
- (void)rebuildSubViews;
- (void)restoreSubViews;

@end
