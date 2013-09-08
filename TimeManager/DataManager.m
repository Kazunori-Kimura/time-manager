//
//  DataManager.m
//  TimeManager
//
//  Created by Kimura Kazunori on 2013/08/19.
//  Copyright (c) 2013年 Kimura Kazunori. All rights reserved.
//

#import "DataManager.h"
#import "DSJSONRPC.h"
#import <CoreData/CoreData.h>
#import "DailyReport.h"
#import "Report.h"
#import "Project.h"
#import "Setting.h"
#import "SettingController.h"

@implementation DataManager

@synthesize context;

/**
 * コンストラクタ
 */
- (id)init
{
    [self getManagedObjectContext];
    return self;
}


/**
 * アプリケーションのDocumentsディレクトリへのパスを返す
 * @return Documentsディレクトリのパス
 */
- (NSString *)applicationDocumentsDirectory
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [path lastObject];
}

/**
 * NSManagedObjectContextをインスタンス化
 */
- (void)getManagedObjectContext
{
    NSURL *modelURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Model" ofType:@"momd"]];
    NSString *documents = [self applicationDocumentsDirectory];
    NSURL *storeURL = [NSURL fileURLWithPath:[documents stringByAppendingString:@"data.sqlite"]];
    
    NSManagedObjectModel *model;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSError *error = nil;
    
    // NSManagedObjectModel をインスタンス化
    model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    // NSPersistentStoreCoordinator をインスタンス化
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    // NSManagedObjectContext をインスタンス化
    if (persistentStoreCoordinator != nil) {
        context = [[NSManagedObjectContext alloc] init];
        [context setPersistentStoreCoordinator:persistentStoreCoordinator];
    }
}


/**
 * 日付を指定してDailyReportを取得する (select)
 * @param reportDate yyyyMMdd形式のInteger
 * @return NSMutableArray (NSManagedObjectの配列)
 */
- (NSMutableArray *) getDailyReportByReportDate:(NSInteger)reportDate
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"report_date == %d", reportDate];
    return [self getDailyReport:predicate];
}

/**
 * 条件を指定してDailyReportを取得する (select)
 * @param NSPredicate データ取得条件
 * @return NSMutableArray (NSManagedObjectの配列)
 */
- (NSMutableArray *) getDailyReport:(NSPredicate *)predicate
{
    return [self getDailyReport:predicate sort:nil];
}

/**
 * 条件を指定してDailyReportを取得する (select)
 * @param NSPredicate データ取得条件
 * @param NSSortDescriptor ソート順
 * @return NSMutableArray (NSManagedObjectの配列)
 */
- (NSMutableArray *) getDailyReport:(NSPredicate *)predicate sort:(NSSortDescriptor *)sort
{
    return [self getData:@"DailyReport" predicate:predicate sort:sort];
}

/**
 * 新しいDailyReportを作成する (insert)
 * @return NSManagedObject (DailyReport)
 */
- (id) createDailyReport
{
    NSString *tableName = @"DailyReport";
    return [self insertNewObject:tableName];
}

/**
 * 新しいDailyReportを作成する (Insert)
 * @param NSNumber reportDate
 * @param NSNumber projectId
 * @return NSManagedObject (DailyReport)
 */
-(id) createDailyReport:(NSNumber *)reportDate projectId:(NSNumber *)projectId
{
    DailyReport *dr = [self createDailyReport];
    dr.report_date = reportDate;
    dr.project_id = projectId;
    return dr;
}


/**
 * idを指定してReportを取得する (select)
 * @param report_id NSInteger
 * @return NSMutableArray (NSManagedObjectの配列)
 */
- (NSMutableArray *) getReportById:(NSInteger)reportId
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"report_id == %d", reportId];
    return [self getReport:predicate];
}

/**
 * 条件を指定してReportを取得する (select)
 * @param NSPredicate データ取得条件
 * @return NSMutableArray (NSManagedObjectの配列)
 */
- (NSMutableArray *) getReport:(NSPredicate *)predicate
{
    return [self getReport:predicate sort:nil];
}

/**
 * 条件を指定してReportを取得する (select)
 * @param NSPredicate データ取得条件
 * @param NSSortDescriptor ソート順
 * @return NSMutableArray (NSManagedObjectの配列)
 */
- (NSMutableArray *) getReport:(NSPredicate *)predicate sort:(NSSortDescriptor *)sort
{
    NSString *tableName = @"Report";
    return [self getData:tableName predicate:predicate sort:sort];
}

/**
 * 条件を指定してReportを取得する (select)
 * @param NSPredicate データ取得条件
 * @param NSArray ソート順 (NSSortDescriptorの配列)
 * @return NSMutableArray (NSManagedObjectの配列)
 */
- (NSMutableArray *) getReport:(NSPredicate *)predicate sorts:(NSArray *)sorts
{
    NSString *tableName = @"Report";
    return [self getData:tableName predicate:predicate sorts:sorts];
}

/**
 * 新しいReportを作成する (insert)
 * @return NSManagedObject
 */
- (id) createReport
{
    NSString *tableName = @"Report";
    return [self insertNewObject:tableName];
}


