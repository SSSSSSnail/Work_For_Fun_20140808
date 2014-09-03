//
//  ChapterDao.m
//  Work_For_Fun_20140808
//
//  Created by Snail on 3/9/14.
//  Copyright (c) 2014 Snail. All rights reserved.
//

#import "ChapterDao.h"

static NSString *const TableName = @"chapter";

@implementation ChapterDao

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ChapterDao alloc] init];
    });
    return sharedInstance;
}

- (NSString *)tableName
{
    return TableName;
}

- (id)mappingRs2Bean:(FMResultSet *)rs
{
    ChapterBean *bean = [ChapterBean new];
    bean.chapterId = [rs intForColumn:kChapterId];
    bean.title = [rs stringForColumn:kTitle];
    bean.letter = [rs stringForColumn:kLetter];
    bean.pageFrom = [rs intForColumn:kPageFrom];
    bean.pageTo = [rs intForColumn:kPageTo];
    return bean;
}

- (NSArray *)selectAllChapterOrderById
{
    NSString *orderByString = [NSString stringWithFormat:@"%@ ASC", kChapterId];
    return [self selectWithOrder:orderByString];
}

- (NSArray *)selectAllChapterOrderByLetter
{
    NSString *orderByString = [NSString stringWithFormat:@"%@, %@ ASC", kLetter, kChapterId];
    return [self selectWithOrder:orderByString];
}

- (ChapterBean *)selectChapterById:(NSString *)chapterId
{
    return nil;
}

@end