//
//  SuperDao.m
//  Work_For_Fun_20140808
//
//  Created by Snail on 2/9/14.
//  Copyright (c) 2014 Snail. All rights reserved.
//

#import "SuperDao.h"
@interface SuperDao()

@property (strong, nonatomic) FMDatabase *db;

@end

@implementation SuperDao

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.db = GInstance().db;
    }
    return self;
}

- (NSString *)tableName
{
    NSAssert(NO, @"SubClass: tableName");
    return nil;
}

- (id)mappingRs2Bean:(FMResultSet *)rs
{
     NSAssert(NO, @"Subclass: mappingRs2Bean");
    return nil;
}

- (FMResultSet *)mappingBean2Rs:(id)bean
{
    NSAssert(NO, @"Subclass: mappingBean2Rs");
    return nil;
}

- (int)selectCount
{
    NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@", self.tableName];
    FMResultSet *rs = [_db executeQuery:sql];
    int totalCount = 0;
    while ([rs next]) {
        totalCount = [rs intForColumnIndex:0];
    }
    [rs close];
    return totalCount;
}

- (NSArray *)selectAll
{
    return [self selectWithWhere:nil order:nil];
}

- (NSArray *)selectWithWhere:(NSString *)whereSql
{
    return [self selectWithWhere:whereSql order:nil];
}

- (NSArray *)selectWithOrder:(NSString *)orderSql
{
    return [self selectWithWhere:nil order:orderSql];
}

- (NSArray *)selectWithWhere:(NSString *)whereSql order:(NSString *)orderSql
{
    NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT * FROM %@", self.tableName];
    if (whereSql) {
        [sql appendFormat:@" WHERE %@", whereSql];
    }
    if (orderSql) {
        [sql appendFormat:@" ORDER BY %@", orderSql];
    }

    FMResultSet *rs = [_db executeQuery:sql];
    NSMutableArray *beanArray = [NSMutableArray array];
    while ([rs next]) {
        [beanArray addObject:[self mappingRs2Bean:rs]];
    }
    [rs close];
    if (beanArray.count > 0) {
        return beanArray;
    } else {
        return nil;
    }
}

- (void)insertBean:(SuperBean *)bean
{
    NSMutableString *qmarkString = [NSMutableString string];
    [bean.valueArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [qmarkString appendString:@"?, "];
    }];
    if (qmarkString.length > 2) {
        [qmarkString deleteCharactersInRange:NSMakeRange(qmarkString.length - 2, 2)];
    }
    NSMutableString *sql = [NSMutableString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@)", self.tableName, bean.columnString, qmarkString];
    BOOL insertSuccess = [_db executeUpdate:sql withArgumentsInArray:bean.valueArray];
    if (!insertSuccess) {
        NSLog(@"ERROR: Insert data failed!");
    }
}

- (void)deleteAll
{
    [self deleteWithWhere:nil];
}

- (void)deleteWithWhere:(NSString *)whereSql
{
    NSMutableString *deleteString = [NSMutableString stringWithFormat:@"DELETE FROM %@", self.tableName];
    if (whereSql) {
        [deleteString appendFormat:@" WHERE %@", whereSql];
    }
    [_db executeUpdate:deleteString];
}

@end