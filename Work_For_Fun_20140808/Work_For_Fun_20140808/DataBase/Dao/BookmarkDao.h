//
//  BookmarkDao.h
//  Work_For_Fun_20140808
//
//  Created by Snail on 3/9/14.
//  Copyright (c) 2014 Snail. All rights reserved.
//

#import "SuperDao.h"

@class BookmarkBean;
@interface BookmarkDao : SuperDao

+ (instancetype)sharedInstance;

- (NSArray *)selectBookmarkOrderByDateDesc;
- (BOOL)isPageAdded2Bookmark:(int)page;
- (void)deleteBookmarkByPage:(int)page;
- (void)insertBookmark:(BookmarkBean *)bean;

@end
