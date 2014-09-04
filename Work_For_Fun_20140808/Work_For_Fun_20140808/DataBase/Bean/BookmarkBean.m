//
//  BookmarkBean.m
//  Work_For_Fun_20140808
//
//  Created by Snail on 3/9/14.
//  Copyright (c) 2014 Snail. All rights reserved.
//

#import "BookmarkBean.h"

NSString *const kBookmarkTitle= @"title";
NSString *const kBookmarkPage = @"page";
NSString *const kBookmarkDate = @"date";

@implementation BookmarkBean

- (NSString *)columnString
{
    NSString *columnString = [NSString stringWithFormat:@"%@, %@, %@", kBookmarkTitle, kBookmarkPage, kBookmarkDate];
    return columnString;
}

- (NSArray *)valueArray
{
    NSArray *valueArray = @[_title, @(_page), _date];
    return valueArray;
}

@end
