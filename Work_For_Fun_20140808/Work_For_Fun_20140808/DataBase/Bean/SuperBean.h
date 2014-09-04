//
//  SuperBean.h
//  Work_For_Fun_20140808
//
//  Created by Snail on 3/9/14.
//  Copyright (c) 2014 Snail. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kBeanId;

@interface SuperBean : NSObject

@property (copy, nonatomic, readonly) NSString *columnString;
@property (strong, nonatomic, readonly) NSArray *valueArray;

@end
