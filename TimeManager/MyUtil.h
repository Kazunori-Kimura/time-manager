//
//  MyUtil.h
//  TimeManager
//
//  Created by Kimura Kazunori on 2013/08/22.
//  Copyright (c) 2013年 Kimura Kazunori. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyUtil : NSObject

+ (NSString *)stringMonthDay:(NSNumber *)dateValue;
+ (NSString *)stringHourMinute:(NSNumber *)timeValue;
+ (NSDateComponents *)dateComponentFromDate:(NSDate *)date;
+ (NSString *)stringWeekday:(NSDate *)date;
+ (NSDate *)initWithDayInterval:(NSInteger)days fromDate:(NSDate *)date;

@end
