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

- (NSArray *)columnArray
{
    return @[kHistoryTitle, kHistoryPage, kHistoryDate];
}

- (NSArray *)valueArray
{
    return @[_title, @(_page), _date];
}

@end
