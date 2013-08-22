//
//  SettingController.m
//  TimeManager
//
//  Created by Kimura Kazunori on 2013/08/22.
//  Copyright (c) 2013年 Kimura Kazunori. All rights reserved.
//

#import "SettingController.h"
#import "Setting.h"

@implementation SettingController

//NSUserDefaultsにデータを保存する
-(BOOL)saveSetting:(Setting *)setting{
    
    //NSUserDefaultsを取得
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    //Setting Objectから値を取得してNSUserDefaultsに格納
    if(setting != nil){
        if([setting.partnerId length] != 0){
            [ud setObject:setting.partnerId forKey:@"PARTNER_ID"];
        }
        if([setting.partnerName length] != 0){
            [ud setObject:setting.partnerName forKey:@"PARTNER_NAME"];
        }
        if([setting.password length] != 0){
            [ud setObject:setting.password forKey:@"PASSWORD"];
        }
        if([setting.tel length] != 0){
            [ud setObject:setting.tel forKey:@"TEL"];
        }
        if([setting.mail length] != 0){
            [ud setObject:setting.mail forKey:@"MAIL"];
        }
        if([setting.url length] == 0){
            //[TODO] URLを外出しにしたい
            setting.url = @"http://www.exsample.com";
        }
        [ud setObject:setting.url forKey:@"URL"];
        //強制保存
        [ud synchronize];
        
        return YES;
    }
    
    return NO;
}

//NSUserDefaultsからデータを取得する
-(Setting *)load{
    //NSUserDefaultsを取得
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    //初期値を定義
    NSMutableDictionary *def = [NSMutableDictionary dictionary];
    //[TODO] URLを外出しにしたい
    [def setObject:@"k1342sh" forKey:@"PARTNER_ID"];
    [def setObject:@"abc123" forKey:@"PASSWORD"];
    [def setObject:@"http://www.exsample.com" forKey:@"URL"];
    //NSUserDefaultsに初期値を設定する
    [ud registerDefaults:def];
    
    Setting *st = [[Setting alloc] init];
    st.partnerId = [ud stringForKey:@"PARTNER_ID"];
    st.partnerName = [ud stringForKey:@"PARTNER_NAME"];
    st.password = [ud stringForKey:@"PASSWORD"];
    st.tel = [ud stringForKey:@"TEL"];
    st.mail = [ud stringForKey:@"MAIL"];
    st.url = [ud stringForKey:@"URL"];
    
    NSLog(@"確認 %@", st.url);
    
    return st;
}

@end
