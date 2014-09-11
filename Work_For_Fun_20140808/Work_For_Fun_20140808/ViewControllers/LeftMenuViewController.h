//
//  LeftMenuViewController.h
//  Work_For_Fun_20140808
//
//  Created by Snail on 12/8/14.
//  Copyright (c) 2014 Snail. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LeftMenuActionDelegate<NSObject>

- (void)jumpToPageNumber:(int)pageNumber;
- (void)leftMenuShowed;

@end

@interface LeftMenuViewController : UIViewController

@property (weak, nonatomic) id<LeftMenuActionDelegate> delegate;

@end


@interface MenuScrollView : UIScrollView

@end
