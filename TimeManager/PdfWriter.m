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

@interface PdfWriter()
//DataManager
@property DataManager *dataManager;
//Project
@property Project *project;
//Setting
@property Setting *setting;

//基準日
@property NSDate *baseDate;

//合計時間
@property NSInteger sumTime;

@end

@implementation PdfWriter

/**
 * text-align定数
 */
typedef enum textAlign : NSUInteger {
    kVerticalTop,
    kVerticalMiddle,
    kVerticalBottom,
    kAlignLeft,
    kAlignCenter,
    kAlignRight
} textAlign;


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
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *pdfPath = [path stringByAppendingPathComponent: fileName];
    
    //PDFContext
    UIGraphicsBeginPDFContextToFile(pdfPath, CGRectZero, nil);
    
    //ページ作成
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 612, 792), nil);
    
    //UserDefaults取得
    self.setting = [SettingController loadUserDefaults];
    //Project取得
    self.dataManager = [[DataManager alloc] init];
    
    NSMutableArray *pa = [self.dataManager getProjectById:1];
    if(pa != nil && pa.count > 0){
        self.project = (Project *)pa[0];
    }else{
        self.project = [self.dataManager createProject];
    }
    
    //基準日設定
    self.baseDate = date;
    self.sumTime = 0;
    
    //罫線
    [self drawTableBorder];
    //ヘッダー
    [self drawTableHeader];
    
    //月末
    NSInteger lastDay = [MyUtil getLastDay:date];
    for(NSInteger day=1; day <= lastDay; day++){
        //各行描画
        [self drawTableBodyAtRowIndex:day];
    }
    
    //フッター
    [self drawTableFooter];
    
    //PDFコンテキストを閉じる
    UIGraphicsEndPDFContext();
    
    return pdfPath;
}


/**
 * 表罫線を描画する
 */
- (void) drawTableBorder
{
    UIColor *c = [UIColor blackColor];
    
    //横軸
    [self drawLine:c startX:72 startY:108 endX:540 endY:108 width:2];
    [self drawLine:c startX:72 startY:125 endX:384 endY:125 width:1];
    [self drawLine:c startX:72 startY:142 endX:540 endY:142 width:2];
    [self drawLine:c startX:124 startY:159 endX:306 endY:159 width:1];
    [self drawLine:c startX:72 startY:176 endX:540 endY:176 width:1];
    [self drawLine:c startX:72 startY:193 endX:540 endY:193 width:1];
    [self drawLine:c startX:72 startY:210 endX:540 endY:210 width:1];
    [self drawLine:c startX:72 startY:227 endX:540 endY:227 width:1];
    [self drawLine:c startX:72 startY:244 endX:540 endY:244 width:1];
    [self drawLine:c startX:72 startY:261 endX:540 endY:261 width:1];
    [self drawLine:c startX:72 startY:278 endX:540 endY:278 width:1];
    [self drawLine:c startX:72 startY:295 endX:540 endY:295 width:1];
    [self drawLine:c startX:72 startY:312 endX:540 endY:312 width:1];
    [self drawLine:c startX:72 startY:329 endX:540 endY:329 width:1];
    [self drawLine:c startX:72 startY:346 endX:540 endY:346 width:1];
    [self drawLine:c startX:72 startY:363 endX:540 endY:363 width:1];
    [self drawLine:c startX:72 startY:380 endX:540 endY:380 width:1];
    [self drawLine:c startX:72 startY:397 endX:540 endY:397 width:1];
    [self drawLine:c startX:72 startY:414 endX:540 endY:414 width:1];
    [self drawLine:c startX:72 startY:431 endX:540 endY:431 width:1];
    [self drawLine:c startX:72 startY:448 endX:540 endY:448 width:1];
    [self drawLine:c startX:72 startY:465 endX:540 endY:465 width:1];
    [self drawLine:c startX:72 startY:482 endX:540 endY:482 width:1];
    [self drawLine:c startX:72 startY:499 endX:540 endY:499 width:1];
    [self drawLine:c startX:72 startY:516 endX:540 endY:516 width:1];
    [self drawLine:c startX:72 startY:533 endX:540 endY:533 width:1];
    [self drawLine:c startX:72 startY:550 endX:540 endY:550 width:1];
    [self drawLine:c startX:72 startY:567 endX:540 endY:567 width:1];
    [self drawLine:c startX:72 startY:584 endX:540 endY:584 width:1];
    [self drawLine:c startX:72 startY:601 endX:540 endY:601 width:1];
    [self drawLine:c startX:72 startY:618 endX:540 endY:618 width:1];
    [self drawLine:c startX:72 startY:635 endX:540 endY:635 width:1];
    [self drawLine:c startX:72 startY:652 endX:540 endY:652 width:1];
    [self drawLine:c startX:72 startY:669 endX:540 endY:669 width:1];
    [self drawLine:c startX:72 startY:686 endX:540 endY:686 width:1];
    [self drawLine:c startX:72 startY:703 endX:540 endY:703 width:2];
    [self drawLine:c startX:72 startY:720 endX:540 endY:720 width:2];
    
    //縦軸
    [self drawLine:c startX:72 startY:108 endX:72 endY:720 width:2];
    [self drawLine:c startX:108 startY:142 endX:108 endY:703 width:1];
    [self drawLine:c startX:124 startY:142 endX:124 endY:703 width:1];
    [self drawLine:c startX:176 startY:159 endX:176 endY:703 width:1];
    [self drawLine:c startX:228 startY:108 endX:228 endY:703 width:1];
    [self drawLine:c startX:267 startY:159 endX:267 endY:703 width:1];
    [self drawLine:c startX:306 startY:142 endX:306 endY:720 width:1];
    [self drawLine:c startX:384 startY:108 endX:384 endY:720 width:1];
    [self drawLine:c startX:540 startY:108 endX:540 endY:720 width:2];
}


