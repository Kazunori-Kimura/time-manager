//
//  PdfWriter.m
//  TimeManager
//
//  Created by Kimura Kazunori on 2013/08/22.
//  Copyright (c) 2013年 Kimura Kazunori. All rights reserved.
//

#import "PdfWriter.h"
#import "MyUtil.h"
#import "SettingController.h"
#import "Setting.h"
#import "DataManager.h"
#import "DailyReport.h"
#import "Project.h"

@implementation PdfWriter
/**
 * PDFファイルを出力する
 * @param date 対象日付
 * @return ファイルパス
 */
- (NSString *) exportPdf:(NSDate *)date
{
    //dateからファイル名を生成する
    NSDateComponents *comp = [MyUtil dateComponentFromDate:date];
    
    NSString *fileName = [NSString
                          stringWithFormat:@"Report_%04d-%02d.pdf",
                          comp.year, comp.month];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *pdfPath = [path stringByAppendingPathComponent: fileName];
    
    //PDFContext
    UIGraphicsBeginPDFContextToFile(pdfPath, CGRectZero, nil);
    
    //ページ作成
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 612, 792), nil);
    
    //背景画像をセット
    UIImage *image = [UIImage imageNamed:@"pdf_back.png"];
    CGPoint p1 = CGPointMake(0, 0);
    [image drawAtPoint:p1];
    
    //UserDefaults取得
    Setting *st = [SettingController loadUserDefaults];
    //Project取得
    DataManager *dm = [[DataManager alloc] init];
    
    Project *p;
    NSMutableArray *pa = [dm getProjectById:1];
    if(pa != nil && pa.count > 0){
        p = (Project *)pa[0];
    }else{
        p = [dm createProject];
    }

    //年
    [self drawText:[NSString stringWithFormat:@"%04d", comp.year] positionX:96 positionY:32];
    //月
    [self drawText:[NSString stringWithFormat:@"%02d", comp.month] positionX:430 positionY:32];
    if(st.partnerId != nil || st.partnerId.length > 0){
        //PartnetID設定時
        [self drawText:@"パートナーID" positionX:64 positionY:76];
        [self drawText:st.partnerId positionX:110 positionY:76];
    }
    //会社名
    [self drawText:p.company_name positionX:300 positionY:76];
    //氏名
    [self drawText:st.partnerName positionX:110 positionY:98];
    //作業場所
    [self drawText:p.workspace positionX:300 positionY:98];
    //連絡先
    [self drawText:st.tel positionX:420 positionY:86];
    //内線番号
    [self drawText:st.naisen positionX:426 positionY:100];
    //呼出方
    [self drawText:st.yobidasi positionX:506 positionY:100];
    //責任者
    [self drawText:p.manager positionX:458 positionY:730];
    
    //合計時間(分)
    NSInteger min = 0;
    DailyReport *dr;
    NSInteger lastDay = [MyUtil getLastDay:date];
    for(NSInteger day=1; day <= lastDay; day++){
        //対象日
        NSDate *targetDate = [MyUtil initWithDayInterval: day-1 fromDate:date];
        //月/日
        [self drawText:[MyUtil stringMonthDayFromDate:targetDate] positionX:62 positionY:156 + 20 * (day - 1)];
        //曜日
        [self drawText:[MyUtil stringWeekday:targetDate] positionX:94 positionY:156 + 20 * (day - 1)];
        
        NSInteger reportDate = [MyUtil numberFromDate:targetDate];
        NSMutableArray *arrDaily = [dm getDailyReportByReportDate:reportDate];
        if(arrDaily != nil && arrDaily.count > 0){
            dr = (DailyReport *)arrDaily[0];
            //112    156    開始時刻
            [self drawText:[MyUtil stringHourMinute:dr.start_time] positionX:112 positionY:156 + 20 * (day - 1)];
            //172    156    退社時刻
            [self drawText:[MyUtil stringHourMinute:dr.end_time] positionX:172 positionY:156 + 20 * (day - 1)];
            //230    156    昼休憩
            [self drawText:[MyUtil stringHourMinute:dr.lunch_time] positionX:230 positionY:156 + 20 * (day - 1)];
            //268    156    昼以外の休憩
            [self drawText:[MyUtil stringHourMinute:dr.rest_time] positionX:268 positionY:156 + 20 * (day - 1)];
            //324    156    作業時間
            NSInteger wt = [MyUtil diffTime:dr.start_time endTime:dr.end_time lunchTime:dr.lunch_time restTime:dr.rest_time];
            min += wt;
            [self drawText:[MyUtil formatMinute:wt] positionX:324 positionY:156 + 20 * (day - 1)];
            //406    156    作業内容
            [self drawText:dr.detail positionX:406 positionY:156 + 20 * (day - 1)];
        }
    }
    
    //PDFコンテキストを閉じる
    UIGraphicsEndPDFContext();
    
    return pdfPath;
}


/**
 * 位置を指定してテキストを描画する
 * @param text 描画テキスト
 * @param positionX 位置(X軸)
 * @param positionY 位置(Y軸)
 */
- (void) drawText:(NSString *)text
        positionX:(NSInteger)x positionY:(NSInteger)y
{
    UIFont *f = [UIFont systemFontOfSize: 12];
    [self drawText:text font:f positionX:x positionY:y];
}

/**
 * 位置とフォントを指定してテキストを描画する
 * @param text 描画テキスト
 * @param font 使用フォント
 * @param positionX 位置(X軸)
 * @param positionY 位置(Y軸)
 */
- (void) drawText:(NSString *)text font:(UIFont *)font
        positionX:(NSInteger)x positionY:(NSInteger)y
{
    //描画文字列のサイズを取得
    CGSize maxSize = CGSizeMake(612, 72);
    CGSize textSize = [text sizeWithFont: font constrainedToSize:maxSize lineBreakMode:NSLineBreakByClipping];
    
    //描画領域
    CGRect textRect = CGRectMake(x, y, textSize.width, textSize.height);
    
    //描画
    [text drawInRect:textRect withFont:font];
    
}
@end
