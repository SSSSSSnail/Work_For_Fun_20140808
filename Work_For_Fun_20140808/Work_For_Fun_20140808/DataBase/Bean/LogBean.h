//
//  LogBean.h
//  Work_For_Fun_20140808
//
//  Created by Snail on 7/9/14.
//  Copyright (c) 2014 Snail. All rights reserved.
//

#import "SuperBean.h"

extern NSString *const kLogChapterId;
extern NSString *const kLogRecord;
extern NSString *const kLogDate;

@interface LogBean : SuperBean

@property (assign, nonatomic) int chapterId;
@property (copy, nonatomic) NSString *record;
@property (copy, nonatomic) NSString *date;

@end
