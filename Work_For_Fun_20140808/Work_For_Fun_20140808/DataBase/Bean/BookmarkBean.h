//
//  BookmarkBean.h
//  Work_For_Fun_20140808
//
//  Created by Snail on 3/9/14.
//  Copyright (c) 2014 Snail. All rights reserved.
//

#import "SuperBean.h"

extern NSString *const kBookmarkTitle;
extern NSString *const kBookmarkPage;
extern NSString *const kBookmarkDate;

@interface BookmarkBean : SuperBean

@property (copy, nonatomic) NSString *title;
@property (assign, nonatomic) int page;
@property (strong, nonatomic) NSDate *date;

@end
