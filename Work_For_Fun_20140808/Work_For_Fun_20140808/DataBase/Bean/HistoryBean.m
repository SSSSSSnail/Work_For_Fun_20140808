//
//  HistoryBean.m
//  Work_For_Fun_20140808
//
//  Created by Snail on 4/9/14.
//  Copyright (c) 2014 Snail. All rights reserved.
//

#import "HistoryBean.h"

NSString *const kHistoryTitle= @"title";
NSString *const kHistoryPage = @"page";
NSString *const kHistoryDate = @"date";

@implementation HistoryBean

- (NSString *)columnString
{
    NSString *columnString = [NSString stringWithFormat:@"%@, %@, %@", kHistoryTitle, kHistoryPage, kHistoryDate];
    return columnString;
}

- (NSArray *)valueArray
{
    NSArray *valueArray = @[_title, @(_page), _date];
    return valueArray;
}

@end
