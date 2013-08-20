//
//  ViewController.h
//  TimeManager
//
//  Created by Kimura Kazunori on 2013/08/11.
//  Copyright (c) 2013年 Kimura Kazunori. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *labelToday;
@property (weak, nonatomic) IBOutlet UIButton *buttonArrive;
@property (weak, nonatomic) IBOutlet UIButton *buttonLeave;
@property (weak, nonatomic) IBOutlet UILabel *labelStartTime;
@property (weak, nonatomic) IBOutlet UILabel *labelEndTime;

- (IBAction)tapArrive:(id)sender;
- (IBAction)tapLeave:(id)sender;

@end
