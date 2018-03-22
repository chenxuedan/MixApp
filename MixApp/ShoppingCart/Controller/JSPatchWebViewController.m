//
//  JSPatchWebViewController.m
//  MixApp
//
//  Created by 陈雪丹 on 2017/7/3.
//  Copyright © 2017年 cxd. All rights reserved.
//

#import "JSPatchWebViewController.h"
#import "SSZipArchive.h"
#import "JPEngine.h"
#import "WebViewJavascriptBridge.h"

@interface JSPatchWebViewController () <UIWebViewDelegate,SSZipArchiveDelegate>

@property (nonatomic, strong)UIWebView *myWebView;
@property (nonatomic, strong)WebViewJavascriptBridge *bridge;

@end

@implementation JSPatchWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self buildUI];
}

- (void)buildUI {
    [self.view addSubview:self.myWebView];
    [self downFileFromServer];
    
    /**  JS 调用 OC
     registerHandler  要注册的事件名称(这里我们为loginFunc)
     handler  回调block函数  当后台触发这个事件的时候会执行block里面的代码
     @param data data 后台传过来的参数，例如用户名、密码等
     @param responseCallback responseCallback 给后台的回复
     */
    [_bridge registerHandler:@"loginFunc" handler:^(id data, WVJBResponseCallback responseCallback) {
        //具体的登录事件的实现，这里的login代表实现登录功能的一个OC函数
        //[self login];
        // responseCallback 给后台的回复
        responseCallback(@"Response from testObjcCallback");
        
    }];
    
    /*
     *  OC 调用 JS
     */
    //不需要传参数，不需要后台返回执行结果
    [_bridge callHandler:@"registerFunc"];
    
    //需要传参数，不需要从后台返回执行结果
    //callHandler 商定的事件名称，用来调用网页里面相应的事件实现
    //data id类型，相当于我们函数中的参数，向网页传递函数执行需要的参数
    [_bridge callHandler:@"registerFunc" data:@"name"];
    
    //需要传参数，需要从后台返回执行结果
    [_bridge callHandler:@"registerFunc" data:@"name" responseCallback:^(id responseData) {
        NSLog(@"后台执行完成后返回的数据");
    }];
}

- (void)downFileFromServer {
    //远程地址
    NSURL *URL = [NSURL URLWithString:@"http://cdnbbuc.shoujiduoduo.com/bb/games/package/30000006_v2.zip"];
    //默认配置
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    //AFN3.0+基于封住URLSession的句柄
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    //请求
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    //下载Task操作
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        //下载进度
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //- block的返回值, 要求返回一个URL, 返回的这个URL就是文件的位置的路径
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *path = [cachesPath stringByAppendingPathComponent:response.suggestedFilename];
        return [NSURL fileURLWithPath:path];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        //设置下载完成操作
        // filePath就是你下载文件的位置，你可以解压，也可以直接拿来使用
        NSString *imgFilePath = [filePath path];// 将NSURL转成NSString
        NSLog(@"imgFilePath = %@",imgFilePath);
        NSArray *documentArray =  NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *path = [[documentArray lastObject] stringByAppendingPathComponent:@"Preferences"];
        [self releaseZipFilesWithUnzipFileAtPath:imgFilePath Destination:path];
    }];
    [downloadTask resume];
}
//解压
- (void)releaseZipFilesWithUnzipFileAtPath:(NSString *)zipPath Destination:(NSString *)unzipPath{
    NSError *error;
    if ([SSZipArchive unzipFileAtPath:zipPath toDestination:unzipPath overwrite:YES password:nil error:&error delegate:self]) {
        NSLog(@"success");
        NSLog(@"unzipPath = %@",unzipPath);
//        NSString *sourcePath = [[NSBundle mainBundle] pathForResource:[unzipPath stringByAppendingPathComponent:@"game_main.js"] ofType:nil];
        [JPEngine startEngine];
        NSString *sourcePath = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Preferences/game_main.js"];
    
        NSLog(@"%@",sourcePath);
        NSString *script = [NSString stringWithContentsOfFile:sourcePath encoding:NSUTF8StringEncoding error:nil];

//        [JPEngine evaluateScript:script];
        NSLog(@"script   %@",script);
//        [self.myWebView loadHTMLString:script baseURL:nil];
        [self.myWebView stringByEvaluatingJavaScriptFromString:script];
    }else {
        NSLog(@"%@",error);
    }
}

#pragma mark - SSZipArchiveDelegate
- (void)zipArchiveWillUnzipArchiveAtPath:(NSString *)path zipInfo:(unz_global_info)zipInfo {
    NSLog(@"将要解压。");
}
- (void)zipArchiveDidUnzipArchiveAtPath:(NSString *)path zipInfo:(unz_global_info)zipInfo unzippedPath:(NSString *)unzippedPat uniqueId:(NSString *)uniqueId {
    NSLog(@"解压完成！");
}


#pragma mark - 懒加载
- (UIWebView *)myWebView {
    if (!_myWebView) {
        _myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
        _myWebView.delegate = self;
        //设置可以进行桥接
        [WebViewJavascriptBridge enableLogging];
        _bridge = [WebViewJavascriptBridge bridgeForWebView:_myWebView];
    }
    return _myWebView;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.myWebView stringByEvaluatingJavaScriptFromString:@"function()"];
}

@end
