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

@property (weak, nonatomic) IBOutlet UITextField *textStartTime;
@property (weak, nonatomic) IBOutlet UITextField *textEndTime;
@property (weak, nonatomic) IBOutlet UITextField *textLunchTime;
@property (weak, nonatomic) IBOutlet UITextField *textRestTime;
@property (weak, nonatomic) IBOutlet UITextField *textComment;

- (IBAction)saveData:(id)sender;
@end
