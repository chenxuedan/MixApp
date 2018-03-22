//
//  IceDrinkViewController.m
//  MixApp
//
//  Created by 陈雪丹 on 2017/2/27.
//  Copyright © 2017年 cxd. All rights reserved.
//  http://cdnbbbd.shoujiduoduo.com/bb/video/10000048/343684003.mp4

#import "IceDrinkViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "CustomMoviePlayerViewController.h"
#import "CustomAVPlayerViewController.h"
#import "CustomAVPlayerVCController.h"
#import "PlayerMixViewController.h"

#define MovieURL @"http://cdnbbbd.shoujiduoduo.com/bb/video/10000048/343684003.mp4"

@interface IceDrinkViewController () <UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong)UIScrollView *backScrollView;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSArray *itemArray;
@property (nonatomic, strong)UIWebView *webView;
@property (nonatomic, assign)CGFloat height;

@end

@implementation IceDrinkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"冰饮";
    _itemArray = @[@"MPMoviePlayerViewController",@"MPMoviePlayerController",@"AVPlayer",@"AVPlayerViewController",@"AVPlayerView",@"闹着玩呢",@"闹着玩呢",@"闹着玩呢",@"闹着玩呢",@"闹着玩呢",@"闹着玩呢",@"闹着玩呢",@"闹着玩呢",@"闹着玩呢",@"闹着玩呢",@"闹着玩呢",@"闹着玩呢",@"闹着玩呢",@"闹着玩呢",@"闹着玩呢",@"闹着玩呢",@"闹着玩呢",@"闹着玩呢",@"闹着玩呢",@"闹着玩呢",@"闹着玩呢"];
    [self buildUI];
}

- (void)buildUI {
    [self.view addSubview:self.backScrollView];
    [self.backScrollView addSubview:self.tableView];
    [self.backScrollView addSubview:self.webView];
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
                            "</html>",@"<p><img style='width:100%' src='http://cf.52cold.com/Public/upload/goods/2017/02-09/589bd0296a328.jpg' style='float:none;' title='【情人节】兰芝新水酷特润精华露60ml-补水保湿-滋润-锁水-tmall_01.jpg'/></p><p><img style='width:100%' src='http://cf.52cold.com/Public/upload/goods/2017/02-09/589bd02996d2b.jpg' style='float:none;' title='【情人节】兰芝新水酷特润精华露60ml-补水保湿-滋润-锁水-tmall_02.jpg'/></p><p><img style='width:100%' src='http://cf.52cold.com/Public/upload/goods/2017/02-09/589bd029af3e1.jpg' style='float:none;' title='【情人节】兰芝新水酷特润精华露60ml-补水保湿-滋润-锁水-tmall_03.jpg'/></p><p><img style='width:100%' src='http://cf.52cold.com/Public/upload/goods/2017/02-09/589bd029d308b.jpg' style='float:none;' title='【情人节】兰芝新水酷特润精华露60ml-补水保湿-滋润-锁水-tmall_04.jpg'/></p><p><img style='width:100%' src='http://cf.52cold.com/Public/upload/goods/2017/02-09/589bd029ec484.jpg' style='float:none;' title='【情人节】兰芝新水酷特润精华露60ml-补水保湿-滋润-锁水-tmall_05.jpg'/></p><p><br/></p>"];
    
    [_webView loadHTMLString:htmlString baseURL:nil];

    __weak typeof(self) WeakSelf = self;
    //设置UITableView上拉加载
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //上拉，执行对应的操作---改变底层滚动视图的滚动到对应位置
        //设置动画效果
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            WeakSelf.backScrollView.contentOffset = CGPointMake(0, kScreenHeight - 64);
        } completion:^(BOOL finished) {
            //结束加载
            [WeakSelf.tableView.mj_footer endRefreshing];
        }];
    }];
    
    //设置UIWebView有下拉操作
    self.webView.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //下拉执行对应的操作
        WeakSelf.backScrollView.contentOffset = CGPointMake(0, 0);
        //结束加载
        [WeakSelf.webView.scrollView.mj_header endRefreshing];
    }];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
    NSLog(@"height     %f",height);
    _backScrollView.contentSize = CGSizeMake(kScreenWidth, (kScreenHeight - 64) + height);

    _webView.frame=CGRectMake(0, kScreenHeight - 64, kScreenWidth,height);
    NSLog(@"webView.height   %f",_webView.height);
    // 防止死循环
//    if (height != _height) {
//        _height = height;
//        if (_height > 0) {
//            // 刷新cell高度
//            _webView.height = _height;
//        }
//    }
}
//滚动到顶部
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    if (_webView.scrollView == scrollView) {
        self.backScrollView.contentOffset = CGPointMake(0, 0);
    }
}
//滚动到底部
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    __weak typeof(self) WeakSelf = self;
    if (_tableView == scrollView) {
        CGFloat height = scrollView.frame.size.height;
        CGFloat contentYOffset = scrollView.contentOffset.y;
        CGFloat distance = scrollView.contentSize.height - height;
        if (distance - contentYOffset <= 0) {
            [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                WeakSelf.backScrollView.contentOffset = CGPointMake(0, kScreenHeight - 64);
            } completion:^(BOOL finished) {
                //结束加载
            }];
        }
    }
}

#pragma mark - 懒加载
- (UIScrollView *)backScrollView {
    if (!_backScrollView) {
        _backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
        _backScrollView.backgroundColor = [UIColor greenSeaColor];
        _backScrollView.contentSize = CGSizeMake(kScreenWidth, (kScreenHeight - 64) * 2);
        //设置分页效果
        _backScrollView.pagingEnabled = YES;
        //禁止滚动
        _backScrollView.scrollEnabled = NO;
        _backScrollView.delegate = self;
    }
    return _backScrollView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    }
    return _tableView;
}

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, (kScreenHeight - 64), kScreenWidth, kScreenHeight - 64)];
//        _webView.delegate = self;
        _webView.scrollView.scrollEnabled = NO;
//        _webView.scrollView.delegate = self;
    }
    return _webView;
}



#pragma mark - 代理实现
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld %@",indexPath.row,_itemArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self buildMPMoviePlayerViewController];
    }else if (indexPath.row == 1) {
        CustomMoviePlayerViewController *playerVc = [[CustomMoviePlayerViewController alloc] init];
        [self.navigationController pushViewController:playerVc animated:YES];
    }else if (indexPath.row == 2) {
        CustomAVPlayerViewController *avplayerController = [[CustomAVPlayerViewController alloc] init];
        [self.navigationController pushViewController:avplayerController animated:YES];
    }else if (indexPath.row == 3) {
        CustomAVPlayerVCController *playerVc = [[CustomAVPlayerVCController alloc] init];
        [self.navigationController pushViewController:playerVc animated:YES];
    }else if (indexPath.row == 4) {
        PlayerMixViewController *playerVC = [[PlayerMixViewController alloc] init];
        [self.navigationController pushViewController:playerVC animated:YES];
    }
}

/*
 iOS播放视频文件一般使用 MPMoviePlayerViewController 和 MPMoviePlayerController。这两者的区别就是MPMoviePlayerViewController里面包含了一个MPMoviePlayerController
 */
/*
 MPMoviePlayerViewController 必须 presentMoviePlayerViewControllerAnimated方式添加，否则Done按钮是不会响应通知MPMoviePlayerPlaybackDidFinishNotification事件的；
 */
- (void)buildMPMoviePlayerViewController {
    MPMoviePlayerViewController *moviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:MovieURL]];
    [self presentMoviePlayerViewControllerAnimated:moviePlayer];
}




@end
