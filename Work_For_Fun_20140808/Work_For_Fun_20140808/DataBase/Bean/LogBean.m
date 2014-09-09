//
//  LogBean.m
//  Work_For_Fun_20140808
//
//  Created by Snail on 7/9/14.
//  Copyright (c) 2014 Snail. All rights reserved.
//

#import "LogBean.h"

NSString *const kLogChapterId = @"chapterId";
NSString *const kLogRecord = @"record";
NSString *const kLogDate = @"date";

@implementation LogBean

- (NSArray *)columnArray
{
    return @[kLogChapterId, kLogRecord, kLogDate];
}

- (NSArray *)valueArray
{
    return @[@(_chapterId), _record, _date];
}

@end
