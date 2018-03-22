//
//  NSDate+CXDCalendarLogic.h
//  MixApp
//
//  Created by 陈雪丹 on 2017/2/23.
//  Copyright © 2017年 cxd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (CXDCalendarLogic)

//获取当前月有多少天
- (NSUInteger)numberOfDaysInCurrentMonth;
//获取当前月有多少周
- (NSUInteger)numberOfWeeksInCurrentMonth;
//计算这个月的第一天是礼拜几
- (NSUInteger)weeklyOrdinality;
//获取这个月最开始的一天
- (NSDate *)firstDayOfCurrentMonth;
//获取这个月最后一天
- (NSDate *)lastDayOfCurrentMonth;
//上一个月
- (NSDate *)dayInThePreviousMonth;
//下一个月
- (NSDate *)dayInTheFollowingMonth;
//获取当前日期之后的几个月
- (NSDate *)dayInTheFollowingMonth:(int)month;
//获取当前日期之后的几天
- (NSDate *)dayInTheFollowingDay:(int)day;
//获取年月日对象
- (NSDateComponents *)YMDComponents;
//NSString转NSDate
- (NSDate *)dateFromString:(NSString *)dateString;
//NSDate转NSString
- (NSString *)stringFromDate:(NSDate *)date;
//两个日期之间相差
+ (int)getDayNumberToDay:(NSDate *)today beforeDay:(NSDate *)beforeDay;
//周日是"1",周二是"2"...
- (int)getWeekIntValueWithDate;
//判断日期是今天,明天,后天,周几
- (NSString *)compareIfTodayWithDate;
//通过数字返回星期几
+ (NSString *)getWeekStringFromInteger:(int)week;

@end
