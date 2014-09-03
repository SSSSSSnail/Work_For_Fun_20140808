//
//  GlobalInstance.h
//  Work_For_Fun_20140808
//
//  Created by Snail on 23/8/14.
//  Copyright (c) 2014 Snail. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const DBName;

@interface GlobalInstance : NSObject

+ (instancetype)sharedManager;

@property (copy, nonatomic, readonly) NSString *documentPath;
@property (assign, nonatomic, readonly) CGPDFDocumentRef document;
@property (assign, nonatomic, readonly) long totalPage;
@property (assign, nonatomic) int currentPage;

@property (strong, nonatomic) FMDatabase *db;

- (BOOL)initDataBase;
- (void)closeDatabase;

- (void)showJumpMessageToView:(UIView *)view message:(NSString *)message;

@end

GlobalInstance *GInstance();

CGFloat ScreenBoundsWidth();
CGFloat ScreenBoundsHeight();

NSString *DocumentDirectory();