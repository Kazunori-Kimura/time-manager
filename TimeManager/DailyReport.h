//
//  DailyReport.h
//  TimeManager
//
//  Created by Kimura Kazunori on 2013/08/19.
//  Copyright (c) 2013年 Kimura Kazunori. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DailyReport : NSManagedObject

@property (nonatomic, retain) NSNumber * report_date;
@property (nonatomic, retain) NSNumber * project_id;
@property (nonatomic, retain) NSNumber * start_time;
@property (nonatomic, retain) NSNumber * end_time;
@property (nonatomic, retain) NSNumber * rest_time;
@property (nonatomic, retain) NSString * detail;
@property (nonatomic, retain) NSNumber * weather;
@property (nonatomic, retain) NSNumber * upload_flag;

@end
