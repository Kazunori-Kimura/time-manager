//
//  MyUtil.m
//  TimeManager
//
//  Created by Kimura Kazunori on 2013/08/22.
//  Copyright (c) 2013年 Kimura Kazunori. All rights reserved.
//

#import "MyUtil.h"

@implementation MyUtil

/**
 * 8桁の数字(NSNumber)から月/日を取得する
 * @param dateValue YYYYMMDD
 * @return {NSString} MM/DD
 */
+ (NSString *)stringMonthDay:(NSNumber *)dateValue
{
    NSString *val = [NSString stringWithFormat:@"%08d",
                     dateValue.integerValue];
    NSString *ret = [NSString stringWithFormat:@"%@/%@",
                     [val substringWithRange: NSMakeRange(4, 2)],
                     [val substringWithRange: NSMakeRange(6, 2)]];
    return ret;
}

/**
 * 4桁の数字(NSNumber)から時:分を取得する
 * @param timeValue HHMM
 * @return {NSString} HH:MM
 */
+ (NSString *)stringHourMinute:(NSNumber *)timeValue
{
    NSString *val = [NSString stringWithFormat:@"%04d",
                     timeValue.integerValue];
    NSString *ret = [NSString stringWithFormat:@"%@:%@",
                     [val substringWithRange: NSMakeRange(0, 2)],
                     [val substringWithRange: NSMakeRange(2, 2)]];
    return ret;
}

/**
 * 日付から曜日を取得
 * @param date
 * @return {NSString}
 */
+ (NSString *)stringWeekday:(NSDate *)date
{
    NSArray *weekday = [NSArray arrayWithObjects:@"", @"日", @"月", @"火", @"水", @"木", @"金", @"土", nil];
    NSDateComponents *comp = [MyUtil dateComponentFromDate:date];
    return weekday[comp.weekday];
}

/**
 * NSDateからNSDateComponentを生成する
 * @param date {NSDate}
 * @return {NSDateComponents}
 */
+ (NSDateComponents *)dateComponentFromDate:(NSDate *)date
{
    NSCalendar *c = [NSCalendar currentCalendar];
    NSDateComponents *comp = [c components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit
                                  fromDate:date];
    return comp;
}

/**
 * 基準の日から指定された日数を足したり引いたり
 * @param {NSInteger} days マイナスならN日前を取得
 * @param {NSDate} date 基準の日
 * @return {NSDate}
 */
+ (NSDate *)initWithDayInterval:(NSInteger)days fromDate:(NSDate *)date
{
    return [date initWithTimeInterval:86400 * days sinceDate:date];
}


@end
