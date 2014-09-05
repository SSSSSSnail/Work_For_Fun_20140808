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

static NSString *const kADNumber = @"adnumber";
static NSString *const kUserGuide = @"userGuide";

@interface GuideViewController ()

@property (assign, nonatomic) BOOL showedGuideAlready;
@property (weak, nonatomic) IBOutlet UIImageView *adImageView;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *scrollImageViewCollection;
- (IBAction)tapADImageView:(id)sender;
- (IBAction)tapStartImageView:(id)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewContentHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewContentWidth;

@end

@implementation GuideViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    int adNumber = [userDefaults integerForKey:kADNumber];
    if (adNumber == 1) {
        adNumber = 2;
    } else {
        adNumber = 1;
    }
    [userDefaults setInteger:adNumber forKey:kADNumber];

    _showedGuideAlready = [userDefaults boolForKey:kUserGuide];

    if (!_showedGuideAlready) {
        [userDefaults setBool:YES forKey:kUserGuide];
    }
    [userDefaults synchronize];

    NSMutableString *imageNameString = [NSMutableString stringWithFormat:@"ad%d", adNumber];
    if (!ISSCREEN4) {
        [imageNameString appendString:@"_3"];
    }
    _adImageView.image = [UIImage imageNamed:imageNameString];

    if (!_showedGuideAlready) {
        [_scrollImageViewCollection enumerateObjectsUsingBlock:^(UIImageView *imageView, NSUInteger idx, BOOL *stop) {
            NSMutableString *imageNameString = [NSMutableString stringWithFormat:@"Guide%ld", (long)imageView.tag];
            if (!ISSCREEN4) {
                [imageNameString stringByAppendingString:@"_3"];
            }
            imageView.image = [UIImage imageNamed:imageNameString];
        }];
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
    _scrollViewContentWidth.constant = - (ScreenBoundsWidth() + 10.0f) * 4;
    _scrollViewContentHeight.constant = - ScreenBoundsHeight();
}

- (IBAction)tapADImageView:(id)sender
{
    if (_showedGuideAlready) {
        //Dismiss
        [self performSegueWithIdentifier:@"modalToMainController" sender:self];
    } else {
        //Show User Guide
        [UIView transitionWithView:_adImageView duration:1 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCurlUp animations:^{
            _adImageView.hidden = YES;
        } completion:^(BOOL finished) {}];
    }
}

- (IBAction)tapStartImageView:(id)sender
{
    [self performSegueWithIdentifier:@"modalToMainController" sender:self];
}

@end
