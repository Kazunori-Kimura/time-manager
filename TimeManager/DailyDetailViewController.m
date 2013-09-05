//
//  DailyDetailViewController.m
//  TimeManager
//
//  Created by Kimura Kazunori on 2013/08/20.
//  Copyright (c) 2013年 Kimura Kazunori. All rights reserved.
//

#import "DailyDetailViewController.h"
#import "MyUtil.h"
#import "DataManager.h"
#import "DailyReport.h"

@interface DailyDetailViewController ()

//更新対象の日 (CoreDataのキー)
@property NSInteger report_date;

@property DataManager *dataManager;
@property DailyReport *dataDay;

//タップ対応
@property(nonatomic, strong) UITapGestureRecognizer *singleTap;

@end

@implementation DailyDetailViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //タップ対応
    self.singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSingleTap:)];
    self.singleTap.delegate = self;
    self.singleTap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:self.singleTap];
    
    //メッセージ非表示
    self.labelValidateMessage.hidden = YES;
    
    //日付取得
    self.report_date = [MyUtil numberFromDate:self.today];
    NSLog(@"%d", self.report_date);
    
    //DataManager準備
    self.dataManager = [[DataManager alloc] init];
    //全画面から引き渡された日付をもとにデータを取得
    NSMutableArray *arr = [self.dataManager getDailyReportByReportDate:self.report_date];
    if(arr != nil && arr.count > 0){
        self.dataDay = (DailyReport *) arr[0];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    
    if(section == 0){
        rows = 1;
    }else{
        rows = 5;
    }
    
    // Return the number of rows in the section.
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell;
    
    if(indexPath.section == 0){
        //section1は一個
        CellIdentifier = @"cellDate";
        cell = self.cellDate;
    }else{
        if(indexPath.row == 0){
            CellIdentifier = @"cellStartTime";
            cell = self.cellStartTime;
        }else if(indexPath.row == 1){
            CellIdentifier = @"cellEndTime";
            cell = self.cellEndTime;
        }else if(indexPath.row == 2){
            CellIdentifier = @"cellLunchTime";
            cell = self.cellLunchTime;
        }else if(indexPath.row == 3){
            CellIdentifier = @"cellRestTime";
            cell = self.cellRestTime;
        }else if(indexPath.row == 4){
            CellIdentifier = @"cellDetail";
            cell = self.cellDetail;
        }
    }
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    [self updateCell:cell cellIdentifier:CellIdentifier];
    
    return cell;
}

/**
 * Cell更新
 */
- (void)updateCell:(UITableViewCell *)cell cellIdentifier:(NSString *)identifier {
    if([identifier isEqualToString:@"cellDate"]){
        [self updateCellDate:cell];
    }else if([identifier isEqualToString:@"cellStartTime"]){
        [self updateCellStartTime:cell];
    }else if([identifier isEqualToString:@"cellEndTime"]){
        [self updateCellEndTime:cell];
    }else if([identifier isEqualToString:@"cellLunchTime"]){
        [self updateCellLunchTime:cell];
    }else if([identifier isEqualToString:@"cellRestTime"]){
        [self updateCellRestTime:cell];
    }else if([identifier isEqualToString:@"cellDetail"]){
        [self updateCellComment:cell];
    }
}

/**
 * cellDate更新
 */
- (void)updateCellDate:(UITableViewCell *)cell {
    //ラベル取得
    UILabel *l = (UILabel *)[cell viewWithTag:1];
    l.text = [MyUtil stringFromDate:self.today];
    
    NSDateComponents *comp = [MyUtil dateComponentFromDate:self.today];
    if(comp.weekday == 1){
        //日曜日
        l.textColor = [UIColor redColor];
    }else if(comp.weekday == 7){
        //土曜日
        l.textColor = [UIColor blueColor];
    }
}

/**
 * 出勤
 */
- (void)updateCellStartTime:(UITableViewCell *)cell {
    if(self.dataDay != nil){
        self.textStartTime.text = [MyUtil stringHourMinute:self.dataDay.start_time];
    }
}

/**
 * 退勤
 */
- (void)updateCellEndTime:(UITableViewCell *)cell {
    if(self.dataDay != nil){
        self.textEndTime.text = [MyUtil stringHourMinute:self.dataDay.end_time];
    }
}

