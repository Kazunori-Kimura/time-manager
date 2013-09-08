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
+(BOOL)saveUserDefaults:(Setting *)setting{
    
    //NSUserDefaultsを取得
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    //Setting Objectから値を取得してNSUserDefaultsに格納
    if(setting != nil){
        if([setting.partnerId length] != 0){
            [ud setObject:setting.partnerId forKey:@"PartnerID"];
        }
        if([setting.partnerName length] != 0){
            [ud setObject:setting.partnerName forKey:@"UserName"];
        }
        if([setting.password length] != 0){
            [ud setObject:setting.password forKey:@"Password"];
        }
        if([setting.tel length] != 0){
            [ud setObject:setting.tel forKey:@"Tel"];
        }
        if([setting.naisen length] != 0){
            [ud setObject:setting.tel forKey:@"Naisen"];
        }
        if([setting.yobidasi length] != 0){
            [ud setObject:setting.tel forKey:@"Yobidasi"];
        }
        if([setting.mail length] != 0){
            [ud setObject:setting.mail forKey:@"Mail"];
        }
        if([setting.url length] != 0){
            [ud setObject:setting.url forKey:@"ServerUrl"];
        }
        [ud setBool:setting.canUpload forKey:@"Enabled"];
        
        //強制保存
        [ud synchronize];
        
        return YES;
    }
    
    return NO;
}

//NSUserDefaultsからデータを取得する
+(Setting *)loadUserDefaults{
    //NSUserDefaultsを取得
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    //初期値設定
    NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
    [defaults setObject:@"NO" forKey:@"Enabled"];
    [defaults setObject:@"http://localhost:3000/" forKey:@"ServerUrl"];
    [ud registerDefaults:defaults];
    
    Setting *st = [[Setting alloc] init];
    st.partnerId = [ud stringForKey:@"PartnerID"];
    st.partnerName = [ud stringForKey:@"UserName"];
    st.password = [ud stringForKey:@"Password"];
    st.tel = [ud stringForKey:@"Tel"];
    st.naisen = [ud stringForKey:@"Naisen"];
    st.yobidasi = [ud stringForKey:@"Yobidasi"];
    st.mail = [ud stringForKey:@"Mail"];
    st.url = [ud stringForKey:@"ServerUrl"];
    st.canUpload = [ud boolForKey:@"Enabled"];
    
    //NSLog(@"%@ %@", st.partnerId, st.url);
    
    return st;
}

@end
