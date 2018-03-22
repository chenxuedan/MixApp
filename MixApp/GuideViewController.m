//
//  GuideViewController.m
//  MixApp
//
//  Created by 陈雪丹 on 16/7/19.
//  Copyright © 2016年 cxd. All rights reserved.
//

#import "GuideViewController.h"
#import "GuideCell.h"

@interface GuideViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)UICollectionViewFlowLayout *layout;
@property (nonatomic, strong)UIPageControl *pageControl;
@property (nonatomic, strong)NSArray *imageNames;

@end

@implementation GuideViewController

/*
 
 http://bb.shoujiduoduo.com/baby/bb.php?type=getgames&interver=4&pid=10000209&ver=ErGeDD_ip_3.6.0.2.ipa&grade=
 
 
 
 http://s4.cnzz.com/z_stat.php?id=1260567729&web_id=1260567729
 */


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//iOS沙盒目录结构
- (void)getiOSSandBox {
    //出于安全考虑，iOS系统的沙盒机制规定每个应用都只能访问当前沙盒目录下面的文件(也有例外，比如在用户授权情况下访问通讯录，相册等),这个规则展示了iOS系统的封闭性。在开发中常常需要数据存储的功能，比如存取文件。归档解档等.
    
    
    //一、沙盒目录结构
    NSString *path = NSHomeDirectory();
    /*
     上面的代码得到的是应用程序目录的路径，在改目录下有三个文件夹:Documents、Library、temp以及一个.app包！该目录下就是应用程序的沙盒，应用程序只能访问该目录下的文件夹！！！
     1.Documents目录：您应该将所有的应用程序数据文件写入到这个目录下。这个目录用于存储用户数据。该路径可通过配置实现iTunes共享文件。可被iTunes备份。
     2.AppName.app目录：这是应用程序的程序包目录，包含应用程序的本身。由于应用程序必须经过签名，所以您在运行时不能对这个目录中的内容进行修改，否则可能会使应用程序无法启动.
     3.Library目录：这个目录下有两个子目录：
     Preferences目录：包含应用程序的偏好设置文件。您不应该直接创建偏好设置文件，而是应该使用NSUserDefaults类来取得和设置应用程序的偏好。
     Caches目录：用于存放应用程序专用的支持文件，保存应用程序再次启动过程中需要的信息。
     可创建子文件夹。可以用来放置您希望被备份但不希望被用户看到的数据。该路径下的文件夹，除Caches以外，都会被iTunes备份。
     4.tmp目录：这个目录用于存放临时文件，保存应用程序再次启动过程中不需要的信息。该路径下的文件不会被iTunes备份。
      */
    
    //二、获取各种文件目录的路径
    //获取目录路径的方法:
    //获取沙盒根目录路径
    NSString *homeDir = NSHomeDirectory();
    //获取Documents目录路径
    //Documents: 最常用的目录，iTunes同步该应用时会同步此文件夹中的内容，适合存储重要数据。
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    //获取Library的目录路径
    NSString *libDir = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    //获取Caches目录路径
    //Library/Caches: iTunes不会同步此文件夹，适合存储体积大，不需要备份的非重要数据。
    NSString *cachesDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    //Library/Preferences: iTunes同步该应用时会同步此文件夹中的内容，通常保存应用的设置信息。
    
    //获取tmp目录路径
    //tmp: iTunes不会同步此文件夹，系统可能在应用没运行时就删除该目录下的文件，所以此目录适合保存应用中的一些临时文件，用完就删除。
    NSString *tmpDir = NSTemporaryDirectory();
    
    //获取应用程序程序包中资源文件路径的方法
    //"应用程序包":这里面存放的是应用程序的源文件，包括资源文件和可执行文件。
    NSLog(@"%@",[[NSBundle mainBundle] bundlePath]);
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"apple" ofType:@"png"];
    UIImage *appleImage = [[UIImage alloc] initWithContentsOfFile:imagePath];
    
    //三、NSSearchPathForDirectoriesInDomains
    /*
     NSSearchPathForDirectoriesInDomains方法用于查找目录，返回指定范围内的指定名称的目录的路径集合。有三个参数：
     directory  NSSearchPathDirectory类型的enum值，表明我们要搜索的目录名称，比如这里用NSDocumentDirectory表明我们要搜索的是Documents目录。如果我们将其换成NSCachesDirectory就表示我们搜索的是Librar/Caches目录。
     domainMask NSSearchPathDomainMask类型的enum值，指定搜索范围，这里的NSUserDomainMask表示搜索的范围限制于当前应用的沙盒目录。还可以写成NSLocalDomainMask(表示/Library)、NSNetworkDomainMask(表示/Network)等。
     expandTilde BOOL值，表示是否展开波浪线~。我们知道在iOS中的全写形式是/User/userName,该值为YES即表示写成全写形式，为NO就表示直接写成“~”。
     该值为NO:Caches目录路径~/Library/Caches
     该值为YES:Caches目录路径
     /var/mobile/Containers/Data/Application/E7B438D4-0AB3-49D0-9C2C-B84AF67C752B/Library/Caches
     
     caches呢就是缓存的，例如下载一些文件啊，有些pdf或者其他图片挺大的，可以放在这里，应用下次打开的时候还会在的
     而tmp下次打开很有可能被自动删除了，这是临时文件夹
     
     而caches和documents区别就在于：cheches文件夹不会在你备份手机数据的时候上传到iTunes上去，documents则会被备份上传，所以documents放占用空间小的重要数据，备份数据就很轻松
     caches放的是比较大的文件，所以就不备份，太大了不容易上传。
     */
}

