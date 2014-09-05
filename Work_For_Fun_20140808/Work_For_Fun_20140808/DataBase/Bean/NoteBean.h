//
//  NoteBean.h
//  Work_For_Fun_20140808
//
//  Created by Snail on 5/9/14.
//  Copyright (c) 2014 Snail. All rights reserved.
//

#import "SuperBean.h"

extern NSString *const kNoteChapterId;
extern NSString *const kNoteContent;
extern NSString *const kNoteDate;

@interface NoteBean : SuperBean

@property (assign, nonatomic) int chapterId;
@property (copy, nonatomic) NSString *content;
@property (strong, nonatomic) NSDate *date;

@end
