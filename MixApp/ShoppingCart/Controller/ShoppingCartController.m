//
//  ShoppingCartController.m
//  MixApp
//
//  Created by 陈雪丹 on 16/7/19.
//  Copyright © 2016年 cxd. All rights reserved.
//

#import "ShoppingCartController.h"
#import "MainTabBarController.h"
#import "ConnectTipView.h"
#import "CycleScrollView.h"
#import "JSPatchWebViewController.h"

@interface ShoppingCartController () 

@property (nonatomic, strong)ConnectTipView *tipView;
@property (nonatomic, strong)CycleScrollView *bannerView;

@property (nonatomic, strong)UIImageView *imageView;

@end

@implementation ShoppingCartController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 30, kScreenWidth, 200)];
    [_imageView setImage:[UIImage imageNamed:@"guide_40_1"]];
    [self.view addSubview:_imageView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(40, 250, 60, 36);
    [btn setTitle:@"转换" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor greenSeaColor]];
    [btn addTarget:self action:@selector(btnDidClicekd:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    UIButton *downBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    downBtn.frame = CGRectMake(60, 300, 60, 36);
    [downBtn setTitle:@"下载" forState:UIControlStateNormal];
    [downBtn setBackgroundColor:[UIColor carrotColor]];
    [downBtn addTarget:self action:@selector(downFileFromServer) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:downBtn];
}

- (void)downFileFromServer {
    JSPatchWebViewController *jsVC = [[JSPatchWebViewController alloc] init];
    [self.navigationController pushViewController:jsVC animated:YES];
}


- (void)btnDidClicekd:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        [_imageView setImage:[self systemImageToGrayImage:[UIImage imageNamed:@"guide_40_1"]]
         ];
    }else {
        [_imageView setImage:[UIImage imageNamed:@"guide_40_1"]];
    }
}
//图像灰度转换   QQ的在线和离线状态
- (UIImage *)systemImageToGrayImage:(UIImage *)image {
    //第一步：创建颜色空间（说白了就是开辟一块颜色内存空间）
    //图片灰度处理（创建灰度空间）
    CGColorSpaceRef colorRef = CGColorSpaceCreateDeviceGray();
    
    //第二步：颜色空间上下文（保存图像数据信息）
    //参数一：指向这块内存区域地址（内存地址）
    //参数二：图片宽
    //参数三：图片高
    //参数四:像素位数(颜色空间，例如：32位像素格式和RGB颜色空间8位)
    //参数五：图片每一行占用内存比特数
    //参数六：颜色空间
    //参数七：图片是否包含A通道（ARGB四个通道）
    CGContextRef context = CGBitmapContextCreate(nil, image.size.width, image.size.height, 8, 0, colorRef, kCGImageAlphaNone);
    //释放内存
    CGColorSpaceRelease(colorRef);
    if (context == nil) {
        return nil;
    }
    
    //第三步：渲染图片（绘制图片）
    //参数一：上下文
    //参数二:渲染区域
    //参数三：源文件（原图片）(说白了现在是一个C/C++内存区域)
    CGContextDrawImage(context, CGRectMake(0, 0, image.size.width, image.size.height), image.CGImage);
    //第四步：将绘制颜色空间转成CGImage(转成认识图片类型)
    CGImageRef grayImageRef = CGBitmapContextCreateImage(context);
    //第五步：将C/C++图片CGImage转成面向对象的UIImage(转成iOS程序认识图片类型)
    UIImage *destImage = [UIImage imageWithCGImage:grayImageRef];
    //释放内存
    CGContextRelease(context);
    CGImageRelease(grayImageRef);
    return destImage;
}



- (CycleScrollView *)bannerView {
    if (!_bannerView) {
        _bannerView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        
    }
    return _bannerView;
}


- (void)buildEmptyUI {
    [self.view addSubview:self.tipView];
}

#pragma mark -懒加载
- (ConnectTipView *)tipView {
    if (!_tipView) {
        _tipView = [[ConnectTipView alloc] initWithFrame:CGRectMake(0, kScreenHeight / 2 - 300, kScreenWidth, 600) imageName:@"v2_shop_empty" title:@"亲,购物车空空的耶~赶紧挑好吃的吧" buttonTitle:@"去逛逛" buttonBlock:^{
            MainTabBarController *tabBarController = (MainTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            [tabBarController setSelectIndexFrom:3 to:0];
        }];
    }
    return _tipView;
}


@end
