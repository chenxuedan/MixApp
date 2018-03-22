//
//  HomePageController.m
//  MixApp
//
//  Created by 陈雪丹 on 16/7/19.
//  Copyright © 2016年 cxd. All rights reserved.
//

#import "HomePageController.h"
#import "ConnectTipView.h"
#import "ActInfoModel.h"
#import "BannerCollectionCell.h"
#import "HotViewCollectionCell.h"
#import "ImageScrollCell.h"
#import "SalesPromotionCell.h"
#import "ActRowsModel.h"
#import "PreferenceProductCell.h"
#import "LotteryViewController.h"
#import "MARefreshHeader.h"
#import "TranslucentNavbar.h"
#import "ScanViewController.h"
#import "SearchViewController.h"
#import "AddressViewController.h"
#import "GetARedEnvelopController.h"
#import "BeeCliquesViewController.h"
#import "IceDrinkViewController.h"
#import "FreshFruitViewController.h"
#import "MilkProductViewController.h"
#import "SnacksViewController.h"
#import "PhotoAndVideoViewController.h"

typedef void(^RunloopBlock)(void);

@interface HomePageController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong)ConnectTipView *tipView;
@property (nonatomic, strong)JSONModelArray *actInfo;
@property (nonatomic, assign)CGFloat cellHeight;
@property (nonatomic, strong)TranslucentNavbar *navigationBar;

@property (nonatomic, strong)NSMutableArray *tasks;
@property (nonatomic, assign)NSUInteger maxQueueLength;

@end

@implementation HomePageController

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
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupNavigationBar];
    
    
    _maxQueueLength = 18;
    _tasks = [NSMutableArray array];
    
}

#pragma mark - <关于Runloop的函数>
//定义一个添加任务的方法
- (void)addTask:(RunloopBlock)task {
    //将任务添加到数组!!
    [self.tasks addObject:task];
    //保证之前没有来得及显示的cell不会绘制图片了
    if (self.tasks.count > self.maxQueueLength) {
        [self.tasks removeObjectAtIndex:0];
    }
}


//读懂思路
- (void)addRunloopObserver {
    //1.获取当前runloop
    CFRunLoopRef runloop = CFRunLoopGetCurrent();
    
    //定义一个context
    CFRunLoopObserverContext context = {
        0,
        (__bridge void *)self,
        &CFRetain,
        &CFRelease,
        NULL
    };
    
    
    //定义观察者
    static CFRunLoopObserverRef defaultModeObserver;
    //创建观察者
    defaultModeObserver = CFRunLoopObserverCreate(NULL, kCFRunLoopBeforeWaiting, YES, 0, &CallBack, &context);
    //添加观察者
    CFRunLoopAddObserver(runloop, defaultModeObserver, kCFRunLoopCommonModes);
    //C语言有create就需要release
    CFRelease(defaultModeObserver);
}

//非常频繁的调用
static void CallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    NSLog(@"来了");
    //处理控制器的加载图片的事情！！
    //这儿info 就是控制器
    NSLog(@"%@",info);
    HomePageController *vc = (__bridge HomePageController *)info;
    if (vc.tasks.count == 0) {
        return;
    }
    
    //拿出任务
    RunloopBlock task = vc.tasks.firstObject;
    //执行任务
    task();
    //干掉任务
    [vc.tasks removeObjectAtIndex:0];
}

- (void)setupNavigationBar {
    _navigationBar = [[TranslucentNavbar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64) scanClick:^{
        ScanViewController *scanVC = [[ScanViewController alloc] init];
        [self.navigationController pushViewController:scanVC animated:YES];
    } addressClick:^{
        AddressViewController *addressVC = [[AddressViewController alloc] init];
        [self.navigationController pushViewController:addressVC animated:YES];
    } searchClick:^{
        SearchViewController *searchVC = [[SearchViewController alloc] init];
        searchVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self.navigationController pushViewController:searchVC animated:YES];
//        searchVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//        [self presentViewController:searchVC animated:YES completion:^{
//        }];
        
    }];
    [self.view addSubview:_navigationBar];
    
    
}

