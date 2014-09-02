//
//  MainContentViewController.m
//  Work_For_Fun_20140808
//
//  Created by Snail on 12/8/14.
//  Copyright (c) 2014 Snail. All rights reserved.
//

#import "MainContentViewController.h"
#import "LeftMenuViewController.h"
#import "BookPageView.h"

typedef NS_ENUM(NSInteger, BarButton) {
    BarButtonNote = 11,
    BarButtonDocument = 12,
    BarButtonCalculator = 13,
    BarButtonSearch = 14,
    BarButtonBookmark = 15
};

typedef NS_ENUM(NSInteger, viewTag) {
    viewTagNone = 0,
    viewTagMenu = 1,
    viewTagMainContent = 2,
    viewTagScrollView = 3
};

static CGFloat const TopbarHeight = 70.0f;
static CGFloat const TopbarShadowOffset = 2.0f;

static CGFloat const ScrollViewGapWidth = 10.0f;

static BOOL topMenuBarShow;
static BOOL topMenuViewShow;

static NSString *const kAnimationScaleUpOrDown = @"pop.animation.scale.up.down";

@interface MainContentViewController ()
// Property
@property (strong, nonatomic) UIView *leftMenuView;
@property (assign, nonatomic) CGFloat pageViewWidth;
@property (assign, nonatomic) CGFloat pageViewWithGapWidth;

// IBOutlet
@property (weak, nonatomic) IBOutlet UIScrollView *mainContentScrollView;
@property (weak, nonatomic) IBOutlet UIView *scrollContentView;

@property (weak, nonatomic) IBOutlet UIView *topBarView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *barButtonCollection;
@property (weak, nonatomic) IBOutlet UIView *topMenuView;
@property (weak, nonatomic) IBOutlet UIView *topMenuContentView;
@property (weak, nonatomic) IBOutlet UIImageView *topMenuArrow;
@property (weak, nonatomic) IBOutlet UIView *topMenuAnimationView;
@property (weak, nonatomic) IBOutlet UILabel *topMenuTitleLabel;

@property (weak, nonatomic) IBOutlet BookPageView *pageView1;
@property (weak, nonatomic) IBOutlet BookPageView *pageView2;
@property (weak, nonatomic) IBOutlet BookPageView *pageView3;

// Constraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewContentSizeWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewContentSizeHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollContentViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollContentViewHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuBarTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topArrowCenterX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMenuViewCenterX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMenuViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMenuViewBottom;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pageView1Offset;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pageView2Offset;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pageView3Offset;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pageViewConstraintWidth;

// IBAction
- (IBAction)barButtonAction:(UIButton *)sender;
- (IBAction)barButtonTouchDown:(UIButton *)sender;
- (IBAction)barButtonTouchDragExit:(UIButton *)sender;

- (IBAction)contentViewTapAction:(UITapGestureRecognizer *)sender;

@end

@implementation MainContentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    //Top Bar
    _topBarView.layer.shadowOffset = CGSizeMake(0, TopbarShadowOffset);
    _topBarView.layer.shadowOpacity = 0.75f;
    _topBarView.layer.shadowColor = [UIColor lightGrayColor].CGColor;

    //Top Menu Content View
    _topMenuContentView.layer.borderWidth = 1.0f;
    _topMenuContentView.layer.borderColor = [UIColor colorWithRed:231.0f / 255 green:231.0f / 255 blue:231.0f / 255 alpha:1.0f].CGColor;
    _topMenuContentView.layer.cornerRadius = 8.0f;
    _topMenuContentView.layer.masksToBounds = YES;

    _pageViewWidth = ScreenBoundsWidth();
    _pageViewWithGapWidth = ScreenBoundsWidth() + ScrollViewGapWidth;

    //Page View
    [self update:0];

    //Menu View
    LeftMenuViewController *leftMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"leftMenuViewController"];
    self.leftMenuView = leftMenuViewController.view;
    [self.view addSubview:_leftMenuView];

    [_leftMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self addChildViewController:leftMenuViewController];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    _scrollViewContentSizeWidth.constant = - _pageViewWithGapWidth * GInstance().totalPage;
    _scrollContentViewWidth.constant = _pageViewWithGapWidth * GInstance().totalPage;

    _scrollViewContentSizeHeight.constant = - (ScreenBoundsHeight() - 20.0f);
    _scrollContentViewHeight.constant = ScreenBoundsHeight() - 20.0f;

    _topMenuViewWidth.constant = - 280.0f;
    _topMenuViewBottom.constant = ISSCREEN4 ? 480.0f : 390.0f;

    _pageViewConstraintWidth.constant = ScreenBoundsWidth();
}

