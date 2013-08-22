//
//  PdfWriter.m
//  TimeManager
//
//  Created by Kimura Kazunori on 2013/08/22.
//  Copyright (c) 2013年 Kimura Kazunori. All rights reserved.
//

#import "PdfWriter.h"
#import "MyUtil.h"

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
    
    //TODO: テキストを描画
    /* テキスト描画位置
     X      Y      項目名
     96     32    年
     430     32    月
     64     76    パートナーID (ラベル)
     110     76    パートナーID (値)
     300     76    会社名
     110     98    氏名
     300     98    作業場所
     420     86    連絡先
     426    100    内線番号
     506    100    呼出方
     324    730    合計
     458    730    責任者
     20    row_height
     62    156    月/日
     94    156    曜日
     112    156    開始時刻
     172    156    退社時刻
     230    156    昼休憩
     268    156    昼以外の休憩
     324    156    作業時間
     406    156    作業内容
     */
    
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
