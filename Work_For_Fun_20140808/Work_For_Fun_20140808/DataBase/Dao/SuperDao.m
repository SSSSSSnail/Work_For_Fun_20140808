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
    NSAssert(NO, @"Return in subclass");
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
    while ([rs next]) {
        int totalCount = [rs intForColumnIndex:0];
        return totalCount;
    }
    return 0;
}

- (NSArray *)selectAll
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@", self.tableName];
    FMResultSet *rs = [_db executeQuery:sql];
    NSMutableArray *beanArray = [NSMutableArray array];
    while ([rs next]) {
        [beanArray addObject:[self mappingRs2Bean:rs]];
    }
    return beanArray;
}

- (NSArray *)selectByWhere:(NSString *)whereSql;
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@", self.tableName, whereSql];
    FMResultSet *rs = [_db executeQuery:sql];
    NSMutableArray *beanArray = [NSMutableArray array];
    while ([rs next]) {
        [beanArray addObject:[self mappingRs2Bean:rs]];
    }
    return beanArray;
}

- (void)deleteAll
{

}

@end