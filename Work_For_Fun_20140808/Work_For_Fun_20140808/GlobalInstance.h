//
//  GlobalInstance.h
//  Work_For_Fun_20140808
//
//  Created by Snail on 23/8/14.
//  Copyright (c) 2014 Snail. All rights reserved.
//

#define SERVERURL @"http://www.baxterselectedschedules.com.cn/"
//#define SERVERURL @"http://192.168.1.8:8080/baxter-book/"
#define LOGINURL [NSString stringWithFormat:@"%@%@", SERVERURL, @"user.do"]
#define REGISTERURL [NSString stringWithFormat:@"%@%@", SERVERURL, @"register.jsp?from=app"]
#define UPLOADLOG [NSString stringWithFormat:@"%@%@", SERVERURL, @"app.do"]

#import <Foundation/Foundation.h>

extern NSString *const DBName;
extern int const MaxBookmarkCount;
extern int const MaxHistoryCount;

extern NSString *const kADString;
extern NSString *const kUserGuide;
extern NSString *const kUserIdentifier;

extern NSString *const kRegisterSuccess;

@class ChapterBean;
@interface GlobalInstance : NSObject

+ (instancetype)sharedManager;

@property (copy, nonatomic, readonly) NSString *documentPath;
@property (assign, nonatomic, readonly) CGPDFDocumentRef document;
@property (assign, nonatomic, readonly) long totalPage;
@property (assign, nonatomic) int currentPage;
@property (strong, nonatomic) ChapterBean *currentChapter;

@property (strong, nonatomic) FMDatabase *db;

- (BOOL)initDataBase;
- (void)closeDatabase;

- (void)showMessageToView:(UIView *)view message:(NSString *)message;
- (MBProgressHUD *)showMessageToView:(UIView *)view message:(NSString *)message autoHide:(BOOL)autoHide;

@end

GlobalInstance *GInstance();

CGFloat ScreenBoundsWidth();
CGFloat ScreenBoundsHeight();

NSString *DocumentDirectory();

NSString *SystemVersion();
NSString *DeviceType();

void SaveStringUserDefault(NSString *key, NSString *value);
NSString *LoadStringUserDefault(NSString *key);