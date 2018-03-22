//
//  FreshFruitViewController.m
//  MixApp
//
//  Created by 陈雪丹 on 2017/3/29.
//  Copyright © 2017年 cxd. All rights reserved.
//

#import "FreshFruitViewController.h"
#import "CustomizeNavBar.h"
#import "BLRColorComponents.h"
#import "UIImage+ImageEffects.h"

@interface FreshFruitViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)CustomizeNavBar *naviBar;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UIImageView *expandZoomImageView;

@end

@implementation FreshFruitViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self buildUI];
}

- (void)buildUI {
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.naviBar];

    [self.tableView addSubview:self.expandZoomImageView];
    
    UIColor *tintColor = [BLRColorComponents darkEffect].tintColor;
    NSURL *imgURL = [NSURL URLWithString:@"http://img3.doubanio.com/view/movie_poster_cover/spst/public/p2436030518.jpg"];
    [[SDWebImageManager sharedManager] downloadImageWithURL:imgURL options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        //处理下载进度
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        [_expandZoomImageView setImage:[image applyBlurWithCrop:CGRectMake(0, 0, kScreenWidth, 250) resize:CGSizeMake(kScreenWidth, 250) blurRadius:[BLRColorComponents darkEffect].radius tintColor:tintColor saturationDeltaFactor:[BLRColorComponents darkEffect].saturationDeltaFactor maskImage:nil]];
    }];
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.contentInset = UIEdgeInsetsMake(250, 0, 0, 0);
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    return _tableView;
}

- (CustomizeNavBar *)naviBar {
    if (!_naviBar) {
        _naviBar = [[CustomizeNavBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
        _naviBar.barHidden = YES;
        _naviBar.title = @"水果";
    }
    return _naviBar;
}

- (UIImageView *)expandZoomImageView {
    if (!_expandZoomImageView) {
        _expandZoomImageView = [[UIImageView alloc] init];
        _expandZoomImageView.frame = CGRectMake(0, -250, kScreenWidth, 250);
        _expandZoomImageView.userInteractionEnabled = YES;
        _expandZoomImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _expandZoomImageView;
}

#pragma mark - 协议
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.textLabel.text = @"闹着玩";
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

#pragma mark - scroll
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat yOffset = scrollView.contentOffset.y;
    if (yOffset < -250) {
        CGRect f = _expandZoomImageView.frame;
        f.origin.y = yOffset - 20;
        f.size.height = -yOffset + 20;
        _expandZoomImageView.frame = f;
    }
    
    CGFloat offset = 250 - 20;
    if (yOffset > -offset) {//取消隐藏
        _naviBar.barHidden = NO;
    }else {//隐藏
        _naviBar.barHidden = YES;
    }
}

@end
