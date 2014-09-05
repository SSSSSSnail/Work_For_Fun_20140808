//
//  NoteBean.m
//  Work_For_Fun_20140808
//
//  Created by Snail on 5/9/14.
//  Copyright (c) 2014 Snail. All rights reserved.
//

NSString *const kNoteChapterId = @"chapterId";
NSString *const kNoteContent = @"content";
NSString *const kNoteDate = @"date";

#import "NoteBean.h"

@implementation NoteBean

- (NSString *)columnString
{
    NSString *columnString = [NSString stringWithFormat:@"%@, %@, %@", kNoteChapterId, kNoteContent, kNoteDate];
    return columnString;
}

- (NSArray *)valueArray
{
    NSArray *valueArray = @[@(_chapterId), _content, _date];
    return valueArray;
}

@end