- (void)initData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"首页数据" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    self.actInfo = [[JSONModelArray alloc] initWithArray:[[dict objectForKey:@"data"] objectForKey:@"act_info"] modelClass:[ActInfoModel class]];
}

- (void)createView {
    [self.view addSubview:self.collectionView];
//    [self createNetworkFailedView];
    MARefreshHeader *refreshHeaderView = [MARefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRefresh)];
    refreshHeaderView.gifView.frame = CGRectMake(0, 30, 100, 100);
//    _collectionView.mj_header = refreshHeaderView;
}

- (void)headRefresh {
    sleep(2.f);
    [_collectionView.mj_header endRefreshing];
}

- (void)createNetworkFailedView {
    [self.view addSubview:self.tipView];
}

#pragma mark - 懒加载
- (ConnectTipView *)tipView {
    if (!_tipView) {
        _tipView = [[ConnectTipView alloc] initWithFrame:CGRectMake(0, kScreenHeight / 2 - 300, kScreenWidth, 600) imageName:@"v2_connnect_error" title:@"当前网络不可用，请稍后重试" buttonTitle:@"刷新重试" buttonBlock:^{
            
        }];
    }
    return _tipView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 49) collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[BannerCollectionCell class] forCellWithReuseIdentifier:@"BannerCollectionCell"];
        [_collectionView registerClass:[HotViewCollectionCell class] forCellWithReuseIdentifier:@"HotViewCollectionCell"];
        [_collectionView registerClass:[ImageScrollCell class] forCellWithReuseIdentifier:@"ImageScrollCell"];
        [_collectionView registerNib:[UINib nibWithNibName:@"SalesPromotionCell" bundle:nil] forCellWithReuseIdentifier:@"SalesPromotionCell"];
        [_collectionView registerClass:[PreferenceProductCell class] forCellWithReuseIdentifier:@"PreferenceProductCell"];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CollectionCell"];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumLineSpacing = 5.f;
        _flowLayout.minimumInteritemSpacing = 5.f;
    }
    return _flowLayout;
}

