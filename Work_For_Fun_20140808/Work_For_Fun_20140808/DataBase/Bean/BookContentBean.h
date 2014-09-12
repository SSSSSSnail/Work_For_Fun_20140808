//
//  BookContentBean.h
//  Work_For_Fun_20140808
//
//  Created by Snail on 12/9/14.
//  Copyright (c) 2014 Snail. All rights reserved.
//

#import "SuperBean.h"

extern NSString *const kBookContentPage;
extern NSString *const kBookContentContent;

@interface BookContentBean : SuperBean

@property (assign, nonatomic) int page;
@property (copy, nonatomic) NSString *content;

@end
