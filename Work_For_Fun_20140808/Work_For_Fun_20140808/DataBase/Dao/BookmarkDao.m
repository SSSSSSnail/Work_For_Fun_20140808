//
//  BookmarkDao.m
//  Work_For_Fun_20140808
//
//  Created by Snail on 3/9/14.
//  Copyright (c) 2014 Snail. All rights reserved.
//

#import "BookmarkDao.h"
#import "BookmarkBean.h"

static NSString *const TableName = @"bookmark";

@implementation BookmarkDao

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[BookmarkDao alloc] init];
    });
    return sharedInstance;
}

- (NSString *)tableName
{
    return TableName;
}

- (id)mappingRs2Bean:(FMResultSet *)rs
{
    BookmarkBean *bean = [BookmarkBean new];
    bean.beanId = [rs intForColumn:kBeanId];
    bean.title = [rs stringForColumn:kBookmarkTitle];
    bean.page = [rs intForColumn:kBookmarkPage];
    bean.date = [rs dateForColumn:kBookmarkDate];
    return bean;
}

- (NSArray *)selectBookmarkOrderByDateDesc
{
    NSString *orderSql = [NSString stringWithFormat:@"%@ DESC", kBookmarkDate];
    return [self selectWithOrder:orderSql];
}

- (BOOL)isPageAdded2Bookmark:(int)page
{
    NSString *whereSql = [NSString stringWithFormat:@"%@ = %d", kBookmarkPage, page];
    NSArray *bookmarkArray = [self selectWithWhere:whereSql];
    if (bookmarkArray.count > 0) {
        return YES;
    } else {
        return NO;
    }
}

- (void)deleteBookmarkByPage:(int)page
{
    NSString *whereSql = [NSString stringWithFormat:@"%@ = %d", kBookmarkPage, page];
    [self deleteWithWhere:whereSql];
}

- (void)insertBookmark:(BookmarkBean *)bean
{
    [self insertBean:bean];
    //TODO: if count > 10
}

@end