/**
 * 表ヘッダー文字列描画
 */
- (void) drawTableHeader
{
    NSDateComponents *comp = [MyUtil dateComponentFromDate:self.baseDate];
    NSInteger y = comp.year;
    NSInteger m = comp.month;
    NSLog(@"%d/%d", y, m);
    //年月取得
    [self drawText:[NSString stringWithFormat:@"%04d年 月間報告書 (%d月度)", y, m]
        fontOfSize:16 startX:72 startY:72 endX:540 endY:108
     verticalAlign:kVerticalMiddle textAlign:kAlignCenter];
    
    if(![self.setting.partnerId isEqualToString:@""]){
    
        //partnerId
        [self drawText:@"ﾊﾟｰﾄﾅｰNo:"
            fontOfSize:8
                startX:72 startY:108 endX:124 endY:125
         verticalAlign:kVerticalMiddle textAlign:kAlignCenter];
        
        [self drawText:self.setting.partnerId
            fontOfSize:8
                startX:124 startY:108 endX:228 endY:125
         verticalAlign:kVerticalMiddle textAlign:kAlignLeft];
    }
    
    [self drawText:@"契約先会社名:"
        fontOfSize:8
            startX:228 startY:108 endX:290 endY:125
     verticalAlign:kVerticalMiddle textAlign:kAlignCenter];
    
    //Project情報取得
    [self drawText:self.project.company_name
        fontOfSize:8
            startX:294 startY:108 endX:384 endY:125
     verticalAlign:kVerticalMiddle textAlign:kAlignLeft];
    
    [self drawText:@"氏名:"
        fontOfSize:8
            startX:72 startY:125 endX:124 endY:142
     verticalAlign:kVerticalMiddle textAlign:kAlignCenter];
    
    //氏名取得
    [self drawText:self.setting.partnerName
        fontOfSize:8
            startX:124 startY:125 endX:200 endY:142
     verticalAlign:kVerticalMiddle textAlign:kAlignLeft];
    
    [self drawText:@"印"
        fontOfSize:8
            startX:200 startY:125 endX:228 endY:142
     verticalAlign:kVerticalMiddle textAlign:kAlignCenter];
    
    [self drawText:@"作業場所名称:"
        fontOfSize:8
            startX:228 startY:125 endX:290 endY:142
     verticalAlign:kVerticalMiddle textAlign:kAlignCenter];
    
    //作業場所
    [self drawText:self.project.workspace
        fontOfSize:8
            startX:294 startY:125 endX:384 endY:142
     verticalAlign:kVerticalMiddle textAlign:kAlignLeft];
    
    [self drawText:@"連絡方法" fontOfSize:8
            startX:384 startY:108 endX:540 endY:119
     verticalAlign:kVerticalMiddle textAlign:kAlignLeft];
    
    //連絡先取得
    [self drawText:self.setting.tel
        fontOfSize:9
            startX:384 startY:119 endX:540 endY:131
     verticalAlign:kVerticalMiddle textAlign:kAlignLeft];
    
    NSString *tel2 = @"";
    NSString *tel3 = @"";
    if(self.setting.naisen != nil && self.setting.naisen.length > 0){
        tel2 = [NSString stringWithFormat:@"(内) %@", self.setting.naisen];
    }
    if(self.setting.yobidasi != nil && self.setting.yobidasi.length > 0){
        tel3 = [NSString stringWithFormat:@"呼出方 %@", self.setting.yobidasi];
    }
    
    [self drawText:[NSString stringWithFormat:@"%@ %@", tel2, tel3]
        fontOfSize:8
            startX:384 startY:131 endX:540 endY:142
     verticalAlign:kVerticalMiddle textAlign:kAlignLeft];
    
    //以降、固定値
    
    [self drawText:@"月/日" fontOfSize:9
            startX:72 startY:142 endX:108 endY:176
     verticalAlign:kVerticalMiddle textAlign:kAlignCenter];
    
    [self drawText:@"曜\n日" fontOfSize:9
            startX:108 startY:142 endX:124 endY:176
     verticalAlign:kVerticalMiddle textAlign:kAlignCenter];
    
    [self drawText:@"作業時間" fontOfSize:9
            startX:124 startY:142 endX:228 endY:159
     verticalAlign:kVerticalMiddle textAlign:kAlignCenter];
    
    [self drawText:@"自" fontOfSize:9
            startX:124 startY:159 endX:176 endY:176
     verticalAlign:kVerticalMiddle textAlign:kAlignCenter];
    
    [self drawText:@"至" fontOfSize:9
            startX:176 startY:159 endX:228 endY:176
     verticalAlign:kVerticalMiddle textAlign:kAlignCenter];
    
    [self drawText:@"休憩" fontOfSize:9
            startX:228 startY:142 endX:306 endY:159
     verticalAlign:kVerticalMiddle textAlign:kAlignCenter];
    
    [self drawText:@"昼休憩" fontOfSize:8
            startX:228 startY:159 endX:267 endY:176
     verticalAlign:kVerticalMiddle textAlign:kAlignCenter];
    
    [self drawText:@"昼以外の休憩" fontOfSize:6
            startX:267 startY:159 endX:306 endY:176
     verticalAlign:kVerticalMiddle textAlign:kAlignCenter];
    
    [self drawText:@"実作業時間" fontOfSize:9
            startX:306 startY:142 endX:384 endY:176
     verticalAlign:kVerticalMiddle textAlign:kAlignCenter];
    
    [self drawText:@"作業内容" fontOfSize:9
            startX:384 startY:142 endX:540 endY:176
     verticalAlign:kVerticalMiddle textAlign:kAlignCenter];
}