/**
 * idを指定してProjectを取得する (select)
 * @param project_id NSInteger
 * @return NSMutableArray (NSManagedObjectの配列)
 */
- (NSMutableArray *) getProjectById:(NSInteger)projectId
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"project_id == %d", projectId];
    return [self getProject:predicate];
}

/**
 * 条件を指定してProjectを取得する (select)
 * @param NSPredicate データ取得条件
 * @return NSMutableArray (NSManagedObjectの配列)
 */
- (NSMutableArray *) getProject:(NSPredicate *)predicate
{
    return [self getProject:predicate sort:nil];
}

/**
 * 条件を指定してProjectを取得する (select)
 * @param NSPredicate データ取得条件
 * @param NSSortDescriptor ソート順
 * @return NSMutableArray (NSManagedObjectの配列)
 */
- (NSMutableArray *) getProject:(NSPredicate *)predicate sort:(NSSortDescriptor *)sort
{
    NSString *tableName = @"Project";
    return [self getData:tableName predicate:predicate sort:sort];
}

/**
 * 条件を指定してProjectを取得する (select)
 * @param NSPredicate データ取得条件
 * @param NSArray ソート順 (NSSortDescriptorの配列)
 * @return NSMutableArray (NSManagedObjectの配列)
 */
- (NSMutableArray *) getProject:(NSPredicate *)predicate sorts:(NSArray *)sorts
{
    NSString *tableName = @"Project";
    return [self getData:tableName predicate:predicate sorts:sorts];
}

/**
 * 新しいProjectを作成する (insert)
 * @return NSManagedObject
 */
- (id) createProject
{
    NSString *tableName = @"Project";
    return [self insertNewObject:tableName];
}


/**
 * 条件を指定して取得する (select)
 * @param tableName 対象Entity名
 * @param NSPredicate データ取得条件
 * @param NSSortDescriptor ソート順
 * @return NSMutableArray (NSManagedObjectの配列)
 */
- (NSMutableArray *) getData:(NSString *)tableName predicate:(NSPredicate *)predicate sort:(NSSortDescriptor *)sort
{
    NSArray *sorts = nil;
    if(sort != nil)
    {
        sorts = [[NSArray alloc] initWithObjects:sort, nil];
    }
    return [self getData:tableName predicate:predicate sorts:sorts];
}

/**
 * 条件を指定して取得する (select)
 * @param tableName 対象Entity名
 * @param NSPredicate データ取得条件
 * @param NSArray ソート順 NSSortDescriptorの配列
 * @return NSMutableArray (NSManagedObjectの配列)
 */
- (NSMutableArray *) getData:(NSString *)tableName predicate:(NSPredicate *)predicate sorts:(NSArray *)sorts
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    //DailyReportを取得
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:context];
    [request setEntity:entity];
    //条件指定
    [request setPredicate:predicate];
    //ソート順指定
    if(sorts != nil)
    {
        [request setSortDescriptors:sorts];
    }
    
    NSError *error = nil;
    NSMutableArray *results = [[context executeFetchRequest:request error:&error] mutableCopy];
    if(results == nil){
        NSLog(@"フェッチ失敗");
    }
    return results;
}

/**
 * CoreDataにinsertする
 * @param tableName 対象Entity名
 * @return NSManagedObjectModel
 */
- (NSManagedObjectModel *) insertNewObject:(NSString *)tableName
{
    return [NSEntityDescription insertNewObjectForEntityForName:tableName inManagedObjectContext:context];
}

/**
 * CoreDataからDeleteする
 * @param 削除するobject
 */
- (void) deleteObject:(NSManagedObject *)obj
{
    [context deleteObject:obj];
}

/**
 * CoreDataの変更をcommitする
 */
- (void) saveData
{
    //CoreData save
    NSError *error = nil;
    if(![context save:&error]){
        NSLog(@"NSManagedObjectContext save error");
    }
    
    //アップロードフラグチェック
    Setting *st = [SettingController loadUserDefaults];
    
    if(st.canUpload){
        //インジケータ表示
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        //NSOperationQueueを作って...
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [queue setMaxConcurrentOperationCount:1];
        //NSInvocationOperationを作って...
        NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self
                                                                         selector:@selector(uploadData)
                                                                           object:nil];
        //queueにoperation追加
        [queue addOperation:op];
    }
}

/**
 * JSON-RPC実行
 */
