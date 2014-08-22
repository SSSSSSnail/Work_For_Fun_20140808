//
//  MainContentViewController.m
//  Work_For_Fun_20140808
//
//  Created by Snail on 12/8/14.
//  Copyright (c) 2014 Snail. All rights reserved.
//

#import "MainContentViewController.h"
#import "LeftMenuViewController.h"

typedef NS_ENUM(NSInteger, BarButton) {
    BarButtonNote = 11,
    BarButtonDocument = 12,
    BarButtonCalculator = 13,
    BarButtonSearch = 14,
    BarButtonBookmark = 15
};

@interface MainContentViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *mainContentScrollView;
@property (weak, nonatomic) IBOutlet UIView *scrollContentView;
@property (strong, nonatomic) UIView *leftMenuView;

@property (weak, nonatomic) IBOutlet UIView *topBarView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *barButtonCollection;

#pragma mark - Constraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewContentSizeWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewContentSizeHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollContentViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollContentViewHeight;

- (IBAction)barButtonAction:(UIButton *)sender;
- (IBAction)contentViewTapAction:(UITapGestureRecognizer *)sender;

@end

@implementation MainContentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    //Top Bar
    _topBarView.layer.shadowOffset = CGSizeMake(0, 2);
    _topBarView.layer.shadowOpacity = 0.75f;
    _topBarView.layer.shadowColor = [UIColor lightGrayColor].CGColor;

    //Page View
    for (int i = 0; i < 5; i ++) {
        UIView *pageView = [UIView new];
        [_scrollContentView addSubview:pageView];
        pageView.backgroundColor = [UIColor yellowColor];
        [pageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_scrollContentView.mas_top);
            make.bottom.equalTo(_scrollContentView.mas_bottom);
            make.left.equalTo(@(330 * i));
            make.width.equalTo(@(320));
        }];

        UIView *testView = [UIView new];
        [pageView addSubview:testView];
        testView.backgroundColor = [UIColor yellowColor];
        [testView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(pageView.mas_top);
            make.height.equalTo(@(20));
            make.left.equalTo(pageView.mas_left);
            make.width.equalTo(pageView.mas_width);
        }];
    }

    //Menu View
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

#pragma mark - Update Constraints
- (void)updateViewConstraints
{
    [super updateViewConstraints];
    _scrollViewContentSizeWidth.constant = -990.0f;
    _scrollContentViewWidth.constant = 990.0f;

    if (ISSCREEN4) {
        _scrollViewContentSizeHeight.constant = -548.0f;
        _scrollContentViewHeight.constant = 548.0f;
    } else {
        _scrollViewContentSizeHeight.constant = -460.0f;
        _scrollContentViewHeight.constant = 460.0f;
    }
}

#pragma mark - Bar Button Action
- (IBAction)barButtonAction:(UIButton *)sender
{
    NSLog(@"Button : %d", sender.tag);
}

#pragma mark - Show or Hidden Bar
- (IBAction)contentViewTapAction:(UITapGestureRecognizer *)sender
{
    NSLog(@"%s", __FUNCTION__);
}
@end