/**
 * 行情報を描画する
 * @param rowInde 行番号 = 日
 */
- (void) drawTableBodyAtRowIndex:(NSInteger)rowIndex
{
    //rowIndexを元にCoreDataからDailyReportを取得
    NSDate *targetDate = [MyUtil initWithDayInterval:rowIndex-1 fromDate:self.baseDate];
    NSInteger reportDate = [MyUtil numberFromDate:targetDate];
    NSMutableArray *arrDaily = [self.dataManager getDailyReportByReportDate:reportDate];
    DailyReport *dr = nil;
    if(arrDaily != nil && arrDaily.count > 0){
        dr = (DailyReport *)arrDaily[0];
    }
    
    //縦位置
    NSInteger positionTop = 17 * (rowIndex - 1);
    
    //月/日
    [self drawText:[MyUtil stringMonthDayFromDate:targetDate]
        fontOfSize:8
            startX:72
            startY:176 + positionTop
              endX:108
              endY:193 + positionTop
     verticalAlign:kVerticalMiddle textAlign:kAlignCenter];
    //曜日
    [self drawText:[MyUtil stringWeekday:targetDate]
        fontOfSize:8
            startX:108
            startY:176 + positionTop
              endX:124
              endY:193 + positionTop
     verticalAlign:kVerticalMiddle textAlign:kAlignCenter];
    
    if(dr != nil){
        //出勤
        [self drawText:[MyUtil stringHourMinute:dr.start_time]
            fontOfSize:8
                startX:124
                startY:176 + positionTop
                  endX:176
                  endY:193 + positionTop
         verticalAlign:kVerticalMiddle textAlign:kAlignCenter];
        
        //退勤
        [self drawText:[MyUtil stringHourMinute:dr.end_time]
            fontOfSize:8
                startX:176
                startY:176 + positionTop
                  endX:228
                  endY:193 + positionTop
         verticalAlign:kVerticalMiddle textAlign:kAlignCenter];
        
        //昼休憩
        [self drawText:[NSString stringWithFormat:@"%3d 分",dr.lunch_time.integerValue]
            fontOfSize:8
                startX:228
                startY:176 + positionTop
                  endX:267
                  endY:193 + positionTop
         verticalAlign:kVerticalMiddle textAlign:kAlignRight];
        
        //休憩時間
        [self drawText:[NSString stringWithFormat:@"%3d 分", dr.rest_time.integerValue]
            fontOfSize:8
                startX:267
                startY:176 + positionTop
                  endX:306
                  endY:193 + positionTop
         verticalAlign:kVerticalMiddle textAlign:kAlignRight];
        
        //作業時間
        NSInteger workTime = [MyUtil diffTime:dr.start_time
                                      endTime:dr.end_time
                                    lunchTime:dr.lunch_time
                                     restTime:dr.rest_time];
        //作業時間合計
        self.sumTime += workTime;
        
        [self drawText:[MyUtil formatMinute:workTime]
            fontOfSize:8
                startX:306
                startY:176 + positionTop
                  endX:384
                  endY:193 + positionTop
         verticalAlign:kVerticalMiddle textAlign:kAlignRight];
        
        //作業内容
        [self drawText:dr.detail
            fontOfSize:8
                startX:384
                startY:176 + positionTop
                  endX:540
                  endY:193 + positionTop
         verticalAlign:kVerticalMiddle textAlign:kAlignLeft];
    }
}


