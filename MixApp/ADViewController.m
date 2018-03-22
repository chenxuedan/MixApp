//
//  ADViewController.m
//  MixApp
//
//  Created by 陈雪丹 on 2017/3/29.
//  Copyright © 2017年 cxd. All rights reserved.
//

#import "ADViewController.h"
#import "MainTabBarController.h"
#import "Person.h"

@interface ADViewController ()

@property (nonatomic, strong)NSTimer *globalTimer;
@property (nonatomic, strong)UIImageView *launchView;
@property (nonatomic, assign)NSInteger count;
@property (nonatomic, strong)UIButton *timeBtn;

@end

@implementation ADViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _count = 3;
    _globalTimer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(timerDidClick:) userInfo:nil repeats:YES];
    [self setImageViewAnimation];
}

//- (void)test {
//    Person *person = [[Person alloc] init];
//    person.name = @"Tom";
//    person.age = 20;
//    person.sex = @"male";
//    NSData *personData = [NSKeyedArchiver archivedDataWithRootObject:person];
//    NSLog(@"personData   %@",personData);
//    
//    [personData writeToFile:@"/Users/chenxuedan/Desktop/MixApp1/personData" atomically:YES];
//    personData = [NSData dataWithContentsOfFile:@""];
//    Person *resultPerson = [NSKeyedUnarchiver unarchiveObjectWithData:personData];
//    
//    Person *person1 = [[Person alloc] init];
//    person1.name = @"xiaohong";
//    person1.age = 20;
//    person1.sex = @"female";
//    
//    NSMutableData *mutableData = [NSMutableData data];
//    
//    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:mutableData];
//    [archiver encodeObject:person forKey:@"person"];
//    [archiver encodeObject:person1 forKey:@"person1"];
//    //系统不会自动完成归档的
//    [archiver finishEncoding];
//}

- (void)timerDidClick:(NSTimer *)timer {
    _count--;
    [_timeBtn setTitle:[NSString stringWithFormat:@"停留%ld秒钟",_count] forState:UIControlStateNormal];
    if (_count == 0) {
        MainTabBarController *mainTabBar = [[MainTabBarController alloc] init];
        [UIApplication sharedApplication].keyWindow.rootViewController = mainTabBar;

         [_globalTimer setFireDate:[NSDate distantFuture]];
    }
}
//实现启动图图片的放大消失功能
-(void)setImageViewAnimation{
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    NSString *viewOrientation = @"Portrait";    //横屏请设置成 @"Landscape"
    NSString *launchImage = nil;
    
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary *dict in imagesDict)
    {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
        {
            launchImage = dict[@"UILaunchImageName"];
        }
    }
    
    _launchView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:launchImage]];
    _launchView.userInteractionEnabled = YES;
    _timeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _timeBtn.frame = CGRectMake(kScreenWidth - 120, 80, 100, 30);
    _timeBtn.layer.cornerRadius = 15.f;
    _timeBtn.layer.masksToBounds = YES;
    _timeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_timeBtn setTitle:@"停留3秒钟" forState:UIControlStateNormal];
    [_timeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _timeBtn.backgroundColor = RGBA(0, 0, 0, 0.4);
    [_timeBtn addTarget:self action:@selector(btnDidClick) forControlEvents:UIControlEventTouchUpInside];
    [_launchView addSubview:_timeBtn];
    _launchView.frame = [UIScreen mainScreen].bounds;
    _launchView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:_launchView];
}

- (void)btnDidClick {
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"TimerOrBtnClick" object:nil];
    MainTabBarController *mainTabBar = [[MainTabBarController alloc] init];
    [UIApplication sharedApplication].keyWindow.rootViewController = mainTabBar;
    if (![_globalTimer isValid]) {
        return;
    }
    //实现定时器停止
    [_globalTimer setFireDate:[NSDate distantFuture]];

}

@end
