//
//  GlobalInstance.m
//  Work_For_Fun_20140808
//
//  Created by Snail on 23/8/14.
//  Copyright (c) 2014 Snail. All rights reserved.
//

#import "GlobalInstance.h"

NSString *const DBName = @"book.sqlite";
int const MaxBookmarkCount = 20;
int const MaxHistoryCount = 20;

NSString *const kADString = @"adnumber";
NSString *const kUserGuide = @"userGuide";
NSString *const kUserIdentifier = @"userIdentifier";

NSString *const kRegisterSuccess = @"baxterbook://blank";

static NSString *const kDeviceType = @"IPHONE";

@interface GlobalInstance ()

@property (copy, nonatomic) NSString *documentPath;
@property (assign, nonatomic) CGPDFDocumentRef document;
@property (assign, nonatomic) long totalPage;

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