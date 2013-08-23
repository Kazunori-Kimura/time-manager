//
//  Setting.h
//  TimeManager
//
//  Created by Kimura Kazunori on 2013/08/22.
//  Copyright (c) 2013年 Kimura Kazunori. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Setting : NSObject

@property (nonatomic, copy) NSString *partnerId;
@property (nonatomic, copy) NSString *partnerName;
@property (nonatomic, copy) NSString *password;

@property (nonatomic, copy) NSString *mail;
@property (nonatomic, copy) NSString *url;
@property NSInteger lunchTime;
@property BOOL canUpload;

@property (nonatomic, copy) NSString *tel;
@property (nonatomic, copy) NSString *naisen;
@property (nonatomic, copy) NSString *yobidasi;

@end