#pragma mark - Bar Button Action
- (IBAction)barButtonAction:(UIButton *)sender
{
    __block CGFloat bounciness = 16.0f;

    switch (sender.tag) {
        case BarButtonNote:
            _topMenuTitleLabel.text = @"读书笔记";
            break;
        case BarButtonDocument:
            _topMenuTitleLabel.text = @"参考文献";
            break;
        case BarButtonCalculator:
            _topMenuTitleLabel.text = @"计算工具";
            break;
        case BarButtonSearch:
            _topMenuTitleLabel.text = @"当前查询";
            break;
        case BarButtonBookmark:
            _topMenuTitleLabel.text = @"添加书签";
            break;

        default:
            break;
    }

    if (!topMenuViewShow) {
        _topMenuViewCenterX.constant = _topBarView.center.x;
    }

    [self.view layoutIfNeeded];
    [_barButtonCollection enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
        if (button == sender) {
            if (sender.selected == YES) {
                button.selected = NO;

                _topMenuViewWidth.constant = - 280.0f;
                _topMenuViewBottom.constant = ISSCREEN4 ? 480.0f : 390.0f;
                _topMenuViewCenterX.constant = sender.center.x;
                _topArrowCenterX.constant = (ScreenBoundsWidth() - 290.0f) / 2;;

                topMenuViewShow = NO;

                bounciness = 26.0f;
            } else {
                button.selected = YES;

                _topMenuViewWidth.constant = 0;
                _topMenuViewBottom.constant = 0;
                _topMenuViewCenterX.constant = _topBarView.center.x;
                _topArrowCenterX.constant = sender.center.x;

                topMenuViewShow = YES;
            }
        } else {
            button.selected = NO;
        }
    }];

    if (topMenuViewShow) {
        _topMenuView.hidden = NO;
    }

    [UIView animateWithDuration:0.3f
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState |
                                UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self.view layoutIfNeeded];
                     } completion:^(BOOL finished) {
                         if (!topMenuViewShow) {
                             _topMenuView.hidden = YES;
                         }
                     }];
    [self buttonScaleBackAnimation:sender withBounciness:bounciness];
}

- (IBAction)barButtonTouchDown:(UIButton *)sender
{
    NSLog(@"%s", __func__);
    POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    scaleAnimation.duration = 0.1f;
    scaleAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(0.8f, 0.8f)];
    [sender pop_addAnimation:scaleAnimation forKey:kAnimationScaleUpOrDown];
}

- (IBAction)barButtonTouchDragExit:(UIButton *)sender
{
    NSLog(@"%s", __func__);
    [self buttonScaleBackAnimation:sender withBounciness:16.0f];
}

- (void)buttonScaleBackAnimation:(UIButton *)sender withBounciness:(CGFloat)bounciness
{
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    scaleAnimation.springBounciness = bounciness;
    scaleAnimation.springSpeed = 6.0f;
    scaleAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0f, 1.0f)];
    [sender pop_addAnimation:scaleAnimation forKey:kAnimationScaleUpOrDown];
}

