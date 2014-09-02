//
//  GlobalInstance.m
//  Work_For_Fun_20140808
//
//  Created by Snail on 23/8/14.
//  Copyright (c) 2014 Snail. All rights reserved.
//

#import "GlobalInstance.h"

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
//        self.totalPage = 5;
        self.currentPage = -1;
    }
    return self;
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
