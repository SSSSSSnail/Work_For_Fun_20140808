//
//  AnimationWrapper.m
//  UUAP
//
//  Created by Snail on 11/6/14.
//  Copyright (c) 2014 baidu. All rights reserved.
//

#import "AnimationWrapper.h"

@implementation AnimationWrapper

+ (void)addShakeAnimation:(UIView *)shakeView completeBLock:(void (^) ())complete;
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position.x";
    animation.values = @[ @0, @5, @-5, @5, @0 ];
    animation.keyTimes = @[ @0, @(1 / 6.0), @(3 / 6.0), @(5 / 6.0), @1 ];
    animation.duration = 0.4;

    animation.additive = YES;

    [shakeView.layer addAnimation:animation forKey:@"baidu.animation.shake"];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        complete();
    });
}

+ (void)addScaleUpAnimation:(UIView *)scaleView completeBlock:(void (^) ())complete
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"transform.scale";
    animation.values = @[ @1, @1.5, @0.8, @1.2, @1 ];
    animation.keyTimes = @[ @0, @(1 / 6.0), @(3 / 6.0), @(5 / 6.0), @1 ];
    animation.duration = 0.4;

    [scaleView.layer addAnimation:animation forKey:@"baidu.animation.scale"];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        complete();
    });
}

@end
