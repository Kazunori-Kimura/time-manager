//
//  ViewController.m
//  TimeManager
//
//  Created by Kimura Kazunori on 2013/08/11.
//  Copyright (c) 2013年 Kimura Kazunori. All rights reserved.
//

#import "ViewController.h"
#import "DailyDetailViewController.h"

@interface ViewController ()

//今日
@property NSDate *today;
//CoreData登録のために今日日付をNSIntegerで保持
@property NSInteger report_date;

@end

@implementation ViewController

//今日ラベル
@synthesize labelToday;
//出勤時間
@synthesize labelStartTime;
//退勤時間
@synthesize labelEndTime;
//出勤ボタン
@synthesize buttonArrive;
//退勤ボタン
@synthesize buttonLeave;

//初期表示
- (void)viewDidLoad
{
    [super viewDidLoad];
	
    //今日日付取得
    self.today = [NSDate date];
    
    //ラベルに日付をセット yyyy/mm/dd (w)
    NSCalendar *c = [NSCalendar currentCalendar];
    NSDateComponents *comp = [c components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit fromDate:self.today];
    NSArray *weekday = [NSArray arrayWithObjects:@"", @"日", @"月", @"火", @"水", @"木", @"金", @"土", nil];
    labelToday.text = [NSString stringWithFormat:@"%d/%02d/%02d (%@)", comp.year, comp.month, comp.day, weekday[comp.weekday]];
    
    //CoreDataのキー
    self.report_date = comp.year * 10000 + comp.month * 100 * comp.day;
    
    //disable時の画像をセット
    [buttonArrive setImage:[UIImage imageNamed:@"button1-2.png"] forState:UIControlStateDisabled];
    [buttonLeave setImage:[UIImage imageNamed:@"button2-2.png"] forState:UIControlStateDisabled];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//出勤ボタンをタップ
- (IBAction)tapArrive:(id)sender {
    NSDate *d = [NSDate date];
    NSDateComponents *comp = [self getTime:d];
    
    //ラベルセット
    labelStartTime.text = [NSString stringWithFormat:@"%02d:%02d", comp.hour, comp.minute];
    //ボタン無効化
    [buttonArrive setEnabled:NO];
}

//退勤ボタンをタップ
- (IBAction)tapLeave:(id)sender {
    NSDate *d = [NSDate date];
    NSDateComponents *comp = [self getTime:d];
    
    //ラベルセット
    labelEndTime.text = [NSString stringWithFormat:@"%02d:%02d", comp.hour, comp.minute];
    //ボタン無効化
    [buttonLeave setEnabled:NO];
}

/**
 * NSDateからHHMMを取得
 * @param now {NSDate}
 * @return NSDateComponents (Hour, Minute)
 */
- (NSDateComponents *) getTime:(NSDate *)now {
    NSCalendar *c = [NSCalendar currentCalendar];
    NSDateComponents *comp = [c components:NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:now];
    return comp;
}

//画面遷移
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"mainToDetailViewSeque"]) {
        DailyDetailViewController *view = [segue destinationViewController];
        view.today = self.today;
    }
}
@end
