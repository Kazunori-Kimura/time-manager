//
//  DailyDetailViewController.m
//  TimeManager
//
//  Created by Kimura Kazunori on 2013/08/20.
//  Copyright (c) 2013年 Kimura Kazunori. All rights reserved.
//

#import "DailyDetailViewController.h"

@interface DailyDetailViewController ()

//更新対象の日 (CoreDataのキー)
@property NSInteger report_date;

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
        rows = 4;
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
            CellIdentifier = @"cellRestTime";
            cell = self.cellRestTime;
        }else if(indexPath.row == 3){
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

//Cell更新
- (void)updateCell:(UITableViewCell *)cell cellIdentifier:(NSString *)identifier {
    if([identifier isEqualToString:@"cellDate"]){
        [self updateCellDate:cell];
    }
}

//cellDate更新
- (void)updateCellDate:(UITableViewCell *)cell {
    //ラベル取得
    UILabel *l = (UILabel *)[cell viewWithTag:1];
    //前画面から渡された日付
    NSCalendar *c = [NSCalendar currentCalendar];
    NSDateComponents *comp = [c components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit fromDate:self.today];
    NSArray *w = [NSArray arrayWithObjects:@"", @"日", @"月", @"火", @"水", @"木", @"金", @"土", nil];
    
    l.text = [NSString stringWithFormat:@"%04d/%02d/%02d (%@)", comp.year, comp.month, comp.day, w[comp.weekday]];
    
    if(comp.weekday == 1){
        //日曜日
        l.textColor = [UIColor redColor];
    }else if(comp.weekday == 2){
        l.textColor = [UIColor blueColor];
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

@end
