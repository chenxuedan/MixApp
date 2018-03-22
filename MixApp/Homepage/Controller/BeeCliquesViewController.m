//
//  BeeCliquesViewController.m
//  MixApp
//
//  Created by 陈雪丹 on 2017/2/22.
//  Copyright © 2017年 cxd. All rights reserved.
//

#import "BeeCliquesViewController.h"
#import "CalendarMonthCollectionViewFlowLayout.h"
#import "ChooseTimeCollectionViewCell.h"
#import "TimerCollectionReusableView.h"
#import "CustomWeekdayTopView.h"

@interface BeeCliquesViewController () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong)CustomWeekdayTopView *weekdayView;
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)NSDateFormatter *formatter;
@property (nonatomic, strong)NSDateComponents *components;
@property (nonatomic, strong)NSCalendar *calendar;
@property (nonatomic, strong)NSArray *weekdays;
@property (nonatomic, strong)NSTimeZone *timeZone;

//出团时间数组
@property (nonatomic, strong)NSArray *outDateArray;
//返回时间数组
@property (nonatomic, strong)NSArray *selectedData;

@end

@implementation BeeCliquesViewController

//获取北京地区的失去
- (NSTimeZone *)timeZone {
    if (!_timeZone) {
        [UIColor blueColor];
        _timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    }
    return _timeZone;
}

- (NSArray *)weekdays {
    if (!_weekdays) {
        _weekdays = [NSArray arrayWithObjects:[NSNull null],@"0",@"1",@"2",@"3",@"4",@"5",@"6", nil];
    }
    return _weekdays;
}

- (NSCalendar *)calendar {
    if (!_calendar) {
        _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    }
    return _calendar;
}

- (NSDateComponents *)components {
    if (!_components) {
        _components = [[NSDateComponents alloc] init];
    }
    return _components;
}

- (NSDateFormatter *)formatter {
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc] init];
        [_formatter setDateFormat:@"yyyy-MM-dd"];
    }
    return _formatter;
}

#pragma mark - 各种方法
/**
 *  根据当前月获取有多少天
 *
 *  @param dayDate 当前时间
 *  某个时间点所在的"小单元",在"大单元"中的数量    当前时间对应的月份中有几天
 *  @return 天数
 */
- (NSInteger)getNumberOfDays:(NSDate *)dayDate {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:dayDate];
    return range.length;
}
/**
 *  根据当前月的前几月或后几月的时间
 *
 *  @param date  当前时间
 *  @param month 第几个月 正数为前 负数为后
 *
 *  @return 获得时间
 
 **** 在参数date基础上，增加一个NSDateComponents类型的时间增量
 */
- (NSDate *)getPriousorLaterDateFromDate:(NSDate *)date withMonth:(NSInteger)month {
    [self.components setMonth:month];
    //在当前历法下，获取month月后的时间点
    NSDate *mDate = [self.calendar dateByAddingComponents:self.components toDate:date options:0];
    return mDate;
}
/**
 *  根据时间获取周几
 *
 *  @param inputDate 输入参数是NSDate
 *
    dateComponents.weekday //Sunday:1,Monday:2,Tuesday:3,Wednesday:4,Friday:5,Saturday:6
 
 *  @return 输出结果是星期几的字符串
 */
- (NSString *)weekdayStringFromDate:(NSDate *)inputDate {
    [self.calendar setTimeZone:self.timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    //通过已定义的日历对象，获取某个时间点的NSDateComponents表示，并设置需要表示哪些信息
    NSDateComponents *theComponents = [self.calendar components:calendarUnit fromDate:inputDate];
    return [self.weekdays objectAtIndex:theComponents.weekday];
}
/**
 *  获取第N个月的时间
 *
 *  @param currentDate 当前时间
 *  @param index       第几个月 正数为前  负数为后
 *
 *  @return @"2016年3月"  返回数组 数组元素分别是年月日
 */
- (NSArray *)timeString:(NSDate *)currentDate many:(NSInteger)index {
    NSDate *getDate = [self getPriousorLaterDateFromDate:currentDate withMonth:index];
    NSString *str = [self.formatter stringFromDate:getDate];
    return [str componentsSeparatedByString:@"-"];
}
/**
 *  根据时间获取第一天周几
 *
 *  @param dateStr 时间
 *
 *  @return 周几
 */
- (NSString *)getMonthBeginAndEndWith:(NSDate *)dateStr {
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    NSCalendar *calecdar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //设定周一为周首日  设置每周的第一天从星期几开始，比如:1代表星期日开始，2代表星期二开始
    [calecdar setFirstWeekday:2];
    BOOL ok = [calecdar rangeOfUnit:NSCalendarUnitMonth startDate:&beginDate interval:&interval forDate:dateStr];
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval - 1];
    }else {
        return @"";
    }
    return [self weekdayStringFromDate:beginDate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"蜂抱团";
    [self buildUI];
}

