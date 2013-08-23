//
//  ReportSettingsViewController.h
//  TimeManager
//
//  Created by Kimura Kazunori on 2013/08/21.
//  Copyright (c) 2013年 Kimura Kazunori. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportSettingsViewController : UITableViewController <UITextFieldDelegate, UIGestureRecognizerDelegate>
//section1
@property (weak, nonatomic) IBOutlet UITableViewCell *cellLunchTime;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellCompany;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellWorkspace;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellCustomer;
//section2
@property (weak, nonatomic) IBOutlet UITableViewCell *cellUserName;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellTel;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellTel2;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellTel3;

@property (weak, nonatomic) IBOutlet UITextField *textLunchTime;
@property (weak, nonatomic) IBOutlet UITextField *textCompany;
@property (weak, nonatomic) IBOutlet UITextField *textWorkplace;
@property (weak, nonatomic) IBOutlet UITextField *textManager;

@property (weak, nonatomic) IBOutlet UITextField *textUserName;
@property (weak, nonatomic) IBOutlet UITextField *textTel;
@property (weak, nonatomic) IBOutlet UITextField *textNaisen;
@property (weak, nonatomic) IBOutlet UITextField *textYobidasi;

- (IBAction)saveSetting:(id)sender;

@end
