//
//  SuperBean.m
//  Work_For_Fun_20140808
//
//  Created by Snail on 3/9/14.
//  Copyright (c) 2014 Snail. All rights reserved.
//

#import "SuperBean.h"

NSString *const kBeanId = @"serial";

@implementation SuperBean

- (NSArray *)columnArray
{
    NSAssert(NO, @"SubClass: columnString");
    return nil;
}

- (NSArray *)valueArray
{
    NSAssert(NO, @"SubClass: valueArray");
    return nil;
}

@end
