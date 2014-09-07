//
//  AnimationWrapper.h
//  UUAP
//
//  Created by Snail on 11/6/14.
//  Copyright (c) 2014 baidu. All rights reserved.
//

@interface AnimationWrapper : NSObject

+ (void)addShakeAnimation:(UIView *)shakeView completeBLock:(void (^) ())complete;
+ (void)addScaleUpAnimation:(UIView *)scaleView completeBlock:(void (^) ())complete;

@end
