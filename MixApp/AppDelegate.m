//
//  AppDelegate.m
//  MixApp
//
//  Created by 陈雪丹 on 16/7/19.
//  Copyright © 2016年 cxd. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarController.h"
#import "GuideViewController.h"
#import "ADViewController.h"
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>


//友盟推送
#import "UMessage.h"
#import <UserNotifications/UserNotifications.h>


@interface AppDelegate () <JPUSHRegisterDelegate,UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

//app 程序入口函数
//当app启动的时候调用
//1.当aapp第一次启动调用
//2.或者 app 死掉了  又重新(点通知、点击appIcon)启动
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.

    /*
        launchOptions 启动选项
     //如果我们 是点击通知重新启动死掉的app,launchOptions，这里面可以得到这个通知(本地/远程通知)
     */
    UILocalNotification *localNf = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNf != nil) {//有通知 表示 通过通知重新启动app
        application.applicationIconBadgeNumber = 0;
    }else {
        [self registerLocalNotification];
    }
    
    //注册远程推送
    [self registerRemoteNotification];
    
    
    
    NSString * key = @"CFBundleVersion";
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] stringForKey:key];
    //app bundle 里面有应用的配置信息
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    //判断当前版本 和上次版本更新时存储的版本是否一致
    if ([currentVersion isEqualToString:lastVersion]) {
//        MainTabBarController *mainTabBar = [[MainTabBarController alloc] init];
//        self.window.rootViewController = mainTabBar;
        ADViewController *adVC = [[ADViewController alloc] init];
        self.window.rootViewController = adVC;
    }else {
        GuideViewController *guidView = [[GuideViewController alloc] init];
        self.window.rootViewController = guidView;
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
//    [self setImageViewAnimation];
    
    
    //网络活动指示器
    //当你的应用使用网络时，应当是在iPhone的状态条上放置一个网络指示器，警告用户正在使用网络。这时你可以用UIApplication的一个名为networkActivityIndicatorVisible的属性。
    //通过设置这个可以启用或禁用网络指示器
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    
    //添加初始化APNs代码
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    
    //添加初始化JPush代码
    // Optional
    // 获取IDFA
    // 如需使用IDFA功能请添加此代码并在初始化方法的advertisingIdentifier参数中填写对应值
//    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:@"d765911cf4f3152ff3232b49"
                          channel:@"App Store"
                 apsForProduction:@"0"
            advertisingIdentifier:nil];
    
    
    
    //友盟推送
    [UMessage startWithAppkey:@"your appkey" launchOptions:launchOptions];
    //注册通知，如果要使用category的自定义策略，可以参考demo中的代码。
    [UMessage registerForRemoteNotifications];
    
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate=self;
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|  UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10     completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            //这里可以添加一些自己的逻辑
        } else {
            //点击不允许
            //这里可以添加一些自己的逻辑
        }
    }];
    
    //打开日志，方便调试
    [UMessage setLogEnabled:YES];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}


#pragma mark - 远程推送
- (void)registerRemoteNotification {
    //1.要向苹果的推送服务器 apns 注册
    if ([UIDevice currentDevice].systemVersion.doubleValue >= 8.0) {
        //让用户授权 通知配置
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil]];
        //向apple apns 发送注册推送的 请求
        //苹果服务器收到 之后 会 给当前app 一个deviceToken
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }else {
        //8.0 之前
        //向apple apns 发送注册请求
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
    }
}

#pragma mark - 远程注册成功 回调
//远程 推送  注册成功  会 调用
//- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
//    //apns 会发送deviceToken 当前app会接收到
//    NSLog(@"%@",deviceToken);
//    //当前app 要 通过后台提供的接口 发送给 后台服务器
//    
//}

//远程注册失败
//- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
//    NSLog(@"注册失败：%@",error.description);
//}
/*
 失败原因：
 1、当用户选择不允许的时候会执行此方法
 2、当使用模拟器的时候会执行此方法
 3、证书问题
 */

//接收到 远程 推送 消息
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
//    application.applicationIconBadgeNumber = 0;
//    NSLog(@"收到远程推送的通知:%@",userInfo);
//    //userInfo中就是推送的信息
//    
//}
/*
 {"aps":{"alert":"This is some fancy message.","badge":1,"sound":"音效.caf"}}
 
 */


