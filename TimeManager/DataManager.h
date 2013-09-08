//
//  DataManager.h
//  TimeManager
//
//  Created by Kimura Kazunori on 2013/08/19.
//  Copyright (c) 2013年 Kimura Kazunori. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DataManager : NSObject
{
    NSManagedObjectContext *context;
}

@property (nonatomic, retain) NSManagedObjectContext *context;

//dailyreport
- (NSMutableArray *) getDailyReportByReportDate:(NSInteger)reportDate;
- (NSMutableArray *) getDailyReport:(NSPredicate *)predicate;
- (NSMutableArray *) getDailyReport:(NSPredicate *)predicate sort:(NSSortDescriptor *)sort;
- (id) createDailyReport;
- (id) createDailyReport:(NSNumber *)reportDate projectId:(NSNumber *)projectId;

//report
- (NSMutableArray *) getReportById:(NSInteger)reportId;
- (NSMutableArray *) getReport:(NSPredicate *)predicate;
- (NSMutableArray *) getReport:(NSPredicate *)predicate sort:(NSSortDescriptor *)sort;
- (NSMutableArray *) getReport:(NSPredicate *)predicate sorts:(NSArray *)sorts;
- (id) createReport;

//project
- (NSMutableArray *) getProjectById:(NSInteger)projectId;
- (NSMutableArray *) getProject:(NSPredicate *)predicate;
- (NSMutableArray *) getProject:(NSPredicate *)predicate sort:(NSSortDescriptor *)sort;
- (NSMutableArray *) getProject:(NSPredicate *)predicate sorts:(NSArray *)sorts;
- (id) createProject;

- (NSMutableArray *) getData:(NSString *)tableName predicate:(NSPredicate *)predicate sort:(NSSortDescriptor *)sort;
- (NSMutableArray *) getData:(NSString *)tableName predicate:(NSPredicate *)predicate sorts:(NSArray *)sorts;
- (NSManagedObjectModel *) insertNewObject:(NSString *)tableName;
- (void) deleteObject:(NSManagedObject *)obj;
- (void) saveData;

@end