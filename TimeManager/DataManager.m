//
//  DataManager.m
//  TimeManager
//
//  Created by Kimura Kazunori on 2013/08/19.
//  Copyright (c) 2013年 Kimura Kazunori. All rights reserved.
//

#import "DataManager.h"
#import <CoreData/CoreData.h>

@implementation DataManager

@synthesize context;

- (id)init
{
    [self getManagedObjectContext];
    return self;
}


// アプリケーションのDocumentsディレクトリへのパスを返す
- (NSString *)applicationDocumentsDirectory
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [path lastObject];
}

// NSManagedObjectContextをインスタンス化
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

@end