/**
 * 表フッター描画
 */
- (void) drawTableFooter
{
    [self drawText:@"合計"
        fontOfSize:9 startX:72 startY:703 endX:306 endY:720
     verticalAlign:kVerticalMiddle textAlign:kAlignCenter];
    
    //合計時間を 時 分 に分割
    [self drawText:[MyUtil formatMinute:self.sumTime]
        fontOfSize:9 startX:306 startY:703 endX:384 endY:720
     verticalAlign:kVerticalMiddle textAlign:kAlignRight];
    
    //Project情報
    [self drawText:@"責任者氏名:"
        fontOfSize:8 startX:384 startY:703 endX:436 endY:720
     verticalAlign:kVerticalMiddle textAlign:kAlignCenter];
    
    [self drawText:self.project.manager
        fontOfSize:9 startX:436 startY:703 endX:512 endY:720
     verticalAlign:kVerticalMiddle textAlign:kAlignLeft];
    
    [self drawText:@"印"
        fontOfSize:9 startX:512 startY:703 endX:540 endY:720
     verticalAlign:kVerticalMiddle textAlign:kAlignCenter];
}


/**
 * 指定された矩形の範囲内にテキストを描画します。
 * @param text 描画文字列
 * @param fontOfSize 文字サイズ
 * @param startX 開始位置 (X)
 * @param startY 開始位置 (Y)
 * @param endX 終了位置 (X)
 * @param endY 終了位置 (Y)
 * @param verticalAlign kVerticalTop|kVerticalMiddle|kVerticalBottom
 * @param align kAlignLeft|kAlignCenter|kAlignRight
 */
- (void) drawText:(NSString *)text fontOfSize:(NSInteger)fontSize
           startX:(NSInteger)sx startY:(NSInteger)sy
             endX:(NSInteger)ex endY:(NSInteger)ey
    verticalAlign:(NSInteger)va textAlign:(NSInteger)ta
{
    //font
    UIFont *f = [UIFont systemFontOfSize: fontSize];
    //描画エリアを指定
    CGRect drawArea = CGRectMake(sx, sy, ex-sx, ey-sy);
    //描画文字列のサイズを取得
    //UILineBreakModeMiddleTruncation:文末を省略する
    //UILineBreakModeClip:はみ出した部分を切り捨てる
    CGSize textSize = [text sizeWithFont:f
                       constrainedToSize:CGSizeMake(drawArea.size.width,
                                                    drawArea.size.height)
                           lineBreakMode:NSLineBreakByTruncatingMiddle];
    //縦位置
    NSInteger py = 0;
    if(va == kVerticalTop){
        //上詰め
        py = sy;
    }else if(va == kVerticalMiddle){
        //中央揃え
        py = sy + (drawArea.size.height - textSize.height) / 2;
    }else{
        //下詰め
        py = sy + (drawArea.size.height - textSize.height);
    }
    
    //横位置
    NSInteger px = 0;
    if(ta == kAlignLeft){
        //左詰め
        px = sx;
    }else if(ta == kAlignCenter){
        //中央揃え
        px = sx + (drawArea.size.width - textSize.width) / 2;
    }else{
        //右詰め
        px = sx + (drawArea.size.width - textSize.width);
    }
    
    //文字描画位置の決定
    CGRect tr = CGRectMake(px, py, textSize.width, textSize.height);
    //描画
    [text drawInRect: tr withFont:f];
}


/**
 * 線を描画する
 * @param UIColor
 * @param startX 開始位置 (X)
 * @param startY 開始位置 (Y)
 * @param endX 終了位置 (X)
 * @param endY 終了位置 (Y)
 * @param width 太さ
 */
- (void) drawLine:(UIColor *)color startX:(NSInteger)sx startY:(NSInteger)sy
             endX:(NSInteger)ex endY:(NSInteger)ey width:(NSInteger)width
{
    //CG Context
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    //set Width
    CGContextSetLineWidth(currentContext, width);
    //set Color
    CGContextSetStrokeColorWithColor(currentContext, color.CGColor);
    //draw Path
    CGContextBeginPath(currentContext);
    CGContextMoveToPoint(currentContext, sx, sy);
    CGContextAddLineToPoint(currentContext, ex, ey);
    CGContextClosePath(currentContext);
    CGContextDrawPath(currentContext, kCGPathFillStroke);
}


@end
