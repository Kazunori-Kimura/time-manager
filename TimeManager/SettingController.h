//
//  SettingController.h
//  TimeManager
//
//  Created by Kimura Kazunori on 2013/08/22.
//  Copyright (c) 2013年 Kimura Kazunori. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Setting.h"

@interface SettingController : NSObject
+(BOOL)saveUserDefaults:(Setting *)setting;
+(Setting *)loadUserDefaults;
@end
