//
//  ReportSettingsViewController.m
//  TimeManager
//
//  Created by Kimura Kazunori on 2013/08/21.
//  Copyright (c) 2013年 Kimura Kazunori. All rights reserved.
//

#import "ReportSettingsViewController.h"
#import "Setting.h"
#import "SettingController.h"
#import "DataManager.h"
#import "Project.h"
#import "MyUtil.h"

@interface ReportSettingsViewController ()

@property Setting *setting;
@property Project *project;
@property DataManager *dataManager;
@property(nonatomic, strong) UITapGestureRecognizer *singleTap;

@end

@implementation ReportSettingsViewController

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
    
    self.labelValidateMessage.hidden = YES;
    
    //UserDefaults取得
    self.setting = [SettingController loadUserDefaults];
    //Project取得
    self.dataManager = [[DataManager alloc] init];
    NSMutableArray *arr = [self.dataManager getProjectById:1];
    if(arr != nil && arr.count > 0){
        self.project = (Project *)arr[0];
    }else{
        self.project = [self.dataManager createProject];
        self.project.project_id = [NSNumber numberWithInteger:1];
    }
    
    self.singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSingleTap:)];
    self.singleTap.delegate = self;
    self.singleTap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:self.singleTap];
    
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
    // Return the number of rows in the section.
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if(indexPath.section == 0){
        //section1
        if(indexPath.row == 0){
            //昼休憩
            cell = self.cellLunchTime;
            self.textLunchTime.text = [NSString stringWithFormat:@"%d", self.project.base_rest_time.integerValue];
        }else if(indexPath.row == 1){
            //勤務先
            cell = self.cellCompany;
            if(self.project.company_name != nil){
                self.textCompany.text = self.project.company_name;
            }
        }else if(indexPath.row == 2){
            //作業場所
            cell = self.cellWorkspace;
            if(self.project.workspace != nil){
                self.textWorkplace.text = self.project.workspace;
            }
        }else if(indexPath.row == 3){
            //責任者
            cell = self.cellCustomer;
            if(self.project.manager != nil){
                self.textManager.text = self.project.manager;
            }
        }
    }else if(indexPath.section == 1){
        //section2
        if(indexPath.row == 0){
            //氏名
            cell = self.cellUserName;
            if(self.setting.partnerName != nil){
                self.textUserName.text = self.setting.partnerName;
            }
        }else if(indexPath.row == 1){
            //電話番号
            cell = self.cellTel;
            if(self.setting.tel != nil){
                self.textTel.text = self.setting.tel;
            }
        }else if(indexPath.row == 2){
            //内線番号
            cell = self.cellTel2;
            if(self.setting.naisen != nil){
                self.textNaisen.text = self.setting.naisen;
            }
        }else if(indexPath.row == 3){
            //呼出方
            cell = self.cellTel3;
            if(self.setting.yobidasi != nil){
                self.textYobidasi.text = self.setting.yobidasi;
            }
        }
    }
    
    // Configure the cell...
    
    return cell;
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

//昼休憩が数字かをチェック
- (BOOL)validateInputData
{
    BOOL ret = YES;
    NSString *msg;
    if(![MyUtil validateString:self.textLunchTime.text withPattern:@"^[0-9]+$"]){
        ret = NO;
        msg = @"昼休憩に誤りがあります。";
    }
    
    if(!ret){
        [self showMessage:msg success:ret];
    }
    
    return ret;
}

- (IBAction)saveSetting:(id)sender {
    if([self validateInputData]){
        //各フィールドの値を取得
        //self.setting.lunchTime = [self.textLunchTime.text integerValue];
        self.setting.tel = self.textTel.text;
        self.setting.naisen = self.textNaisen.text;
        self.setting.yobidasi = self.textYobidasi.text;
        //保存
        [SettingController saveUserDefaults:self.setting];
    
        self.project.base_rest_time = [NSNumber numberWithInteger:[self.textLunchTime.text integerValue]];
        self.project.company_name = self.textCompany.text;
        self.project.workspace = self.textWorkplace.text;
        self.project.manager = self.textManager.text;
        //保存
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

//タップしたらキーボード閉じる
-(void)onSingleTap:(UITapGestureRecognizer *)recognizer {
    [self.view endEditing:YES];
}

@end
