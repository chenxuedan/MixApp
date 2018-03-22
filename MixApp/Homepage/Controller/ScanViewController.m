//
//  ScanViewController.m
//  MixApp
//
//  Created by 陈雪丹 on 16/7/27.
//  Copyright © 2016年 cxd. All rights reserved.
//

#import "ScanViewController.h"

@interface ScanViewController ()

@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"打印字符个数   %d",[self convertToInt:@"stgb  db"]);
    NSLog(@"%ld",[@"stgb  db" length]);
    
}

//- (void)dealloc {
//    __weak typeof(self) WeakSelf = self;
//    NSLog(@"%@",WeakSelf);
//}

- (int)convertToInt:(NSString *)strTemp {
    int strLength = 0;
    char *p = (char *)[strTemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i = 0; i < [strTemp length]; i++) {
        if (*p) {
            p++;
            strLength++;
        }else {
            p++;
        }
    }
    return strLength;
}



@end
