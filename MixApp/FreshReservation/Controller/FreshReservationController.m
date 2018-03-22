//
//  FreshReservationController.m
//  MixApp
//
//  Created by 陈雪丹 on 16/7/22.
//  Copyright © 2016年 cxd. All rights reserved.
//

#import "FreshReservationController.h"

@interface FreshReservationController () <UIWebViewDelegate>

@property (nonatomic, strong)UIWebView *webView;


@end

@implementation FreshReservationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 49)];
    _webView.delegate  = self;
    _webView.scrollView.bounces = NO;
    [CXDHttpOperation postRequestWithUrl:@"http://liveworking.eptc.org.cn/topic_details" parameters:@{@"users_id":@"12",@"id":@"22"} success:^(id  _Nullable responseObject) {
        NSString *htmlString = [NSString stringWithFormat:@"<html> \n"
                                "<head> \n"
                                "<style type=\"text/css\"> \n"
                                "body {font-size:15px;}\n"
                                "</style> \n"
                                "</head> \n"
                                "<body>"
                                "<script type='text/javascript'>"
                                "window.onload = function(){\n"
                                "var $img = document.getElementsByTagName('img');\n"
                                "for(var p in  $img){\n"
                                " $img[p].style.width = '100%%';\n"
                                "$img[p].style.height ='auto'\n"
                                "}\n"
                                "}"
                                "</script>%@"
                                "</body>"
                                "</html>",[responseObject objectForKey:@"content"]];
        NSMutableString *string = [NSMutableString stringWithString:htmlString];
        //是视频适应屏幕大小
        [string appendString:[NSString stringWithFormat:@"<meta name=\"viewport\" content=\" initial-scale=%f, minimum-scale=0.1, maximum-scale=1.0, user-scalable=no\"><style>img{max-width:%f !important;}p{font-size:15px !important;}</style></head>", (kScreenWidth - 20) / 420, 420.0]];
        [self.webView loadHTMLString:string baseURL:nil];
        [self.view addSubview:self.webView];
    } failure:^(NSError * _Nullable error) {
        
    }];
    /**
     * str就是后台返回的富文本string
     * " $img[p].style.width = '100%%';\n"--->就是设置图片的宽度的
     * 100%代表正好为屏幕的宽度
     */
}

//将 &lt 等类似的字符转化为HTML中的“<”等
- (NSString *)htmlEntityDecode:(NSString *)string {
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"]; // Do this last so that, e.g. @"&amp;lt;" goes to @"&lt;" not @"<"
    return string;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *js = @"function imgAutoFit() { \
    var imgs = document.getElementsByTagName('img'); \
    for (var i = 0; i < imgs.length; ++i) {\
    var img = imgs[i];   \
    img.style.maxWidth = %f;   \
    } \
    }";
    js = [NSString stringWithFormat:js, [UIScreen mainScreen].bounds.size.width];
    
    [webView stringByEvaluatingJavaScriptFromString:js];
    [webView stringByEvaluatingJavaScriptFromString:@"imgAutoFit()"];
    
    // 禁用用户选择
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    // 禁用长按弹出框
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
}

@end
