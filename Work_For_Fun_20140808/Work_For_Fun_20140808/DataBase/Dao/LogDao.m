//
//  LogDao.m
//  Work_For_Fun_20140808
//
//  Created by Snail on 7/9/14.
//  Copyright (c) 2014 Snail. All rights reserved.
//

#import "LogDao.h"
#import "LogBean.h"

static NSString *const TableName = @"log";

@implementation LogDao

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[LogDao alloc] init];
    });
    return sharedInstance;
}

- (NSString *)tableName
{
    return TableName;
}

- (id)mappingRs2Bean:(FMResultSet *)rs
{
    LogBean *bean = [LogBean new];
    bean.beanId = [rs intForColumn:kBeanId];
    bean.chapterId = [rs intForColumn:kLogChapterId];
    bean.record = [rs stringForColumn:kLogRecord];
    bean.date = [rs stringForColumn:kLogDate];
    return bean;
}

- (LogBean *)selectLogToday
{
    NSString *whereSql = [NSString stringWithFormat:@"%@ = %@", kLogDate, [self formatedDateString:[NSDate date]]];
    NSString *orderSql = [NSString stringWithFormat:@"%@ DESC", kLogDate];
    NSArray *beanArray = [self selectWithWhere:whereSql order:orderSql];
    if (beanArray.count > 0) {
        return beanArray[0];
    }
    return nil;
}

- (NSArray *)selectLogBeforeTodayOrderByDateDesc
{
    NSString *whereSql = [NSString stringWithFormat:@"%@ < %@", kLogDate, [self formatedDateString:[NSDate date]]];
#warning TEST
//    whereSql = nil;
    NSString *orderSql = [NSString stringWithFormat:@"%@ DESC", kLogDate];
    return [self selectWithWhere:whereSql order:orderSql];
}

- (void)insertLog:(LogBean *)bean
{
    [self insertBean:bean];
}

- (void)deleteLogByBeans:(NSArray *)logBeanArray
{
    NSMutableString *idsString = [NSMutableString string];
    [logBeanArray enumerateObjectsUsingBlock:^(LogBean *obj, NSUInteger idx, BOOL *stop) {
        [idsString appendFormat:@"%d, ", obj.beanId];
    }];
    if (idsString.length > 2) {
        [idsString deleteCharactersInRange:NSMakeRange(idsString.length - 2, 2)];
    }
    NSString *whereSql = [NSString stringWithFormat:@"%@ in (%@)", kBeanId, idsString];
    [self deleteWithWhere:whereSql];
}

- (void)updateLog:(LogBean *)bean
{
    [self updateBean:bean];
}

- (NSString *)formatedDateString:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    return [dateFormatter stringFromDate:date];
}

@end
