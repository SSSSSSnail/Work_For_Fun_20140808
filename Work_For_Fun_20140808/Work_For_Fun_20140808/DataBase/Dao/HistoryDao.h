//
//  HistoryDao.h
//  Work_For_Fun_20140808
//
//  Created by Snail on 4/9/14.
//  Copyright (c) 2014 Snail. All rights reserved.
//

#import "SuperDao.h"

@class HistoryBean;
@interface HistoryDao : SuperDao

+ (instancetype)sharedInstance;

- (NSArray *)selectHistoryOrderByDateDesc;
- (void)insertHistory:(HistoryBean *)bean;

- (HistoryBean *)selectLastHistory;

@end