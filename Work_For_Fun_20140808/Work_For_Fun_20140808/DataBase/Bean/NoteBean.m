//
//  NoteBean.m
//  Work_For_Fun_20140808
//
//  Created by Snail on 5/9/14.
//  Copyright (c) 2014 Snail. All rights reserved.
//

#import "NoteBean.h"

NSString *const kNoteChapterId = @"chapterId";
NSString *const kNoteContent = @"content";
NSString *const kNoteDate = @"date";

@implementation NoteBean

- (NSArray *)columnArray
{
    return @[kNoteChapterId, kNoteContent, kNoteDate];
}

- (NSArray *)valueArray
{
    return @[@(_chapterId), _content, _date];
}

@end
