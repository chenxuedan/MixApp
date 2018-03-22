//
//  AddressViewController.m
//  MixApp
//
//  Created by 陈雪丹 on 16/7/27.
//  Copyright © 2016年 cxd. All rights reserved.
//

#import "AddressViewController.h"
#import <GPUImage/GPUImage.h>
#import "GPUImageBeautifyFilter.h"


@interface AddressViewController ()

@property (nonatomic, strong)GPUImageVideoCamera *videoCamera;
@property (nonatomic, weak)GPUImageView *captureVideoPreview;

@end

@implementation AddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //创建视频源
    //SessionPreset:屏幕分辨率，AVCaptureSessionPresetHigh会自适应高分辨率
    //cameraPosition:摄像头方向
    //最好使用AVCaptureSessionPresetHigh，会自动识别，如果用太高分辨率，当前设备不支持会直接报错
    GPUImageVideoCamera *videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPresetHigh cameraPosition:AVCaptureDevicePositionFront];
    videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    _videoCamera = videoCamera;
    
    //创建最终预览View
    GPUImageView *captureVideoPreview = [[GPUImageView alloc] initWithFrame:self.view.bounds];
    [self.view insertSubview:captureVideoPreview atIndex:0];
    _captureVideoPreview = captureVideoPreview;
    
    //设置处理链
    [_videoCamera addTarget:_captureVideoPreview];
    
    //必须调用startCameraCapture,底层才会把采集到的视频源，渲染到GPUImageView中，就能显示了。
    //开始采集视频
    [_videoCamera startCameraCapture];
    
    //移除之前所有处理链
    [_videoCamera removeAllTargets];
    
    //创建美颜滤镜
    GPUImageBeautifyFilter *beautifyFilter = [[GPUImageBeautifyFilter alloc] init];
    
    //设置GPUImage处理链，从数据源=> 滤镜 => 最终页面效果
    [_videoCamera addTarget:beautifyFilter];
    [beautifyFilter addTarget:_captureVideoPreview];
    
}


@end
