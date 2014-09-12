//
//  BookContentBean.m
//  Work_For_Fun_20140808
//
//  Created by Snail on 12/9/14.
//  Copyright (c) 2014 Snail. All rights reserved.
//

#import "BookContentBean.h"

NSString *const kBookContentPage = @"page";
NSString *const kBookContentContent = @"content";

@implementation BookContentBean

- (NSArray *)columnArray
{
    return @[kBookContentPage, kBookContentContent];
}

- (NSArray *)valueArray
{
    return @[@(_page), _content];
}

@end