#pragma mark - Show or Hidden Bar
- (IBAction)contentViewTapAction:(UITapGestureRecognizer *)sender
{
    NSLog(@"%s", __FUNCTION__);

    if (topMenuBarShow) {
        _menuBarTop.constant = - TopbarHeight - 20 - TopbarShadowOffset;
    } else {
        _menuBarTop.constant = - 20.0f;
    }
    topMenuBarShow = !topMenuBarShow;

    [UIView animateWithDuration:0.3f
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState |
                                UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - Main ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int selectedPage = floorf(scrollView.contentOffset.x / _pageViewWithGapWidth);
    if (selectedPage != GInstance().currentPage) {
        [self update:selectedPage];
    }
}

-(void)update:(int)selectedPage
{
    GInstance().currentPage = selectedPage;
    NSLog(@"selectedPage : %d", selectedPage);
    BOOL page1OffsetXMatched = false;
    BOOL page2OffsetXMatched = false;
    BOOL page3OffsetXMatched = false;

    BOOL pageOffsetCurrentMatched = false;

    CGFloat pageOffsetXCurrent = selectedPage * _pageViewWithGapWidth;
    CGFloat pageOffsetXLeft = (selectedPage - 1) * _pageViewWithGapWidth;
    CGFloat pageOffsetXRight = (selectedPage + 1) * _pageViewWithGapWidth;

    NSLog(@"pageOffsetXCurrent : %f", pageOffsetXCurrent);
    if (pageOffsetXCurrent == _pageView1Offset.constant) {
        page1OffsetXMatched = true;
        pageOffsetCurrentMatched = true;
    } else if (pageOffsetXCurrent == _pageView2Offset.constant) {
        page2OffsetXMatched = true;
        pageOffsetCurrentMatched = true;
    } else if (pageOffsetXCurrent == _pageView3Offset.constant) {
        page3OffsetXMatched = true;
        pageOffsetCurrentMatched = true;
    }

    if (pageOffsetCurrentMatched) {
        if (page1OffsetXMatched) {
            _pageView1Offset.constant = pageOffsetXCurrent;
            _pageView2Offset.constant = pageOffsetXLeft;
            _pageView3Offset.constant = pageOffsetXRight;

            _pageView1.toPageNumber = selectedPage;
            _pageView2.toPageNumber = selectedPage - 1;
            _pageView3.toPageNumber = selectedPage + 1;

            NSLog(@"%f", pageOffsetXCurrent);
            NSLog(@"%f", pageOffsetXLeft);
            NSLog(@"%f", pageOffsetXRight);
        } else if (page2OffsetXMatched) {
            _pageView1Offset.constant = pageOffsetXRight;
            _pageView2Offset.constant = pageOffsetXCurrent;
            _pageView3Offset.constant = pageOffsetXLeft;

            _pageView1.toPageNumber = selectedPage + 1;
            _pageView2.toPageNumber = selectedPage;
            _pageView3.toPageNumber = selectedPage - 1;

            NSLog(@"%f", pageOffsetXRight);
            NSLog(@"%f", pageOffsetXCurrent);
            NSLog(@"%f", pageOffsetXLeft);
        } else if (page3OffsetXMatched) {
            _pageView1Offset.constant = pageOffsetXLeft;
            _pageView2Offset.constant = pageOffsetXRight;
            _pageView3Offset.constant = pageOffsetXCurrent;

            _pageView1.toPageNumber = selectedPage - 1;
            _pageView2.toPageNumber = selectedPage + 1;
            _pageView3.toPageNumber = selectedPage;

            NSLog(@"%f", pageOffsetXLeft);
            NSLog(@"%f", pageOffsetXRight);
            NSLog(@"%f", pageOffsetXCurrent);
        } else {
            NSLog(@"+_+_+_+_+_+_+_+_+_+_+_+_+_");
        }
        [self.view setNeedsLayout];

        [self hideShowView:_pageView1 withConstant:_pageView1Offset.constant];
        [self hideShowView:_pageView2 withConstant:_pageView2Offset.constant];
        [self hideShowView:_pageView3 withConstant:_pageView3Offset.constant];
    }
}

-(void)hideShowView:(BookPageView *)aPage withConstant:(CGFloat)constantValue{
    if (constantValue < 0 || constantValue > _scrollContentViewWidth.constant) {
        aPage.hidden = YES;
    } else {
        aPage.hidden = NO;
        if (aPage.pageNumber != aPage.toPageNumber || (aPage.toPageNumber == 0 && aPage == _pageView1)) {
            CGPDFPageRef pdfPage = CGPDFDocumentGetPage(GInstance().document, aPage.toPageNumber + 1);
            [aPage setPage:pdfPage];
            [aPage setKeyword:@"我们希望本书"];
            aPage.pageNumber = aPage.toPageNumber;
        }
    }
}

@end


@implementation MainView

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
    if ([scrollView pointInside:[self convertPoint:point toView:scrollView] withEvent:event]) {
        targetTag = viewTagMenu;
    } else {
        targetTag = viewTagMainContent;
    }

    UIView *targetView = [self viewWithTag:targetTag];
    __block UIView *hitView = [self viewWithTag:targetTag];
    [targetView.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        CGPoint thePoint = [self convertPoint:point toView:obj];
        if ([obj pointInside:thePoint withEvent:event]) {
            UIView *theSubHitView = [obj hitTest:thePoint withEvent:event];
            if (theSubHitView) {
                hitView = theSubHitView;
                *stop = YES;
            }
        }
    }];

    return hitView;
}



@end


@implementation MainScrollView

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (CGRectContainsPoint(self.bounds, point)) {
        if (topMenuBarShow) {
            if (point.y > TopbarHeight && !topMenuViewShow) {
                return YES;
            } else {
                return NO;
            }
        } else {
            return YES;
        }
    }

    return NO;
}

@end
