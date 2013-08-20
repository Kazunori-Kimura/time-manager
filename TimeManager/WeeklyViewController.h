//
//  WeeklyViewController.h
//  TimeManager
//
//  Created by Kimura Kazunori on 2013/08/20.
//  Copyright (c) 2013年 Kimura Kazunori. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeeklyViewController : UITableViewController

//基準日付
@property NSDate *baseDate;
//今日
@property NSDate *today;

@property NSInteger today_value;

- (IBAction)tapPrev:(id)sender;
- (IBAction)tapNext:(id)sender;

@end
