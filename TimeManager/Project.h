//
//  Project.h
//  TimeManager
//
//  Created by Kimura Kazunori on 2013/08/19.
//  Copyright (c) 2013年 Kimura Kazunori. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Project : NSManagedObject

@property (nonatomic, retain) NSNumber * project_id;
@property (nonatomic, retain) NSString * project_name;
@property (nonatomic, retain) NSString * company_name;
@property (nonatomic, retain) NSNumber * base_time;
@property (nonatomic, retain) NSNumber * over_time;
@property (nonatomic, retain) NSNumber * split_time;
@property (nonatomic, retain) NSNumber * base_rest_time;
@property (nonatomic, retain) NSNumber * payment;
@property (nonatomic, retain) NSNumber * end_date;
@property (nonatomic, retain) NSString * workspace;
@property (nonatomic, retain) NSString * manager;
@property (nonatomic, retain) NSNumber * upload_flag;
@property (nonatomic, retain) NSNumber * delete_flag;

@end
