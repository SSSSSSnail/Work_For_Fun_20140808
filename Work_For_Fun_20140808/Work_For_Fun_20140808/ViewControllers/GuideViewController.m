//
//  GuideViewController.m
//  Work_For_Fun_20140808
//
//  Created by Snail on 2/9/14.
//  Copyright (c) 2014 Snail. All rights reserved.
//

#import "GuideViewController.h"

#import "ChapterDao.h"
#import "BookmarkDao.h"
#import "BookmarkBean.h"

@interface GuideViewController ()

@property (assign, nonatomic) BOOL showedGuideAlready;
@property (weak, nonatomic) IBOutlet UIImageView *adImageView;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *scrollImageViewCollection;
- (IBAction)tapADImageView:(id)sender;
- (IBAction)tapStartImageView:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *guideScrollView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewContentHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewContentWidth;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *guideImageViewContentWidthCollection;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (assign, nonatomic) BOOL tapADAlready;

@end

@implementation GuideViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *adString = LoadStringUserDefault(kADString);
    if ([adString isEqualToString:@"1"]) {
        adString = @"2";
    } else {
        adString = @"1";
    }
    SaveStringUserDefault(kADString, adString);

    NSString *guideString = LoadStringUserDefault(kUserGuide);
    if (!guideString) {
        SaveStringUserDefault(kUserGuide, @"Y");
        _showedGuideAlready = NO;
    } else {
        _showedGuideAlready = YES;
    }
    
    UIImage *imagess = [UIImage imageNamed:RenameFullScreenImage([NSString stringWithFormat:@"ad%@", adString])];
    
    _adImageView.image = imagess;

    if (!_showedGuideAlready) {
        [_scrollImageViewCollection enumerateObjectsUsingBlock:^(UIImageView *imageView, NSUInteger idx, BOOL *stop) {
            imageView.image = [UIImage imageNamed:RenameFullScreenImage([NSString stringWithFormat:@"Guide%ld", (long)imageView.tag])];
        }];
        _guideScrollView.hidden = NO;
        _pageControl.hidden = NO;
    } else {
        _guideScrollView.hidden = YES;
        _pageControl.hidden = YES;
    }
    
    if (!LoadStringUserDefault(kUserIdentifier)) {
        _adImageView.hidden = YES;
    } else {
        _adImageView.hidden = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (LoadStringUserDefault(kUserIdentifier)) {
        _adImageView.hidden = NO;
    }
    _guideScrollView.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (!LoadStringUserDefault(kUserIdentifier)) {
        [self performSegueWithIdentifier:@"presentLoginViewController" sender:self];
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self tapADImageView:nil];
        });
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    _scrollViewContentWidth.constant = - ScreenBoundsWidth() * 4;
    _scrollViewContentHeight.constant = - ScreenBoundsHeight();
    [_guideImageViewContentWidthCollection enumerateObjectsUsingBlock:^(NSLayoutConstraint *imageViewConstraint, NSUInteger idx, BOOL *stop) {
        imageViewConstraint.constant = ScreenBoundsWidth();
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int currentPage = floorf(scrollView.contentOffset.x / ScreenBoundsWidth());
    _pageControl.currentPage = currentPage;
}

- (IBAction)tapADImageView:(id)sender
{
    if (_tapADAlready) {
        return;
    }
    _tapADAlready = YES;
    if (_showedGuideAlready) {
        //Dismiss
        [self performSegueWithIdentifier:@"modalToMainController" sender:self];
    } else {
        //Show User Guide
        [UIView transitionWithView:_adImageView duration:1 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCurlUp animations:^{
            _adImageView.hidden = YES;
        } completion:^(BOOL finished) {
        }];
    }
}

- (IBAction)tapStartImageView:(id)sender
{
    [self performSegueWithIdentifier:@"modalToMainController" sender:self];
}

@end
