//
//  SuperDao.h
//  Work_For_Fun_20140808
//
//  Created by Snail on 2/9/14.
//  Copyright (c) 2014 Snail. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SuperDao : NSObject

@property (copy, nonatomic, readonly) NSString *tableName;

- (int)selectCount;

- (NSArray *)selectAll;
- (NSArray *)selectByWhere:(NSString *)whereSql;

- (void)deleteAll;

@end