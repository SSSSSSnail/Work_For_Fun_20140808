//
//  ChapterBean.h
//  Work_For_Fun_20140808
//
//  Created by Snail on 3/9/14.
//  Copyright (c) 2014 Snail. All rights reserved.
//

#import "SuperBean.h"

extern NSString *const kChapterId;
extern NSString *const kChapterTitle;
extern NSString *const kChapterLetter;
extern NSString *const kChapterPageFrom;
extern NSString *const kChapterPageTo;
extern NSString *const kChapterDocument;

@interface ChapterBean : SuperBean

@property (assign, nonatomic) int chapterId;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *letter;
@property (assign, nonatomic) int pageFrom;
@property (assign, nonatomic) int pageTo;
@property (copy, nonatomic) NSString *document;

@end
