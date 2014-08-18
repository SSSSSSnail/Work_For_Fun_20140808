//
//  PDFSearcher.h
//  Work_For_Fun_20140808
//
//  Created by Snail on 11/8/14.
//  Copyright (c) 2014 Snail. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDFSearcher : NSObject

@property (nonatomic, strong) NSMutableString *currentData;

-(id)init;
-(BOOL)page:(CGPDFPageRef)inPage containsString:(NSString *)inSearchString;

@end
