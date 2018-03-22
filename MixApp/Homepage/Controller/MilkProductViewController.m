//
//  MilkProductViewController.m
//  MixApp
//
//  Created by 陈雪丹 on 2017/3/29.
//  Copyright © 2017年 cxd. All rights reserved.
//

#import "MilkProductViewController.h"
#import "CycleScrollView.h"
#import "NewsDateNativeModel.h"
#import "CustomizeNavBar.h"

@interface MilkProductViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)CustomizeNavBar *naviBar;
@property (nonatomic, strong)CycleScrollView *cycleView;
@property (nonatomic, strong)NewsDateNativeModel *nativeModel;
@property (nonatomic, strong)UITableView *tableView;

@end

@implementation MilkProductViewController
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
    
    [CXDHttpOperation getRequestWithURL:@"http://news-at.zhihu.com/api/4/news/latest" parameters:nil success:^(id  _Nullable responseObject) {
        _nativeModel = [NewsDateNativeModel mj_objectWithKeyValues:responseObject];
        _cycleView.topStories = _nativeModel.top_stories;
        _cycleView.topViewBlock = ^(NewsTopStoriesModel *storyModel) {
            NSLog(@"%@",storyModel);
        };
    } failure:^(NSError * _Nullable error) {
        NSLog(@"%@  %@",error.localizedDescription,error.localizedFailureReason);
    }];
    [self buildUI];
}

- (void)buildUI {
    [self.view addSubview:self.tableView];
    [self.tableView addSubview:self.cycleView];
    [self.view addSubview:self.naviBar];
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.contentInset = UIEdgeInsetsMake(200, 0, 0, 0);
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    return _tableView;
}

- (CycleScrollView *)cycleView {
    if (!_cycleView) {
        _cycleView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, -200, kScreenWidth, 200)];

    }
    return _cycleView;
}

- (CustomizeNavBar *)naviBar {
    if (!_naviBar) {
        _naviBar = [[CustomizeNavBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
        _naviBar.barHidden = YES;
        _naviBar.title = @"乳品";
    }
    return _naviBar;
}

#pragma mark - 协议
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    cell.textLabel.text = [NSString stringWithFormat:@"我们都一样%ld",indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}
#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY < -200) {
        CGRect f = _cycleView.frame;
        f.origin.y = offsetY - 20;
        f.size.height = -offsetY + 20;
        _cycleView.frame = f;
    }

    CGFloat offset = 200 - 20;
    if (offsetY > -offset) {//取消隐藏
        _naviBar.barHidden = NO;
    }else {//隐藏
        _naviBar.barHidden = YES;
    }

//    if (offsetY <= 0 && offsetY >= -90) {
////        _naviBar.alpha = 0;
//        _naviBar.barHidden = YES;
//    }else if (offsetY <= 500) {
////        _naviBar.alpha = offsetY/200;
//        _naviBar.barHidden = NO;
//    }
}

@end
