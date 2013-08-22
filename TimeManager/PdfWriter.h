//
//  PdfWriter.h
//  TimeManager
//
//  Created by Kimura Kazunori on 2013/08/22.
//  Copyright (c) 2013年 Kimura Kazunori. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PdfWriter : NSObject
- (NSString *) exportPdf:(NSDate *)date;
@end
