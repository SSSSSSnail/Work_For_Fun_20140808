//
//  ChapterBean.h
//  Work_For_Fun_20140808
//
//  Created by Snail on 3/9/14.
//  Copyright (c) 2014 Snail. All rights reserved.
//

#import "SuperBean.h"

extern NSString *const kChapterId;
extern NSString *const kTitle;
extern NSString *const kLetter;
extern NSString *const kPageFrom;
extern NSString *const kPageTo;

@interface ChapterBean : SuperBean

@property (assign, nonatomic) int chapterId;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *letter;
@property (assign, nonatomic) int pageFrom;
@property (assign, nonatomic) int pageTo;

@end
