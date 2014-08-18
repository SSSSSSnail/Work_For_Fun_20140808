//
//  MainContentViewController.m
//  Work_For_Fun_20140808
//
//  Created by Snail on 12/8/14.
//  Copyright (c) 2014 Snail. All rights reserved.
//

#import "MainContentViewController.h"
#import "LeftMenuViewController.h"

@interface MainContentViewController ()

@property (strong, nonatomic) UIView *leftMenuView;

@end

@implementation MainContentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    LeftMenuViewController *leftMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"leftMenuViewController"];
    self.leftMenuView = leftMenuViewController.view;
    [self.view addSubview:_leftMenuView];

    [_leftMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self addChildViewController:leftMenuViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)testButtonClick:(id)sender
{
    NSLog(@"%s", __FUNCTION__);
}

@end
