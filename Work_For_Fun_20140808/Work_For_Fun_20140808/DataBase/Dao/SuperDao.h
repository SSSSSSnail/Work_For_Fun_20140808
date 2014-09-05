//
//  SuperDao.h
//  Work_For_Fun_20140808
//
//  Created by Snail on 2/9/14.
//  Copyright (c) 2014 Snail. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SuperBean.h"

@interface SuperDao : NSObject

@property (copy, nonatomic, readonly) NSString *tableName;

- (int)selectCount;

- (NSArray *)selectAll;
- (NSArray *)selectWithWhere:(NSString *)whereSql;
- (NSArray *)selectWithOrder:(NSString *)orderSql;
- (NSArray *)selectWithWhere:(NSString *)whereSql order:(NSString *)orderSql;

- (void)insertBean:(SuperBean *)bean;

- (void)deleteAll;
- (void)deleteWithWhere:(NSString *)whereSql;

- (void)updateBean:(SuperBean *)bean;

@end