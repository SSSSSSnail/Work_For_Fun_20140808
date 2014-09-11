//
//  NoteDao.m
//  Work_For_Fun_20140808
//
//  Created by Snail on 5/9/14.
//  Copyright (c) 2014 Snail. All rights reserved.
//

#import "NoteDao.h"
#import "NoteBean.h"

static NSString *const TableName = @"note";

@implementation NoteDao

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[NoteDao alloc] init];
    });
    return sharedInstance;
}

- (NSString *)tableName
{
    return TableName;
}

- (id)mappingRs2Bean:(FMResultSet *)rs
{
    NoteBean *bean = [NoteBean new];
    bean.beanId = [rs intForColumn:kBeanId];
    bean.chapterId = [rs intForColumn:kNoteChapterId];
    bean.content = [rs stringForColumn:kNoteContent];
    bean.date = [rs dateForColumn:kNoteDate];
    return bean;
}

- (NSArray *)selectNoteOrderByDateDesc:(int)chapterId
{
    NSString *whereSql = [NSString stringWithFormat:@"%@ = %d", kNoteChapterId, chapterId];
    NSString *orderSql = [NSString stringWithFormat:@"%@ DESC", kNoteDate];
    return [self selectWithWhere:whereSql order:orderSql];
}

- (void)insertNote:(NoteBean *)bean
{
    [self insertBean:bean];
}

- (void)deleteNoteById:(int)noteId
{
    NSString *whereSql = [NSString stringWithFormat:@"%@ = %d", kBeanId, noteId];
    [self deleteWithWhere:whereSql];
}

- (void)updateNote:(NoteBean *)bean;
{
    [self updateBean:bean];
}

@end