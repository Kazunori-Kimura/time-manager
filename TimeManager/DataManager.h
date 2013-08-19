//
//  DataManager.h
//  TimeManager
//
//  Created by Kimura Kazunori on 2013/08/19.
//  Copyright (c) 2013年 Kimura Kazunori. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject
{
    NSManagedObjectContext *context;
}

@property (nonatomic, retain) NSManagedObjectContext *context;

@end