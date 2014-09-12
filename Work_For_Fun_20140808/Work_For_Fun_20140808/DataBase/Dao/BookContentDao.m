//
//  BookContentDao.m
//  Work_For_Fun_20140808
//
//  Created by Snail on 12/9/14.
//  Copyright (c) 2014 Snail. All rights reserved.
//

#import "BookContentDao.h"
#import "BookContentBean.h"

static NSString *const TableName = @"pdf_content";

@implementation BookContentDao

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[BookContentDao alloc] init];
    });
    return sharedInstance;
}

- (NSString *)tableName
{
    return TableName;
}

- (id)mappingRs2Bean:(FMResultSet *)rs
{
    BookContentBean *bean = [BookContentBean new];
    bean.beanId = [rs intForColumn:kBeanId];
    bean.page = [rs intForColumn:kBookContentPage];
    bean.content = [rs stringForColumn:kBookContentContent];
    return bean;
}

- (NSArray *)selectBookContent:(NSString *)keyword fromPage:(int)fromPage toPage:(int)toPage
{
    NSString *whereSql = [NSString stringWithFormat:@"%@ LIKE '%%%@%%' AND %@ >= %d AND %@ <= %d", kBookContentContent, keyword, kBookContentPage, fromPage, kBookContentPage, toPage];
    NSString *orderSql = [NSString stringWithFormat:@"%@ ASC", kBeanId];
    return [self selectWithWhere:whereSql order:orderSql];
}

@end
