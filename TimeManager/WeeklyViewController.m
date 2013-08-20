//
//  WeeklyViewController.m
//  TimeManager
//
//  Created by Kimura Kazunori on 2013/08/20.
//  Copyright (c) 2013年 Kimura Kazunori. All rights reserved.
//

#import "WeeklyViewController.h"

@interface WeeklyViewController ()

@end

@implementation WeeklyViewController

//1day = 24 * 60 * 60 sec
const int SEC_DAY = 86400;

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
    
    //今日
    self.today = [NSDate date];
    //今週の日曜日を取得
    NSCalendar *c = [NSCalendar currentCalendar];
    NSDateComponents *comp = [c components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit fromDate:self.today];
    self.baseDate = [self.today initWithTimeInterval: SEC_DAY * (1 - comp.weekday) sinceDate:self.today];
    
    //比較用
    self.today_value = comp.year * 10000 + comp.month * 100 + comp.day;
    
    self.tableView.rowHeight = 80;
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
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cellDate";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    [self updateCell:cell rowIndex:indexPath.row];
    
    return cell;
}

//cell更新
- (void)updateCell:(UITableViewCell *)cell rowIndex:(NSInteger)rowIndex
{
    UILabel *l1 = (UILabel*)[cell viewWithTag:1]; //year/month
    UILabel *l2 = (UILabel*)[cell viewWithTag:2]; //day (w)
    UILabel *l3 = (UILabel*)[cell viewWithTag:3]; //start_time
    UILabel *l4 = (UILabel*)[cell viewWithTag:4]; //end_time
    UILabel *l5 = (UILabel*)[cell viewWithTag:5]; //rest_time
    UILabel *l6 = (UILabel*)[cell viewWithTag:6]; //comment
    
    NSDate *d = [self.baseDate initWithTimeInterval:SEC_DAY * rowIndex sinceDate:self.baseDate];
    NSCalendar *c = [NSCalendar currentCalendar];
    NSDateComponents *comp = [c components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit fromDate:d];
    NSArray *weekday = [NSArray arrayWithObjects:@"", @"日", @"月", @"火", @"水", @"木", @"金", @"土", nil];
    
    UIColor *fontColor = [UIColor blackColor];
    NSInteger date = comp.year * 10000 + comp.month * 100 + comp.day;
    if(self.today_value == date){
        fontColor = [UIColor greenColor];
    }else if(comp.weekday == 1){
        //日曜日
        fontColor = [UIColor redColor];
    }else if(comp.weekday == 7){
        //土曜日
        fontColor = [UIColor blueColor];
    }
    
    l1.text = [NSString stringWithFormat:@"%04d/%02d", comp.year, comp.month];
    l1.textColor = fontColor;
    l2.text = [NSString stringWithFormat:@"%02d (%@)", comp.day, weekday[comp.weekday]];
    l2.textColor = fontColor;
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

- (IBAction)tapPrev:(id)sender {
    self.baseDate = [self.baseDate initWithTimeInterval: SEC_DAY * -7 sinceDate:self.baseDate];
    [self.tableView reloadData];
}

- (IBAction)tapNext:(id)sender {
    self.baseDate = [self.baseDate initWithTimeInterval: SEC_DAY * 7 sinceDate:self.baseDate];
    [self.tableView reloadData];
}
@end
