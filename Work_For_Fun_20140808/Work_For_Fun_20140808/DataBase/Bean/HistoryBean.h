//
//  HistoryBean.h
//  Work_For_Fun_20140808
//
//  Created by Snail on 4/9/14.
//  Copyright (c) 2014 Snail. All rights reserved.
//

#import "SuperBean.h"

extern NSString *const kHistoryTitle;
extern NSString *const kHistoryPage;
extern NSString *const kHistoryDate;

@interface HistoryBean : SuperBean

@property (copy, nonatomic) NSString *title;
@property (assign, nonatomic) int page;
@property (strong, nonatomic) NSDate *date;

@end
