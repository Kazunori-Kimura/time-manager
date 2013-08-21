//
//  DailyDetailViewController.h
//  TimeManager
//
//  Created by Kimura Kazunori on 2013/08/20.
//  Copyright (c) 2013年 Kimura Kazunori. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DailyDetailViewController : UITableViewController

@property NSDate *today;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellDate;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellStartTime;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellEndTime;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellRestTime;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellDetail;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellLunchTime;

- (IBAction)saveData:(id)sender;
@end