#pragma mark -UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 5;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 4) {
        ActInfoModel *model = self.actInfo[section];
        return model.act_rows.count;
    }
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {//头部banner图展示
        BannerCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BannerCollectionCell" forIndexPath:indexPath];
        ActInfoModel *model = self.actInfo[indexPath.section];
        [cell buildContentViewWithArray:model.act_rows];
        return cell;
    }else if (indexPath.section == 1) {
        HotViewCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HotViewCollectionCell" forIndexPath:indexPath];
        __weak typeof(self) WeakSelf = self;
        ActInfoModel *model = self.actInfo[indexPath.section];
        [cell buildContentViewWithArray:model.act_rows iconClick:^(NSInteger index) {
            if (index == 0) {//抽奖
                LotteryViewController *lotteryVC = [[LotteryViewController alloc] init];
                [WeakSelf.navigationController pushViewController:lotteryVC animated:YES];
            }else if (index == 1) {//领红包
                GetARedEnvelopController *redVC = [[GetARedEnvelopController alloc] init];
//                [self.navigationController pushViewController:redVC animated:YES];
                [WeakSelf presentViewController:redVC animated:YES completion:nil];
            }else if (index == 2) {//蜂抱团
                BeeCliquesViewController *beeVc = [[BeeCliquesViewController alloc] init];
                [WeakSelf.navigationController pushViewController:beeVc animated:YES];
            }else if (index == 3) {//冰饮
                IceDrinkViewController *iceVC = [[IceDrinkViewController alloc] init];
                [WeakSelf.navigationController pushViewController:iceVC animated:YES];
            }else if (index == 4) {//水果
                FreshFruitViewController *fruitVC = [[FreshFruitViewController alloc] init];
                [WeakSelf.navigationController pushViewController:fruitVC animated:YES];
            }else if (index == 5) {//乳品
                MilkProductViewController *milkVC = [[MilkProductViewController alloc] init];
                [WeakSelf.navigationController pushViewController:milkVC animated:YES];
            }else if (index == 6) {//零食
                SnacksViewController *snacksVC = [[SnacksViewController alloc] init];
                [WeakSelf.navigationController pushViewController:snacksVC animated:YES];
            }else if (index == 7) {//卤味
                PhotoAndVideoViewController *photoVC = [[PhotoAndVideoViewController alloc] init];
                [WeakSelf.navigationController pushViewController:photoVC animated:YES];
            }
        }];
        return cell;
    }else if (indexPath.section == 2) {
        ImageScrollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageScrollCell" forIndexPath:indexPath];
        ActInfoModel *model = self.actInfo[indexPath.section];
        [cell buildContentViewWithImageModel:model.act_rows];
        cell.backgroundColor = [UIColor colorFromHexCode:@"#f5f5f5"];
        return cell;
    }else if (indexPath.section == 3) {
        SalesPromotionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SalesPromotionCell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor colorFromHexCode:@"#f5f5f5"];
        ActInfoModel *model = self.actInfo[indexPath.section];
        ActRowsModel *rowF = model.act_rows[0];
        [cell.firstImageView sd_setImageWithURL:[NSURL URLWithString:rowF.topimg]];
        ActRowsModel *rowS = model.act_rows[1];
        [cell.secondImageView sd_setImageWithURL:[NSURL URLWithString:rowS.topimg]];
        ActRowsModel *rowT = model.act_rows[2];
        [cell.thirdImageView sd_setImageWithURL:[NSURL URLWithString:rowT.topimg]];
        ActRowsModel *rowFour = model.act_rows[3];
        [cell.fourthImageView sd_setImageWithURL:[NSURL URLWithString:rowFour.topimg]];
        return cell;
    }else if (indexPath.section == 4) {
        PreferenceProductCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PreferenceProductCell" forIndexPath:indexPath];
        ActInfoModel *model = self.actInfo[indexPath.section];
        ActRowsModel *rowModel = model.act_rows[indexPath.row];
        [cell buildContentInformation:rowModel];
        return cell;
    }
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        ActInfoModel *model = self.actInfo[indexPath.section];
        NSInteger rows;
        if (model.act_rows.count % 4 != 0) {
            rows = model.act_rows.count / 4 + 1;
        }else {
            rows = model.act_rows.count / 4;
        }
        return CGSizeMake(kScreenWidth, rows * 80.f);
    }else if (indexPath.section == 2) {
        return CGSizeMake(kScreenWidth, 165);
    }else if (indexPath.section == 3) {
        return CGSizeMake(kScreenWidth, 180);
    }else if (indexPath.section == 4) {
        return CGSizeMake(kScreenWidth, 370);
    }
    return CGSizeMake(kScreenWidth, 160);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat yOffset = scrollView.contentOffset.y;
    
    if (yOffset >= 50) {
        [UIView animateWithDuration:0.3 animations:^{
            _navigationBar.backgroundColor = RGB(253, 212, 49);
        }];
        CGFloat alpha = MIN(1, 1 - (64 - yOffset) / 64);
        _navigationBar.alpha = alpha;
        if (alpha == 1) {
            [_navigationBar rebuildSubViews];
        }else {
            [_navigationBar restoreSubViews];
        }
    }else if (yOffset < -20){
        [_navigationBar restoreSubViews];
        [UIView animateWithDuration:0.3 animations:^{
            _navigationBar.backgroundColor = [UIColor clearColor];
            _navigationBar.alpha = 0;
        }];
    }else {
        [_navigationBar restoreSubViews];
        [UIView animateWithDuration:0.3 animations:^{
            _navigationBar.alpha = 1;
            _navigationBar.backgroundColor = [UIColor clearColor];
        }];
    }
}

@end