-(void) uploadData
{
    @try {
        //UserIDとPasswordを取得
        Setting *st = [SettingController loadUserDefaults];
        
        //更新データ取得条件
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"upload_flag ==  0 OR upload_flag == nil"];
        
        //JSON-RPC
        DSJSONRPC *jsonRPC = [[DSJSONRPC alloc]
                              initWithServiceEndpoint:[NSURL URLWithString:st.url]];
        
        //DailyReport
        NSMutableArray *items = [self getDailyReport: predicate];
        for(id item in items){
            DailyReport *dailryReport = (DailyReport *) item;
            
            NSMutableDictionary *prm = [NSMutableDictionary dictionary];
            [prm setObject:st.partnerId forKey:@"user_id"];
            [prm setObject:st.password forKey:@"passwd"];
            [prm setObject:[self convertNumber:dailryReport.project_id]
                    forKey:@"project_id"];
            [prm setObject:[self convertNumber:dailryReport.report_date]
                    forKey:@"report_date"];
            [prm setObject:[self convertNumber:dailryReport.start_time]
                    forKey:@"start_time"];
            [prm setObject:[self convertNumber:dailryReport.end_time]
                    forKey:@"end_time"];
            //休憩時間を合計する
            [prm setObject:[self addLunchTime:dailryReport.lunch_time restTime:dailryReport.rest_time]
                    forKey:@"rest_time"];
            [prm setObject:[self convertString:dailryReport.detail]
                    forKey:@"detail"];
            [prm setObject:[self convertNumber:dailryReport.weather]
                    forKey:@"weather"];
            //TODO: delete_flag実装忘れ
            
            //JSON-RPC実行
            [jsonRPC callMethod:@"ImportDailyReport"
                 withParameters:prm
                   onCompletion:^(NSString *methodName, NSInteger callId, id methodResult, DSJSONRPCError *methodError, NSError* error){
                       dailryReport.upload_flag = [NSNumber numberWithInteger:1];
                       
                       //CoreData Save
                       NSError *err = nil;
                       if(![context save:&err]){
                           NSLog(@"NSManagedObjectContext save error");
                       }
                   }];
        } //end for
        
        //Report
        items = [self getReport:predicate];
        for(id item in items){
            Report *rp = (Report *)item;
            
            NSMutableDictionary *prm = [NSMutableDictionary dictionary];
            [prm setObject:st.partnerId forKey:@"user_id"];
            [prm setObject:st.password forKey:@"passwd"];
            [prm setObject:[self convertNumber:rp.project_id]
                    forKey:@"project_id"];
            [prm setObject:[self convertNumber:rp.report_id]
                    forKey:@"report_id"];
            [prm setObject:[self convertString:rp.report_name]
                    forKey:@"report_name"];
            [prm setObject:[self convertNumber:rp.start_date]
                    forKey:@"start_date"];
            [prm setObject:[self convertNumber:rp.end_date]
                    forKey:@"end_date"];
            [prm setObject:[self convertNumber:rp.delete_flag]
                    forKey:@"delete_flag"];
            
            //JSON-RPC実行
            [jsonRPC callMethod:@"ImportReport"
                 withParameters:prm
                   onCompletion:^(NSString *methodName, NSInteger callId, id methodResult, DSJSONRPCError *methodError, NSError* error){
                       rp.upload_flag = [NSNumber numberWithInteger:1];
                       
                       //CoreData Save
                       NSError *err = nil;
                       if(![context save:&err]){
                           NSLog(@"NSManagedObjectContext save error");
                       }
                   }];
        } //end for
        
        //Project
        items = [self getProject:predicate];
        for(id item in items){
            Project *pr = (Project *)item;
            
            NSMutableDictionary *prm = [NSMutableDictionary dictionary];
            [prm setObject:st.partnerId forKey:@"user_id"];
            [prm setObject:st.password forKey:@"passwd"];
            [prm setObject:[self convertNumber:pr.project_id]
                    forKey:@"project_id"];
            [prm setObject:[self convertString:pr.project_name]
                    forKey:@"project_name"];
            [prm setObject:[self convertString:pr.workspace]
                    forKey:@"workspace"];
            [prm setObject:[self convertString:pr.manager]
                    forKey:@"manager"];
            [prm setObject:[self convertNumber:pr.delete_flag]
                    forKey:@"delete_flag"];
            
            //JSON-RPC実行
            [jsonRPC callMethod:@"ImportProject"
                 withParameters:prm
                   onCompletion:^(NSString *methodName, NSInteger callId, id methodResult, DSJSONRPCError *methodError, NSError* error){
                       pr.upload_flag = [NSNumber numberWithInteger:1];
                       
                       //CoreData Save
                       NSError *err = nil;
                       if(![context save:&err]){
                           NSLog(@"NSManagedObjectContext save error");
                       }
                   }];
        } //end for
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception.description);
    }
    @finally {
        //インジケータ非表示
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
}

/**
 * 引数がnilの場合、空文字列に置き換える
 * @param value
 * @return NSString
 */
- (NSString *)convertString:(NSObject *)value
{
    NSString *ret = @"";
    @try {
        if(value != nil){
            ret = (NSString *)value;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception.description);
    }
    
    return ret;
}

/**
 * 引数がnilの場合、0に置き換える
 * @param value
 * @return NSNumber
 */
- (NSNumber *)convertNumber:(NSObject *)value
{
    NSNumber *ret = [NSNumber numberWithInteger:0];
    @try {
        if(value != nil){
            ret = (NSNumber *)value;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception.description);
    }
    
    return ret;
}

/**
 * 休憩時間合計
 */
- (NSNumber *)addLunchTime:(NSNumber *)lunch restTime:(NSNumber *)rest
{
    NSInteger val = [[self convertNumber:lunch] integerValue] +
        [[self convertNumber:rest] integerValue];
    return [NSNumber numberWithInteger:val];
}

@end

