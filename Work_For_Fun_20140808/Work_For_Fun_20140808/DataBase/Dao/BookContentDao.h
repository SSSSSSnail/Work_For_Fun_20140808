//
//  BookContentDao.h
//  Work_For_Fun_20140808
//
//  Created by Snail on 12/9/14.
//  Copyright (c) 2014 Snail. All rights reserved.
//

#import "SuperDao.h"

@class BookContentBean;
@interface BookContentDao : SuperDao

+ (instancetype)sharedInstance;

- (NSArray *)selectBookContent:(NSString *)keyword fromPage:(int)fromPage toPage:(int)toPage;

@end
