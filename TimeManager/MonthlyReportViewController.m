//
//  MonthlyReportViewController.m
//  TimeManager
//
//  Created by Kimura Kazunori on 2013/08/21.
//  Copyright (c) 2013年 Kimura Kazunori. All rights reserved.
//

#import "MonthlyReportViewController.h"

@interface MonthlyReportViewController ()

@end

@implementation MonthlyReportViewController

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
    
    NSDate *today = [NSDate date];
    //今日
    NSCalendar *c = [NSCalendar currentCalendar];
    NSDateComponents *comp = [c components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:today];
    
    //ラベル更新
    self.labelYearMonth.text = [NSString stringWithFormat:@"%04d年 %02d月", comp.year, comp.month];
    
    //１日を取得
    comp.day = 1;
    self.baseDate = [c dateFromComponents:comp];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self getLastDay:self.baseDate];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cellMonthReport";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    [self updateCell:cell rowIndex:indexPath.row];
    
    return cell;
}

//cell更新
- (void)updateCell:(UITableViewCell *)cell rowIndex:(NSInteger)rowIndex
{
    UILabel *l1 = (UILabel*)[cell viewWithTag:1]; //day (w)
    UILabel *l2 = (UILabel*)[cell viewWithTag:2]; //start_time
    UILabel *l3 = (UILabel*)[cell viewWithTag:3]; //end_time
    UILabel *l4 = (UILabel*)[cell viewWithTag:4]; //lunch_time
    UILabel *l5 = (UILabel*)[cell viewWithTag:5]; //rest_time
    
    NSDate *d = [self.baseDate initWithTimeInterval:86400 * rowIndex sinceDate:self.baseDate];
    NSCalendar *c = [NSCalendar currentCalendar];
    NSDateComponents *comp = [c components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit fromDate:d];
    NSArray *weekday = [NSArray arrayWithObjects:@"", @"日", @"月", @"火", @"水", @"木", @"金", @"土", nil];
    
    UIColor *fontColor = [UIColor blackColor];
    if(comp.weekday == 1){
        //日曜日
        fontColor = [UIColor redColor];
    }else if(comp.weekday == 7){
        //土曜日
        fontColor = [UIColor blueColor];
    }
    
    l1.text = [NSString stringWithFormat:@"%02d (%@)", comp.day, weekday[comp.weekday]];
    l1.textColor = fontColor;
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
 * 月末の日にちを取得する
 * @param NSDate
 * @return 月末の日にち
 */
-(NSInteger)getLastDay:(NSDate *)date
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSRange range = [cal rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date];
    return range.length;
}

//ヘッダー部分更新
-(void)updateTableHeader
{
    NSCalendar *c = [NSCalendar currentCalendar];
    NSDateComponents *comp = [c components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self.baseDate];
    //header
    self.labelYearMonth.text = [NSString stringWithFormat:@"%04d年 %02d月", comp.year, comp.month];
}

//前月
- (IBAction)tapPrevMonth:(id)sender {
    NSCalendar *c = [NSCalendar currentCalendar];
    NSDateComponents *comp = [c components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self.baseDate];
    comp.month--;
    self.baseDate = [c dateFromComponents:comp];
    
    //header
    [self updateTableHeader];
    //reload
    [self.tableView reloadData];
}

//翌月
- (IBAction)tapNextMonth:(id)sender {
    NSCalendar *c = [NSCalendar currentCalendar];
    NSDateComponents *comp = [c components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self.baseDate];
    comp.month++;
    self.baseDate = [c dateFromComponents:comp];
    
    //header
    [self updateTableHeader];
    //reload
    [self.tableView reloadData];
}

- (IBAction)exportPdf:(id)sender {
}
@end
