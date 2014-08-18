//
//  MainView.m
//  Work_For_Fun_20140808
//
//  Created by Snail on 14/8/14.
//  Copyright (c) 2014 Snail. All rights reserved.
//

#import "MainView.h"

static CGFloat const leftMenuButtonWidth = 30.0f;
static CGFloat const scrollViewOffset = 297.0f;

typedef NS_ENUM(NSInteger, viewTag) {
    viewTagNone = 0,
    viewTagMenu = 1,
    viewTagMainContent = 2,
    viewTagScrollView = 3
};

@interface MainView ()

@end

@implementation MainView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - Dispatch Event
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{

    if (self.hidden || !self.userInteractionEnabled || self.alpha < 0.01)
    {
        return nil;
    }

    if (![self pointInside:point withEvent:event])
    {
        return nil;
    }

    int targetTag = 0;

    UIScrollView *scrollView = (UIScrollView *)[self viewWithTag:viewTagScrollView];

    if (scrollView.contentOffset.x <  scrollViewOffset) {
        targetTag = viewTagMenu;
    } else {
        if (point.x > leftMenuButtonWidth) {
            targetTag = viewTagMainContent;
        } else {
            targetTag = viewTagMenu;
        }
    }

    UIView *targetView = [self viewWithTag:targetTag];

    __block UIView *hitView = [self viewWithTag:targetTag];
    [targetView.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        CGPoint thePoint = [self convertPoint:point toView:obj];
        UIView *theSubHitView = [obj hitTest:thePoint withEvent:event];
        if (theSubHitView != nil) {
            hitView = theSubHitView;
            *stop = YES;
        }
    }];
    
    return hitView;
}

@end