- (void)threadTimer {
    //runloop有5种模式
    //NSDefaultRunLoopMode --默认模式 ：处理网络时间，timer
    //UITrackingRunLoopMode --UI模式 : UI事件
    //NSRunLoopCommonModes --占位模式（并不是runloop真正的模式）相当于同时添加到NSDefaultRunLoopMode 和 UITrackingRunLoopMode中
    //视图上面有手势触摸的时候，会响应UI
    //    [[NSRunLoop currentRunLoop] addTimer:currentTimer forMode:NSDefaultRunLoopMode];
    //    [[NSRunLoop currentRunLoop] addTimer:currentTimer forMode:UITrackingRunLoopMode];
    
    //创建一个timer 这里面添加到默认模式
    //    [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerMethod) userInfo:nil repeats:YES];
    
    NSThread *thread = [[NSThread alloc] initWithBlock:^{
        NSTimer *currentTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerMethod) userInfo:nil repeats:YES];
        //将timer添加在runloop中去
        [[NSRunLoop currentRunLoop] addTimer:currentTimer forMode:NSDefaultRunLoopMode];
        
        //让当前这个线程的runloop跑起来
        //一条线程想要保住命！！就是让他的runloop跑起来
        //这是一个死循环！！
        [[NSRunLoop currentRunLoop] run];
        
        NSLog(@"来了！！");
        
    }];
    
    //启动线程
    [thread start];
}

//timer中不建议处理耗时的操作
//一旦有耗时操作！在子线程做
- (void)timerMethod {
    //阻塞线程  UI界面拖动的时候会卡顿
    [NSThread sleepForTimeInterval:1.0];
    
    static int num;
    NSLog(@"%d",num++);
}


- (void)GCDTimer {
    //创建timer
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    //设置timer  事件单位是纳秒  1秒 = 1000000000纳秒
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    //设置回调
    dispatch_source_set_event_handler(timer, ^{
        NSLog(@"----%@",[NSThread currentThread]);
    });
    //启动timer
    dispatch_resume(timer);
}

- (void)initData {
    _imageNames = @[@"guide_40_1",@"guide_40_2",@"guide_40_3",@"guide_40_4"];
}

- (void)createView {
    [self.view addSubview:self.collectionView];
    self.pageControl.numberOfPages = _imageNames.count;
    [self.view addSubview:self.pageControl];
}

- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.minimumInteritemSpacing = 0;
        _layout.minimumLineSpacing = 0;
        _layout.itemSize = [UIScreen mainScreen].bounds.size;
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _layout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth,kScreenHeight) collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.bounces = NO;
        [_collectionView registerClass:[GuideCell class] forCellWithReuseIdentifier:@"GuideCell"];
    }
    return _collectionView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, kScreenHeight - 50, kScreenWidth, 20)];
        _pageControl.currentPage = 0;
    }
    return _pageControl;
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageNames.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GuideCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GuideCell" forIndexPath:indexPath];
    [cell.imageView setImage:[UIImage imageNamed:_imageNames[indexPath.item]]];
    if (indexPath.item == _imageNames.count - 1) {
        cell.nextButton.hidden = NO;
    }else {
        cell.nextButton.hidden = YES;
    }
    return cell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.pageControl.currentPage = scrollView.contentOffset.x / kScreenWidth;
}

@end
