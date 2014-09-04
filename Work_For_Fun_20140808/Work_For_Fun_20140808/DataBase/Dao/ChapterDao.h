//
//  ChapterDao.h
//  Work_For_Fun_20140808
//
//  Created by Snail on 3/9/14.
//  Copyright (c) 2014 Snail. All rights reserved.
//

#import "SuperDao.h"

@interface ChapterDao : SuperDao

+ (instancetype)sharedInstance;

- (NSArray *)selectAllChapterOrderById;
- (NSArray *)selectAllChapterOrderByLetter;

@end