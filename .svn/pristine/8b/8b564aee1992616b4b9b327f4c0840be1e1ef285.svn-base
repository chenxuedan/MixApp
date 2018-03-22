//
//  NSString+Extension.m
//  MixApp
//
//  Created by 陈雪丹 on 16/7/28.
//  Copyright © 2016年 cxd. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

- (NSString *)cleanDecimalPointZear {
    NSString *newStr = self;
    NSString *s;
    NSInteger offset = newStr.length - 1;
    while (offset > 0) {
        s = [newStr substringWithRange:NSMakeRange(offset, 1)];
        if ([s isEqualToString:@"0"] || [s isEqualToString:@"."]) {
            offset -= 1;
        }else {
            break;
        }
    }
    return [newStr substringToIndex:offset + 1];
}

@end
