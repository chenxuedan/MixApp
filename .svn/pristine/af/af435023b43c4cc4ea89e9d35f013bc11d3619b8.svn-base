//
//  TranslucentNavbar.m
//  MixApp
//
//  Created by 陈雪丹 on 16/7/26.
//  Copyright © 2016年 cxd. All rights reserved.
//

#import "TranslucentNavbar.h"

@interface TranslucentNavbar ()

@property (nonatomic, strong)UILabel *addressLabel;
@property (nonatomic, strong)UIButton *scanBtn;
@property (nonatomic, strong)UIButton *searchBtn;
@property (nonatomic, copy)ScanBtnClick scanBlock;
@property (nonatomic, copy)AddressClick addressBlock;
@property (nonatomic, copy)SearchBtnClick searchBlock;

@end

@implementation TranslucentNavbar

- (instancetype)initWithFrame:(CGRect)frame scanClick:(ScanBtnClick)scanBlock addressClick:(AddressClick)addressBlock searchClick:(SearchBtnClick)searchBlock {
    self = [super initWithFrame:frame];
    if (self) {
        self.scanBlock = scanBlock;
        self.addressBlock = addressBlock;
        self.searchBlock = searchBlock;
        [self buildCustomView];
    }
    return self;
}

- (void)buildCustomView {
    self.backgroundColor = [UIColor clearColor];
    _scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _scanBtn.frame = CGRectMake(20, 29, 30, 30);
    [_scanBtn setImage:[UIImage imageNamed:@"scanicon"] forState:UIControlStateNormal];
    [_scanBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    _scanBtn.backgroundColor = RGBA(0, 0, 0, 0.4);
    _scanBtn.layer.cornerRadius = 15.f;
    _scanBtn.layer.masksToBounds = YES;
    [_scanBtn addTarget:self action:@selector(scanBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_scanBtn];
    
    _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - 100, 29, 200, 30)];
    _addressLabel.text = @"配送至：人民大会堂";
    _addressLabel.textColor = [UIColor whiteColor];
    _addressLabel.layer.cornerRadius = 15.f;
    _addressLabel.layer.masksToBounds = YES;
    _addressLabel.textAlignment = NSTextAlignmentCenter;
    _addressLabel.backgroundColor = RGBA(0, 0, 0, 0.4);
    [self addSubview:_addressLabel];
    _addressLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addressClick)];
    [_addressLabel addGestureRecognizer:tap];
    
    _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _searchBtn.frame = CGRectMake(kScreenWidth - 50, 29, 30, 30);
    [_searchBtn setImage:[UIImage imageNamed:@"icon_search"] forState:UIControlStateNormal];
    [_searchBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    _searchBtn.backgroundColor = RGBA(0, 0, 0, 0.4);
    _searchBtn.layer.cornerRadius = 15.f;
    _searchBtn.layer.masksToBounds = YES;
    [self addSubview:_searchBtn];
    [_searchBtn addTarget:self action:@selector(searchBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)scanBtnDidClick {
    if (self.scanBlock) {
        self.scanBlock();
    }
}

- (void)addressClick {
    if (self.addressBlock) {
        self.addressBlock();
    }
}

- (void)searchBtnDidClick {
    if (self.searchBlock) {
        self.searchBlock();
    }
}

- (void)rebuildSubViews {
    [UIView animateWithDuration:0.25 animations:^{
        _addressLabel.backgroundColor = RGBA(0, 0, 0, 0);
    } completion:^(BOOL finished) {
        _addressLabel.backgroundColor = [UIColor clearColor];
        _addressLabel.textColor = [UIColor blackColor];
    }];
    [_scanBtn setImage:[UIImage imageNamed:@"icon_black_scancode"] forState:UIControlStateNormal];
    _scanBtn.backgroundColor = [UIColor clearColor];
    _searchBtn.backgroundColor = [UIColor clearColor];
}

- (void)restoreSubViews {
    _addressLabel.textColor = [UIColor whiteColor];
    _addressLabel.backgroundColor = RGBA(0, 0, 0, 0.4);
    [_scanBtn setImage:[UIImage imageNamed:@"scanicon"] forState:UIControlStateNormal];
    _scanBtn.backgroundColor = RGBA(0, 0, 0, 0.4);
    _searchBtn.backgroundColor = RGBA(0, 0, 0, 0.4);
}


@end
