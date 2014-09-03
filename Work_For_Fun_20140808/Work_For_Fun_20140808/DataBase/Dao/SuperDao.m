//
//  SuperDao.m
//  Work_For_Fun_20140808
//
//  Created by Snail on 2/9/14.
//  Copyright (c) 2014 Snail. All rights reserved.
//

#import "SuperDao.h"
@interface SuperDao()

@property (copy, nonatomic) NSString *dbPath;

@end

@implementation SuperDao

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dbPath = [DocumentDirectory() stringByAppendingPathComponent:DBName];
    }
    return self;
}

@end