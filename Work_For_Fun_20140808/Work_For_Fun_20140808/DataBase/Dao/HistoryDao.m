//
//  HistoryDao.m
//  Work_For_Fun_20140808
//
//  Created by Snail on 4/9/14.
//  Copyright (c) 2014 Snail. All rights reserved.
//

#import "HistoryDao.h"
#import "HistoryBean.h"

static NSString *const TableName = @"history";

@implementation HistoryDao

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[HistoryDao alloc] init];
    });
    return sharedInstance;
}

- (NSString *)tableName
{
    return TableName;
}

- (id)mappingRs2Bean:(FMResultSet *)rs
{
    HistoryBean *bean = [HistoryBean new];
    bean.beanId = [rs intForColumn:kBeanId];
    bean.title = [rs stringForColumn:kHistoryTitle];
    bean.page = [rs intForColumn:kHistoryPage];
    bean.date = [rs dateForColumn:kHistoryDate];
    return bean;
}

- (NSArray *)selectHistoryOrderByDateDesc
{
    NSString *orderSql = [NSString stringWithFormat:@"%@ DESC", kHistoryDate];
    return [self selectWithOrder:orderSql];
}

- (void)insertHistory:(HistoryBean *)bean
{
    [self insertBean:bean];

    //Delete Records
    int maxHistoryId = [self selectMaxValue:kBeanId];
    NSString *whereSql = [NSString stringWithFormat:@"%@ < %d", kBeanId, maxHistoryId - MaxHistoryCount];
    [self deleteWithWhere:whereSql];
}

- (HistoryBean *)selectLastHistory
{
    NSString *orderSql = [NSString stringWithFormat:@"%@ DESC LIMIT 1", kHistoryDate];
    return [self selectWithOrder:orderSql][0];
}

@end
