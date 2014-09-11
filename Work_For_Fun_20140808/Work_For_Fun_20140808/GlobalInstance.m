//
//  GlobalInstance.m
//  Work_For_Fun_20140808
//
//  Created by Snail on 23/8/14.
//  Copyright (c) 2014 Snail. All rights reserved.
//

#import "GlobalInstance.h"
#import "LogDao.h"
#import "LogBean.h"
#import "ChapterDao.h"
#import "ChapterBean.h"

NSString *const DBName = @"book.sqlite";
int const MaxHistoryCount = 30;

NSString *const kADString = @"adnumber";
NSString *const kUserGuide = @"userGuide";
NSString *const kUserIdentifier = @"userIdentifier";

NSString *const kRegisterSuccess = @"baxterbook://blank";

static NSString *const kDeviceType = @"IPHONE";

@interface GlobalInstance ()

@property (copy, nonatomic) NSString *documentPath;
@property (assign, nonatomic) CGPDFDocumentRef document;
@property (assign, nonatomic) long totalPage;

@property (strong, nonatomic) NSArray *chapterArrayOrderById;

@end

@implementation GlobalInstance

+ (instancetype)sharedManager
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[GlobalInstance alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.documentPath = [[NSBundle mainBundle] pathForResource:@"book" ofType:@"pdf"];
        self.document = CGPDFDocumentCreateWithURL((CFURLRef)[NSURL fileURLWithPath:_documentPath]);
        self.totalPage = CGPDFDocumentGetNumberOfPages(_document);
        self.currentPage = - 1;
    }
    return self;
}

- (BOOL)initDataBase
{
    BOOL success;
    NSError *error;
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *writableDBPath = [DocumentDirectory() stringByAppendingPathComponent:DBName];

//    [fm removeItemAtPath:writableDBPath error:&error];
    success = [fm fileExistsAtPath:writableDBPath];
    if(!success){
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DBName];
        success = [fm copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
        if(!success){
            NSLog(@"%@", [error localizedDescription]);
        }
    }
    if(success){
        self.db = [FMDatabase databaseWithPath:writableDBPath];
        if ([_db open]) {
            [_db setShouldCacheStatements:YES];
        }else{
            NSLog(@"Failed to open database.");
            success = NO;
        }
    }
    return success;
}

- (void) closeDatabase{
    [_db close];
}

- (void)loadInitChapters
{
    self.chapterArrayOrderById = [[ChapterDao sharedInstance] selectAllChapterOrderById];
}

- (void)setCurrentChapter:(ChapterBean *)currentChapter
{
    _currentChapter = currentChapter;
    LogDao *logDao = [LogDao sharedInstance];
    LogBean *bean = [logDao selectLogToday];
    if (bean) {
        bean.record = [self recordStringWithRecord:bean.record currentChapter:currentChapter];
        [logDao updateLog:bean];
    } else {
        bean = [LogBean new];
        bean.chapterId = currentChapter.chapterId;
        bean.record = [self recordStringWithRecord:nil currentChapter:currentChapter];;
        bean.date = [logDao formatedDateString:[NSDate date]];
        [logDao insertLog:bean];
    }
}

- (NSString *)recordStringWithRecord:(NSString *)record currentChapter:(ChapterBean *)currentChapter
{
    NSMutableString *recordString;
    if (record.length > 0) {
        recordString = [NSMutableString stringWithString:record];
        [recordString replaceCharactersInRange:NSMakeRange(currentChapter.chapterId, 1) withString:@"1"];
    } else {
        recordString = [NSMutableString string];
        [GInstance().chapterArrayOrderById enumerateObjectsUsingBlock:^(ChapterBean *chapterBean, NSUInteger idx, BOOL *stop) {
            if (chapterBean.chapterId == currentChapter.chapterId) {
                [recordString appendString:@"1"];
            } else {
                [recordString appendString:@"0"];
            }
        }];
    }

    return recordString;
}

- (void)showMessageToView:(UIView *)view message:(NSString *)message
{
    [self showMessageToView:view message:message autoHide:YES];
}

- (MBProgressHUD *)showMessageToView:(UIView *)view message:(NSString *)message autoHide:(BOOL)autoHide
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];

	hud.mode = MBProgressHUDModeText;
	hud.labelText = message;
	hud.margin = 10.f;
	hud.removeFromSuperViewOnHide = YES;

    if (autoHide) {
        [hud hide:YES afterDelay:1.5f];
    }

    return hud;
}

@end

GlobalInstance *GInstance()
{
    return [GlobalInstance sharedManager];
}

CGFloat ScreenBoundsWidth()
{
    return [UIScreen mainScreen].bounds.size.width;
}

CGFloat ScreenBoundsHeight()
{
    return [UIScreen mainScreen].bounds.size.height;
}

NSString *DocumentDirectory()
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return paths[0];
}

NSString *SystemVersion()
{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    return version;
}

NSString *DeviceType()
{
    return kDeviceType;
}

void SaveStringUserDefault(NSString *key, NSString *value)
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:value forKey:key];
    [userDefaults synchronize];
}

NSString *LoadStringUserDefault(NSString *key)
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults stringForKey:key];
}
