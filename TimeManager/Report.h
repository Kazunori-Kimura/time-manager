//
//  Report.h
//  TimeManager
//
//  Created by Kimura Kazunori on 2013/08/19.
//  Copyright (c) 2013年 Kimura Kazunori. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Report : NSManagedObject

@property (nonatomic, retain) NSNumber * report_id;
@property (nonatomic, retain) NSNumber * project_id;
@property (nonatomic, retain) NSString * report_name;
@property (nonatomic, retain) NSNumber * start_date;
@property (nonatomic, retain) NSNumber * end_date;
@property (nonatomic, retain) NSNumber * upload_flag;
@property (nonatomic, retain) NSNumber * delete_flag;

@end
