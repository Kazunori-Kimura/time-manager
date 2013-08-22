//
//  MonthlyReportViewController.h
//  TimeManager
//
//  Created by Kimura Kazunori on 2013/08/21.
//  Copyright (c) 2013年 Kimura Kazunori. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MonthlyReportViewController : UITableViewController

//表示中の日
@property NSDate *baseDate;
//今日
@property NSDate *today;
@property NSInteger today_value;

@property (weak, nonatomic) IBOutlet UILabel *labelYearMonth;
- (IBAction)tapPrevMonth:(id)sender;
- (IBAction)tapNextMonth:(id)sender;
- (IBAction)exportPdf:(id)sender;

@end
