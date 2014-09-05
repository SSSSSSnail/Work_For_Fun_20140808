//
//  NoteDao.h
//  Work_For_Fun_20140808
//
//  Created by Snail on 5/9/14.
//  Copyright (c) 2014 Snail. All rights reserved.
//

#import "SuperDao.h"

@class NoteBean;
@interface NoteDao : SuperDao

+ (instancetype)sharedInstance;

- (NSArray *)selectNoteOrderByDateDesc:(int)chapterId;
- (void)insertNote:(NoteBean *)bean;
- (void)deleteNoteById:(int)noteId;
- (void)updateNote:(NoteBean *)bean;

@end
