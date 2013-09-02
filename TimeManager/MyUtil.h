//
//  MyUtil.h
//  TimeManager
//
//  Created by Kimura Kazunori on 2013/08/22.
//  Copyright (c) 2013年 Kimura Kazunori. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyUtil : NSObject

+ (NSString *) stringFromDate:(NSDate *)date;
+ (NSInteger)numberFromDate:(NSDate *)date;
+ (NSString *)stringMonthDay:(NSNumber *)dateValue;
+ (NSString *)stringHourMinute:(NSNumber *)timeValue;
+ (NSNumber *)numberFromTimeString:(NSString *)timeValue;
+ (NSDateComponents *)dateComponentFromDate:(NSDate *)date;
+ (NSString *)stringWeekday:(NSDate *)date;
+ (NSDate *)initWithDayInterval:(NSInteger)days fromDate:(NSDate *)date;
+ (NSInteger)convertMinute:(NSNumber *)timeValue;
+ (NSString *)formatMinute:(NSInteger)minute;
+ (NSInteger)diffTime:(NSNumber *)startTime endTime:(NSNumber *)endTime
           lunchTime:(NSNumber *)lunchTime restTime:(NSNumber *)restTime;
+ (NSString *)stringMonthDayFromDate:(NSDate *)date;
+ (NSInteger)getLastDay:(NSDate *)date;

@end