- (void)buildUI {
    [self.view addSubview:self.weekdayView];
    [self.view addSubview:self.collectionView];
}

#pragma mark - 懒加载
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CalendarMonthCollectionViewFlowLayout *flowLayout = [[CalendarMonthCollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        flowLayout.headerReferenceSize = CGSizeMake(kScreenWidth, 40);
        flowLayout.itemSize = CGSizeMake((kScreenWidth - 20) / 7, 65);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 30, kScreenWidth, kScreenHeight - 64 - 30) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerNib:[UINib nibWithNibName:@"ChooseTimeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ChooseTimeCollectionViewCell"];
        [_collectionView registerNib:[UINib nibWithNibName:@"TimerCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"TimerCollectionReusableView"];
    }
    return _collectionView;
}

- (CustomWeekdayTopView *)weekdayView {
    if (!_weekdayView) {
        _weekdayView = [[CustomWeekdayTopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    }
    return _weekdayView;
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";

    NSDateComponents *dateComponent = [self.calendar components:NSCalendarUnitMonth fromDate:[dateFormatter dateFromString:@"1900-02-01"] toDate:[NSDate date] options:NSCalendarWrapComponents];
    NSLog(@"%ld",dateComponent.month);
    return dateComponent.month + 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //根据当前时间获取间隔section月的时间
    NSDate *dateList = [self getPriousorLaterDateFromDate:[[NSDate alloc] init] withMonth:section];
    //根据时间获取当月第一天周几
    NSString *timerString = [self getMonthBeginAndEndWith:dateList];
    NSInteger p_0 = [timerString integerValue];
    NSInteger p_1 = [self getNumberOfDays:dateList] + p_0;
    return p_1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ChooseTimeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ChooseTimeCollectionViewCell" forIndexPath:indexPath];
    //根据当前时间获取间隔section月的时间
    NSDate *dateList = [self getPriousorLaterDateFromDate:[NSDate date] withMonth:indexPath.section];
    
    //获取与当前日期相差几个月的日期的年月日的数组
    NSArray *array = [self timeString:[NSDate date] many:indexPath.section];
    NSInteger p = indexPath.row - [self getMonthBeginAndEndWith:dateList].intValue + 1;
    
    NSString *str;
    if (p < 10) {
        str = p > 0 ? [NSString stringWithFormat:@"0%ld",(long)p]:[NSString stringWithFormat:@"-0%ld",(long)-p];
    }else {
        str = [NSString stringWithFormat:@"%ld",(long)p];
    }
    NSArray *list = @[array[0],array[1],str];
    [cell updateDay:list outDate:self.outDateArray selected:[self.selectedData componentsJoinedByString:@""].integerValue currentDate:[self timeString:[[NSDate alloc] init] many:0]];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath: (NSIndexPath *)indexPath {
    NSDate *dateList = [self getPriousorLaterDateFromDate:[[NSDate alloc] init] withMonth:indexPath.section];
    NSInteger p = indexPath.row - [self getMonthBeginAndEndWith:dateList].intValue + 1;
    NSArray *array = [self timeString:[NSDate date] many:indexPath.section];
    NSString *str = p < 10 ? [NSString stringWithFormat:@"0%ld",p] : [NSString stringWithFormat:@"%ld",p];
    self.outDateArray = @[array[0],array[1],str];
    [self.collectionView reloadData];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        TimerCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"TimerCollectionReusableView" forIndexPath:indexPath];
        headerView.backgroundColor = [UIColor whiteColor];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        [headerView updateTimer:[self timeString:[dateFormatter dateFromString:@"1900-02-01"] many:indexPath.section]];
        return headerView;
    }
    return nil;
}


@end