/**
 * 昼休憩
 */
- (void)updateCellLunchTime:(UITableViewCell *)cell {
    if(self.dataDay != nil){
        self.textLunchTime.text = self.dataDay.lunch_time.stringValue;
    }
}

/**
 * 昼以外の休憩
 */
-(void)updateCellRestTime:(UITableViewCell *)cell {
    if(self.dataDay != nil){
        self.textRestTime.text = self.dataDay.rest_time.stringValue;
    }
}

/**
 * 作業内容
 */
-(void)updateCellComment:(UITableViewCell *)cell {
    if(self.dataDay != nil){
        self.textComment.text = self.dataDay.detail;
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

/**
 * 入力値のチェック
 */
-(BOOL)validateInputData
{
    BOOL ret = YES;
    NSString *msg;
    //開始時刻
    if (! [MyUtil validateString:self.textStartTime.text withPattern:@"^[0-9]{1,2}:[0-9]{1,2}$"]){
        ret = NO;
        msg = @"出勤時刻に誤りがあります。";
    }
    //終了時刻
    else if (! [MyUtil validateString:self.textEndTime.text withPattern:@"^[0-9]{1,2}:[0-9]{1,2}$"]){
        ret = NO;
        msg = @"退勤時刻に誤りがあります。";
    }
    //昼休憩
    else if(! [MyUtil validateString:self.textLunchTime.text withPattern:@"^[0-9]+$"]){
        ret = NO;
        msg = @"昼休憩に誤りがあります。";
    }
    //昼以外の休憩
    else if(! [MyUtil validateString:self.textRestTime.text withPattern:@"^[0-9]+$"]){
        ret = NO;
        msg = @"昼以外の休憩に誤りがあります。";
    }
    
    if(ret == NO){
        [self showMessage:msg success:ret];
    }
    
    return ret;
}

/**
 * 入力データを取得してCoreDataを更新する
 */
-(void)updateDailyReport
{
    if(self.dataDay == nil){
        //DailyReport作成
        self.dataDay = [self.dataManager createDailyReport];
        self.dataDay.report_date = [NSNumber numberWithInt:self.report_date];
    }
    //出勤時刻
    self.dataDay.start_time = [MyUtil numberFromTimeString:self.textStartTime.text];
    //退勤時刻
    self.dataDay.end_time = [MyUtil numberFromTimeString:self.textEndTime.text];
    //昼休憩
    self.dataDay.lunch_time = [NSNumber numberWithInteger:self.textLunchTime.text.integerValue];
    //休憩時間
    self.dataDay.rest_time = [NSNumber numberWithInteger:self.textRestTime.text.integerValue];
    //作業内容
    self.dataDay.detail = self.textComment.text;
}

- (IBAction)saveData:(id)sender {
    if([self validateInputData]){
        //データ取得処理
        [self updateDailyReport];
        //CoreData保存
        [self.dataManager saveData];
        //メッセージ表示
        [self showMessage:@"保存しました。" success:YES];
    }
}

//メッセージ表示
-(void)showMessage:(NSString *)message success:(BOOL)success
{
    //color: http://www.sirochro.com/note/objc-uicolor-rgb/
    if(success){
        self.labelValidateMessage.backgroundColor = [UIColor colorWithRed:0.235
                                                                    green:0.702
                                                                     blue:0.443
                                                                    alpha:0.8];
        self.labelValidateMessage.textColor = [UIColor colorWithRed:0
                                                              green:0.392
                                                               blue:0
                                                              alpha:1];
    }else{
        //error
        self.labelValidateMessage.backgroundColor = [UIColor colorWithRed:0.804
                                                                    green:0.361
                                                                     blue:0.361
                                                                    alpha:0.8];
        self.labelValidateMessage.textColor = [UIColor colorWithRed:0.545
                                                              green:0
                                                               blue:0
                                                              alpha:1];
    }
    
    self.labelValidateMessage.text = message;
    self.labelValidateMessage.hidden = NO;
}

//タップ時の処理
-(void)onSingleTap:(UITapGestureRecognizer *)recognizer {
    [self.view endEditing:YES];
}
@end
