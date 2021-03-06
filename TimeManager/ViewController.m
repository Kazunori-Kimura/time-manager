//
//  ViewController.m
//  TimeManager
//
//  Created by Kimura Kazunori on 2013/08/11.
//  Copyright (c) 2013年 Kimura Kazunori. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "ViewController.h"
#import "DailyDetailViewController.h"
#import "DataManager.h"
#import "DailyReport.h"
#import "Project.h"
#import "MyUtil.h"
#import "Setting.h"
#import "SettingController.h"

@interface ViewController ()

//今日
@property NSDate *today;
//CoreData登録のために今日日付をNSIntegerで保持
@property NSInteger report_date;

@property DailyReport *dailyReport;
@property Project *project;
@property (nonatomic, retain) DataManager *dm;
@property Setting *setting;

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
	
    self.navigationController.delegate = self;
    
    //今日日付取得
    self.today = [NSDate date];
    
    //ラベルに日付をセット yyyy/mm/dd (w)
    NSDateComponents *comp = [MyUtil dateComponentFromDate:self.today];
    labelToday.text = [NSString stringWithFormat:@"%d/%02d/%02d (%@)", comp.year, comp.month, comp.day,
                       [MyUtil stringWeekday:self.today]];
    
    //CoreDataのキー
    self.report_date = comp.year * 10000 + comp.month * 100 + comp.day;
    //NSLog(@"today = %d", self.report_date);
    //disable時の画像をセット
    [buttonArrive setImage:[UIImage imageNamed:@"button1-2.png"] forState:UIControlStateDisabled];
    [buttonLeave setImage:[UIImage imageNamed:@"button2-2.png"] forState:UIControlStateDisabled];
    
    //CoreData
    self.dm = [[DataManager alloc] init];
    //Projectがなければ作成する
    NSMutableArray *pa = [self.dm getProjectById:1];
    if(pa != nil && pa.count > 0){
        self.project = (Project *)pa[0];
    }else{
        self.project = [self.dm createProject];
        self.project.project_id = [NSNumber numberWithInteger:1];
    }
    
    //DailyReportを取得
    self.dailyReport = nil;
    [self updateLabelText];
    
    //共通設定取得
    self.setting = [SettingController loadUserDefaults];
}

/**
 * 出勤・退勤時間を取得
 */
-(void)updateLabelText
{
    //CoreData
    self.dm = [[DataManager alloc] init];
    //DailyReportを取得
    NSMutableArray *results = [self.dm getDailyReportByReportDate:self.report_date];
    if(results != nil && results.count > 0){
        self.dailyReport = (DailyReport *) results[0]; //キー項目なので一個だけのはず
        
        //出勤時間が設定されている？
        if(self.dailyReport.start_time != nil && self.dailyReport.start_time.integerValue > 0){
            NSLog(@"start_time=%d", self.dailyReport.start_time.integerValue);
            labelStartTime.text = [MyUtil stringHourMinute:self.dailyReport.start_time];
            [buttonArrive setEnabled:NO];
        }
        //退勤時間が設定されている？
        if(self.dailyReport.end_time != nil && self.dailyReport.end_time.integerValue > 0){
            labelEndTime.text = [MyUtil stringHourMinute:self.dailyReport.end_time];
            [buttonLeave setEnabled:NO];
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//出勤ボタンをタップ
- (IBAction)tapArrive:(id)sender {
    NSDate *d = [NSDate date];
    NSDateComponents *comp = [MyUtil dateComponentFromDate:d];
    
    //ラベルセット
    labelStartTime.text = [NSString stringWithFormat:@"%02d:%02d", comp.hour, comp.minute];
    //ボタン無効化
    [buttonArrive setEnabled:NO];
    
    if(self.dailyReport == nil){
        self.dailyReport = [self.dm createDailyReport:[NSNumber numberWithInt:self.report_date]
                                            projectId:[NSNumber numberWithInteger:1]];
    }
    self.dailyReport.start_time = [NSNumber numberWithInt:comp.hour * 100 + comp.minute];
    
    NSInteger st = [MyUtil convertMinute:self.dailyReport.start_time];
    NSInteger et = [MyUtil convertMinute:self.dailyReport.end_time];
    if(self.project.base_rest_time.integerValue < (et - st)){
        self.dailyReport.lunch_time = self.project.base_rest_time;
    }
    
    [self.dm saveData];
}

//退勤ボタンをタップ
- (IBAction)tapLeave:(id)sender {
    NSDate *d = [NSDate date];
    NSDateComponents *comp = [MyUtil dateComponentFromDate:d];
    
    //ラベルセット
    labelEndTime.text = [NSString stringWithFormat:@"%02d:%02d", comp.hour, comp.minute];
    //ボタン無効化
    [buttonLeave setEnabled:NO];
    
    if(self.dailyReport == nil){
        self.dailyReport = [self.dm createDailyReport:[NSNumber numberWithInt:self.report_date]
                                            projectId:[NSNumber numberWithInteger:1]];
    }
    self.dailyReport.end_time = [NSNumber numberWithInt:comp.hour * 100 + comp.minute];
    
    //TODO 昼休憩を計算
    // 作業時間が昼休憩時間より大きい場合は昼休憩をセット
    // 作業時間より休憩時間が大きくなる場合は 0 とする
    NSInteger st = [MyUtil convertMinute:self.dailyReport.start_time];
    NSInteger et = [MyUtil convertMinute:self.dailyReport.end_time];
    if(self.project.base_rest_time.integerValue < (et - st)){
        self.dailyReport.lunch_time = self.project.base_rest_time;
    }
    
    [self.dm saveData];
}

//画面遷移
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"mainToDetailViewSeque"]) {
        DailyDetailViewController *view = [segue destinationViewController];
        view.today = self.today;
    }
}

//NavigationController遷移処理

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    if ([viewController isEqual:self]) {
        [self viewDidAppear:animated];
        //出勤・退勤時間更新
        [self updateLabelText];
        NSLog(@"didShowViewController");
    }
}
@end
