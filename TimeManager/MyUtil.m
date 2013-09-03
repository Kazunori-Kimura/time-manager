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
 * 日付を文字列表記する
 * @param date
 * @return {NSString} yyyy/mm/dd (w)
 */
+ (NSString *) stringFromDate:(NSDate *)date
{
    NSDateComponents *c = [MyUtil dateComponentFromDate:date];
    NSString *d = [MyUtil stringWeekday:date];
    return [NSString stringWithFormat:@"%4d/%02d/%02d (%@)", c.year, c.month, c.day, d];
}

/**
 * 日付から8桁の数字を取得する
 * @param date
 * @return {NSInteger} YYYYMMDD
 */
+ (NSInteger)numberFromDate:(NSDate *)date
{
    NSDateComponents *c = [MyUtil dateComponentFromDate:date];
    return c.year * 10000 + c.month * 100 + c.day;
}

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
 * "HH:MM"から4桁の数字を取得する
 * @param {NSString} HH:MM
 * @return {NSNumber} HHMM
 */
+(NSNumber *)numberFromTimeString:(NSString *)timeValue
{
    NSNumber *ret = nil;
    //HH:MM形式かどうかをチェック
    NSString *timePattern = @"([0-9]{1,2}):([0-9]{1,2})";
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:timePattern
                                                                         options:0
                                                                           error:nil];
    NSTextCheckingResult *match = [reg firstMatchInString:timeValue
                                                  options:0
                                                    range:NSMakeRange(0, timeValue.length)];
    
    if(match.numberOfRanges == 3){
        NSString *hour = [timeValue substringWithRange:[match rangeAtIndex:1]];
        NSString *minute = [timeValue substringWithRange:[match rangeAtIndex:2]];
        NSInteger val = hour.intValue * 100 + minute.intValue;
        ret = [NSNumber numberWithInteger:val];
    }
    
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
 * 日付から月日を取得
 * @param date
 * @return MM/DD
 */
+ (NSString *)stringMonthDayFromDate:(NSDate *)date
{
    NSDateComponents *c = [MyUtil dateComponentFromDate:date];
    return [NSString stringWithFormat:@"%02d/%02d", c.month, c.day];
}

/**
 * 月末の日にちを取得する
 * @param NSDate
 * @return 月末の日にち
 */
+ (NSInteger)getLastDay:(NSDate *)date
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSRange range = [cal rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date];
    return range.length;
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

/**
 * HHMMを数値(分)に変換
 * @param HHMM
 * @return Minute
 */
+ (NSInteger)convertMinute:(NSNumber *)timeValue
{
    NSString *val = [NSString stringWithFormat:@"%04d", timeValue.integerValue];
    NSInteger hour = [[val substringWithRange: NSMakeRange(0, 2)] integerValue];
    NSInteger minute = [[val substringWithRange: NSMakeRange(2, 2)] integerValue];
    return hour * 60 + minute;
}

/**
 * 数値(分)を "H時間 MM分" に変換
 * @param minute
 * @return H時間 MM分
 */
+ (NSString *)formatMinute:(NSInteger)minute
{
    NSInteger h = minute / 60;
    NSInteger m = minute % 60;
    return [NSString stringWithFormat:@"%d時間 %02d分", h, m];
}

/**
 * 開始・終了時間の差、休憩時間を差し引いて実作業時間を計算する
 * @param diffTime:開始時間
 * @param endTime:終了時間
 * @param lunchTime:昼休憩
 * @param restTime:昼以外の休憩
 * @return 実作業時間(分)
 */
+(NSInteger)diffTime:(NSNumber *)startTime endTime:(NSNumber *)endTime
            lunchTime:(NSNumber *)lunchTime restTime:(NSNumber *)restTime
{
    NSInteger s = [MyUtil convertMinute:startTime];
    NSInteger e = [MyUtil convertMinute:endTime];
    NSInteger workTime = e - s - (lunchTime.integerValue + restTime.integerValue);
    return workTime;
}

/**
 * 入力文字がパターンと一致するかを判定する (正規表現)
 * @param validateString 判定対象文字列
 * @param pattern 正規表現文字列
 * @return BOOL
 */
+ (BOOL)validateString:(NSString *)string withPattern:(NSString *)pattern
{
    //NSLog(@"%@ - %@", string, pattern);
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];
    NSRange matchRange = [reg rangeOfFirstMatchInString:string
                                                options:0
                                                  range:NSMakeRange(0, string.length)];
    BOOL valid = NO;
    if(matchRange.location != NSNotFound){
        valid = YES;
    }
    return valid;
}

@end
