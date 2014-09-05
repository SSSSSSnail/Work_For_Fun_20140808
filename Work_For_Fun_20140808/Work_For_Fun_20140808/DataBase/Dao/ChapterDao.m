//
//  ChapterDao.m
//  Work_For_Fun_20140808
//
//  Created by Snail on 3/9/14.
//  Copyright (c) 2014 Snail. All rights reserved.
//

#import "ChapterDao.h"
#import "ChapterBean.h"

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
    bean.beanId = [rs intForColumn:kBeanId];
    bean.chapterId = [rs intForColumn:kChapterId];
    bean.title = [rs stringForColumn:kChapterTitle];
    bean.letter = [rs stringForColumn:kChapterLetter];
    bean.pageFrom = [rs intForColumn:kChapterPageFrom];
    bean.pageTo = [rs intForColumn:kChapterPageTo];
    bean.document = [rs stringForColumn:kChapterDocument];
    return bean;
}

- (NSArray *)selectAllChapterOrderById
{
    NSString *orderByString = [NSString stringWithFormat:@"%@ ASC", kChapterId];
    return [self selectWithOrder:orderByString];
}

- (NSArray *)selectAllChapterOrderByLetter
{
    NSString *orderByString = [NSString stringWithFormat:@"%@, %@ ASC", kChapterLetter, kChapterId];
    return [self selectWithOrder:orderByString];
}

@end