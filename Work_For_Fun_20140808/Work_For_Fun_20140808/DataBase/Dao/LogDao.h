//
//  LogDao.h
//  Work_For_Fun_20140808
//
//  Created by Snail on 7/9/14.
//  Copyright (c) 2014 Snail. All rights reserved.
//

#import "SuperDao.h"

@class LogBean;
@interface LogDao : SuperDao

+ (instancetype)sharedInstance;

- (LogBean *)selectLogToday;
- (NSArray *)selectLogBeforeTodayOrderByDateDesc;
- (void)insertLog:(LogBean *)bean;
- (void)deleteLogByBeans:(NSArray *)logBeanArray;
- (void)updateLog:(LogBean *)bean;

- (NSString *)formatedDateString:(NSDate *)date;

@end
