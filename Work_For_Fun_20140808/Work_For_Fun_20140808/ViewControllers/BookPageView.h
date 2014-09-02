//
//  BookPageView.h
//  Work_For_Fun_20140808
//
//  Created by Snail on 31/8/14.
//  Copyright (c) 2014 Snail. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Scanner.h"

@interface BookContentView : UIView

- (void)setPage:(CGPDFPageRef)page;

@property (nonatomic, strong) Scanner *scanner;
@property (nonatomic, copy) NSString *keyword;
@property (nonatomic, copy) NSArray *selections;

@end

@interface BookPageView : UIScrollView

- (void)setPage:(CGPDFPageRef)page;

@property (assign, nonatomic) int pageNumber;
@property (assign, nonatomic) int toPageNumber;
@property (nonatomic, copy) NSString *keyword;

@end
