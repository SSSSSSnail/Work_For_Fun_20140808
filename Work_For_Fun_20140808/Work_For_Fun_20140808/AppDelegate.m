//
//  AppDelegate.m
//  Work_For_Fun_20140808
//
//  Created by Snail on 7/8/14.
//  Copyright (c) 2014 Snail. All rights reserved.
//

#import "AppDelegate.h"
#import "LogDao.h"
#import "LogBean.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if (![GInstance() initDataBase]) {
        NSLog(@"ERROR: Database init failed!!");
    } else {
        [GInstance() loadInitChapters];
    }
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if (LoadStringUserDefault(kUserIdentifier)) {

        NSArray *recordArray = [[LogDao sharedInstance] selectLogBeforeTodayOrderByDateDesc];
        if (recordArray.count > 0) {
            NSLog(@"Start upload log");
            NSMutableDictionary *paramDic = [@{@"action" : @"log",
                                               @"version" : SystemVersion(),
                                               @"devicetype" : DeviceType(),
                                               @"userid" : LoadStringUserDefault(kUserIdentifier)} mutableCopy];
            
            NSMutableString *uploadRecordString = [NSMutableString string];
            [recordArray enumerateObjectsUsingBlock:^(LogBean *logBean, NSUInteger idx, BOOL *stop) {
                if (idx != 0) {
                    [uploadRecordString appendString:@"@"];
                }
                [uploadRecordString appendString:logBean.date];
                [uploadRecordString appendString:logBean.record];
            }];
            [paramDic setObject:uploadRecordString forKey:@"records"];
            [RequestWrapper requestWithURL:UPLOADLOGURL withParameters:paramDic success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                if ([responseObject[@"result"] isEqualToNumber:@1]) {
                    //Delete logs
                    [[LogDao sharedInstance] deleteLogByBeans:recordArray];
                }
                if (![responseObject[@"version"] isEqualToString:SystemVersion()]) {
                    [[UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"发现新版本, 是否更新?" cancelButtonTitle:@"取消" otherButtonTitles:@[@"更新"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:DOWNLOADURL]];
                    }] show];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"ERROR: %@", error);
            }];
        }
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