//本地通知  注册之后 在前台 后台 程序死掉  都可以收到
#pragma mark - 注册通知 并且授权
- (void)registerLocalNotification {
    //判断版本
//    if ([UIDevice currentDevice].systemVersion.doubleValue >= 8.0) {
//        
//    }
#ifdef __IPHONE_8_0   //->判断有没有定义过这个宏 iOS8.0之后都有定义
    //向用户注册 通知的配置  进行用户授权
    /*
     UIUserNotificationTypeNone
     UIUserNotificationTypeBadge app角标/徽标
     UIUserNotificationTypeSound 提示、通知声音
     UIUserNotificationTypeAlert //提示的内容
     */
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
    //注册 ---》向本地 系统 注册，注册成功之后 会回调- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
#endif
}
//当app 向本地系统 成功之后 回调 下面的方法
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    //注册成功之后 就可以创建 本地通知
    //1.实例化本地通知对象
    UILocalNotification *localNf = [[UILocalNotification alloc] init];
    //2.通知提示内容
    localNf.alertBody = @"本地通知  您有新的美团外卖订单，请及时处理";
    //3.设置声音(30s内的声音)
    localNf.soundName = @"音效.caf";//必须保证这个音频 在 app bundle中
    //4.设置角标
    localNf.applicationIconBadgeNumber = 1;
    //5.设置 启动本地推送时间(触发时间)
    //注册 5s 之后
    localNf.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
    
    //6.把这个本地通知 放入 本地系统
    //把这个通知 调度 到 本地系统，到指定时间之后 本地通知 会 推送通知
    [[UIApplication sharedApplication] scheduleLocalNotification:localNf];
}
#pragma amrk - app收到通知
/*
应用程序在前台 收到 本地 通知 调用
 1.app 在前台（活跃状态）收到了 本地通知 调用，（本地通知不会效果）
 2.app 在后台 收到了本地通知，并且点击  通知 进入了前台 也会调用
 */
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    application.applicationIconBadgeNumber = 0;//表示把通知阅读了角标要置为0
    //判断app 的状态
    /*
     UIApplicationStateActive,
     UIApplicationStateInactive,
     UIApplicationStateBackground
     */
    if (application.applicationState == UIApplicationStateActive) {
        //前台 的时候  收到的通知
        
    }else if (application.applicationState == UIApplicationStateInactive) {
        //不活动状态 收到的通知
        NSLog(@"不活跃收到的通知");
    }else {
        //后台模式
    }
    
    
}



#pragma mark - 极光推送

//注册APNs成功并上报DeviceToken
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"%@",deviceToken);

    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

//实现注册APNs失败接口
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
    NSLog(@"注册失败：%@",error.description);
}


#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    application.applicationIconBadgeNumber = 0;
    NSLog(@"收到远程推送的通知:%@",userInfo);

    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
    
    
    
    //友盟
    [UMessage didReceiveRemoteNotification:userInfo];
}


//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭U-Push自带的弹出框
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于前台时的本地推送接受
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于后台时的本地推送接受
    }
}


//实现启动图图片的放大消失功能
-(void)setImageViewAnimation{
    
    CGSize viewSize = self.window.bounds.size;
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
    
    UIImageView *launchView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:launchImage]];
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 100, 100, 80, 20)];
    timeLabel.text = @"停留3秒钟";
    timeLabel.backgroundColor = [UIColor greenSeaColor];
    [launchView addSubview:timeLabel];
    launchView.frame = self.window.bounds;
    launchView.contentMode = UIViewContentModeScaleAspectFill;
    [self.window addSubview:launchView];
    
    [UIView animateWithDuration:2.0f
                          delay:0.0f
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                        launchView.layer.transform = CATransform3DScale(CATransform3DIdentity, 1.2, 1.2, 1);
                         launchView.alpha = 0.0f;
                     } completion:^(BOOL finished) {
                         [launchView removeFromSuperview];
                     }];

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    //清除内存缓存
    [[SDWebImageManager sharedManager].imageCache clearMemory];
    //取消所有下载
    [[SDWebImageManager sharedManager] cancelAll];
}

@end
