//
//  ChapterBean.m
//  Work_For_Fun_20140808
//
//  Created by Snail on 3/9/14.
//  Copyright (c) 2014 Snail. All rights reserved.
//

#import "ChapterBean.h"

NSString *const kChapterId = @"chapterId";
NSString *const kChapterTitle= @"title";
NSString *const kChapterLetter = @"letter";
NSString *const kChapterPageFrom = @"pageFrom";
NSString *const kChapterPageTo = @"pageTo";
NSString *const kChapterDocument = @"document";

@implementation ChapterBean

- (NSArray *)columnArray
{
    return @[kChapterId, kChapterTitle, kChapterLetter, kChapterPageFrom, kChapterPageTo, kChapterDocument];
}

- (NSArray *)valueArray
{
    return @[@(_chapterId), _title, _letter, @(_pageFrom), @(_pageTo), _document];
}

@end
