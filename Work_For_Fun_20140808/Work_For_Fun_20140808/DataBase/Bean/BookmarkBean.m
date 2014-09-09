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

- (NSArray *)columnArray
{
    return @[kBookmarkTitle, kBookmarkPage, kBookmarkDate];
}

- (NSArray *)valueArray
{
    return @[_title, @(_page), _date];
}

@end
