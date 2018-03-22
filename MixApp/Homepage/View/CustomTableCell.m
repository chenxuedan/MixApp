//
//  CustomTableCell.m
//  MixApp
//
//  Created by 陈雪丹 on 2017/6/5.
//  Copyright © 2017年 cxd. All rights reserved.
//

#import "CustomTableCell.h"

@implementation CustomTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
