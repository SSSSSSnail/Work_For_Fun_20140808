//
//  MainContentViewController.m
//  Work_For_Fun_20140808
//
//  Created by Snail on 12/8/14.
//  Copyright (c) 2014 Snail. All rights reserved.
//

#import "MainContentViewController.h"
#import "LeftMenuViewController.h"
#import "WebViewController.h"

#import "BookPageView.h"
#import "ChapterBean.h"
#import "BookmarkDao.h"
#import "BookmarkBean.h"
#import "HistoryDao.h"
#import "HistoryBean.h"

typedef NS_ENUM(NSInteger, BarButton) {
    BarButtonProfile = 10,
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
static NSString *const kNoteListCellIndentifier = @"noteListCell";
static NSString *const kNoteDetailCellIndentifier = @"noteDetailCell";

@interface MainContentViewController ()<LeftMenuActionDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
// Property
@property (strong, nonatomic) UIView *leftMenuView;
@property (assign, nonatomic) CGFloat pageViewWidth;
@property (assign, nonatomic) CGFloat pageViewWithGapWidth;

@property (weak, nonatomic) NSArray *chapterArray;

// IBOutlet
@property (weak, nonatomic) IBOutlet UIScrollView *mainContentScrollView;
@property (weak, nonatomic) IBOutlet UIView *scrollContentView;

@property (weak, nonatomic) IBOutlet UIView *topBarView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *barButtonCollection;
@property (weak, nonatomic) IBOutlet UIButton *bookmarkButton;

@property (weak, nonatomic) IBOutlet UIView *topMenuView;
@property (weak, nonatomic) IBOutlet UIView *topMenuContentView;
@property (weak, nonatomic) IBOutlet UIImageView *topMenuArrow;
@property (weak, nonatomic) IBOutlet UIView *topMenuAnimationView;
@property (weak, nonatomic) IBOutlet UILabel *topMenuTitleLabel;
@property (weak, nonatomic) IBOutlet UITableView *noteTableView;
@property (weak, nonatomic) IBOutlet UITextView *documentTextView;
@property (weak, nonatomic) IBOutlet UIView *countToolView;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *topMenuViewCollection;

@property (weak, nonatomic) IBOutlet UITextField *heightTextField;
@property (weak, nonatomic) IBOutlet UITextField *weightTextField;
@property (weak, nonatomic) IBOutlet UITextField *unitDoseTextField;
@property (weak, nonatomic) IBOutlet UITextField *areaTextField;
@property (weak, nonatomic) IBOutlet UITextField *doseTextField;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *countTextFieldCollection;

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapTopMenuGesture;

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

// IBAction
- (IBAction)barButtonAction:(UIButton *)sender;
- (IBAction)barButtonTouchDown:(UIButton *)sender;
- (IBAction)barButtonTouchDragExit:(UIButton *)sender;

- (IBAction)countButtonAction:(UIButton *)sender;
- (IBAction)countViewTouchDown:(id)sender;

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

    _heightTextField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HeightLeftIcon"] highlightedImage:[UIImage imageNamed:@"HeightLeftIcon_s"]];
    _heightTextField.leftViewMode = UITextFieldViewModeAlways;

    _weightTextField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WeightLeftIcon"] highlightedImage:[UIImage imageNamed:@"WeightLeftIcon_s"]];
    _weightTextField.leftViewMode = UITextFieldViewModeAlways;

    _unitDoseTextField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DoseLeftIcon"] highlightedImage:[UIImage imageNamed:@"DoseLeftIcon_s"]];
    _unitDoseTextField.leftViewMode = UITextFieldViewModeAlways;

    //Top Menu Content View
    _topMenuContentView.layer.borderWidth = 1.0f;
    _topMenuContentView.layer.borderColor = [UIColor colorWithRed:231.0f / 255 green:231.0f / 255 blue:231.0f / 255 alpha:1.0f].CGColor;
    _topMenuContentView.layer.cornerRadius = 8.0f;
    _topMenuContentView.layer.masksToBounds = YES;

    _pageViewWidth = ScreenBoundsWidth();
    _pageViewWithGapWidth = ScreenBoundsWidth() + ScrollViewGapWidth;

    //Menu View
    LeftMenuViewController *leftMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"leftMenuViewController"];
    leftMenuViewController.delegate = self;
    self.leftMenuView = leftMenuViewController.view;
    [self.view addSubview:_leftMenuView];
    self.chapterArray = GInstance().chapterArrayOrderById;

    [_leftMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self addChildViewController:leftMenuViewController];

    //Cancel singel tap
    [_tapTopMenuGesture requireGestureRecognizerToFail:_pageView1.doubleTap];
    [_tapTopMenuGesture requireGestureRecognizerToFail:_pageView2.doubleTap];
    [_tapTopMenuGesture requireGestureRecognizerToFail:_pageView3.doubleTap];

    //PageView
    [self update:0];
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

    _topMenuViewWidth.constant = - 250.0f;
    _topMenuViewBottom.constant = ISSCREEN4 ? 400.0f : 310.0f;
    _topMenuView.alpha = 0;
}

#pragma mark - Bar Button Action
- (IBAction)barButtonAction:(UIButton *)sender
{
    __block CGFloat bounciness = 16.0f;

    UIView *showView = nil;
    NSString *message;
    switch (sender.tag) {
        case BarButtonProfile:
            [self buttonScaleBackAnimation:sender withBounciness:bounciness];
            return;
            break;
        case BarButtonNote:
            _topMenuTitleLabel.text = @"读书笔记";
            showView = _noteTableView;
            break;
        case BarButtonDocument:
            if (!GInstance().currentChapter.document.length > 0) {
                [GInstance() showMessageToView:self.view message:@"该章无文献"];
                [self buttonScaleBackAnimation:sender withBounciness:bounciness];
                return;
            } else {
                _topMenuTitleLabel.text = @"参考文献";
                _documentTextView.text = GInstance().currentChapter.document;
                showView = _documentTextView;
            }
            break;
        case BarButtonCalculator:
            _topMenuTitleLabel.text = @"计算工具";
            showView = _countToolView;
            break;
        case BarButtonSearch:
            _topMenuTitleLabel.text = @"章节查询";
            break;
        case BarButtonBookmark:
            if (_bookmarkButton.selected) {
                [[BookmarkDao sharedInstance] deleteBookmarkByPage:GInstance().currentPage];
                message = @"书签已删除";
            } else {
                BookmarkBean *bean = [BookmarkBean new];
                bean.title = GInstance().currentChapter.title;
                bean.page = GInstance().currentPage;
                bean.date = [NSDate date];
                [[BookmarkDao sharedInstance] insertBookmark:bean];
                message = @"书签已添加";
            }
            _bookmarkButton.selected = !_bookmarkButton.selected;
            [GInstance() showMessageToView:self.view message:message];
            [self buttonScaleBackAnimation:sender withBounciness:bounciness];
            return;
            break;

        default:
            break;
    }
    [self refreshShowHiddenMenuView:showView];

    if (!topMenuViewShow) {
        _topMenuViewCenterX.constant = _topBarView.center.x;
    }

    [self.view layoutIfNeeded];
    __block float viewAlpha = 0;
    [_barButtonCollection enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
        if (button == sender) {
            if (sender.selected == YES) {
                button.selected = NO;

                _topMenuViewWidth.constant = - 250.0f;
                _topMenuViewBottom.constant = ISSCREEN4 ? 400.0f : 310.0f;
                _topMenuViewCenterX.constant = sender.center.x;
                _topArrowCenterX.constant = (ScreenBoundsWidth() - 290.0f) / 2;
                viewAlpha = 0;

                topMenuViewShow = NO;

                bounciness = 26.0f;
            } else {
                button.selected = YES;

                _topMenuViewWidth.constant = 0;
                _topMenuViewBottom.constant = 0;
                _topMenuViewCenterX.constant = _topBarView.center.x;
                _topArrowCenterX.constant = sender.center.x;
                viewAlpha = 1.0f;

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
                         _topMenuView.alpha = viewAlpha;
                         [self.view layoutIfNeeded];
                     } completion:^(BOOL finished) {
                         if (!topMenuViewShow) {
                             _topMenuView.hidden = YES;
                         } else {
                             if (_documentTextView.hidden == NO) {
                                 [_documentTextView setContentOffset:CGPointZero animated:NO];
                             }
                         }
                     }];

    [self buttonScaleBackAnimation:sender withBounciness:bounciness];
}

- (void)refreshShowHiddenMenuView:(UIView *)showView
{
    [_topMenuViewCollection enumerateObjectsUsingBlock:^(UIView *menuView, NSUInteger idx, BOOL *stop) {
        if (menuView == showView) {
            menuView.hidden = NO;
        } else {
            menuView.hidden = YES;
        }
    }];
}

- (IBAction)barButtonTouchDown:(UIButton *)sender
{
    POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    scaleAnimation.duration = 0.1f;
    scaleAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(0.8f, 0.8f)];
    [sender pop_addAnimation:scaleAnimation forKey:kAnimationScaleUpOrDown];
}

- (IBAction)barButtonTouchDragExit:(UIButton *)sender
{
    [self buttonScaleBackAnimation:sender withBounciness:16.0f];
}

- (IBAction)countButtonAction:(UIButton *)sender
{
    [_countToolView endEditing:YES];
    [_countTextFieldCollection enumerateObjectsUsingBlock:^(UITextField *countTextField, NSUInteger idx, BOOL *stop) {
        ((UIImageView *)countTextField.leftView).highlighted = NO;
    }];
    if (!_heightTextField.text.length > 0 ||
        !_weightTextField.text.length > 0 ||
        !_unitDoseTextField.text.length > 0) {
        [GInstance() showMessageToView:self.view message:@"请输入完整信息"];
        _areaTextField.text = nil;
        _doseTextField.text = nil;
        return;
    }

    int height = _heightTextField.text.intValue;
    int weight = _weightTextField.text.intValue;
    int unitDose = _unitDoseTextField.text.intValue;

    float areaValue = 0.0061f * height + 0.0128f * weight - 0.1529f;
    areaValue = areaValue > 0 ? areaValue : 0;
    _areaTextField.text = [NSString stringWithFormat:@"%.2f", areaValue];
    _doseTextField.text = [NSString stringWithFormat:@"%.2f", areaValue * unitDose];
}

- (IBAction)countViewTouchDown:(id)sender
{
    [_countToolView endEditing:YES];
    [_countTextFieldCollection enumerateObjectsUsingBlock:^(UITextField *countTextField, NSUInteger idx, BOOL *stop) {
        ((UIImageView *)countTextField.leftView).highlighted = NO;
    }];
}

- (void)buttonScaleBackAnimation:(UIButton *)sender withBounciness:(CGFloat)bounciness
{
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    scaleAnimation.springBounciness = bounciness;
    scaleAnimation.springSpeed = 6.0f;
    scaleAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0f, 1.0f)];
    [sender pop_addAnimation:scaleAnimation forKey:kAnimationScaleUpOrDown];
}

//presentUpdateProfileViewController
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pushUpdateProfileViewController"]) {
        WebViewController *webViewController = segue.destinationViewController;
        webViewController.webViewLoadURL = REGISTERURL;
    }
}

#pragma mark - UITextField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [_countTextFieldCollection enumerateObjectsUsingBlock:^(UITextField *countTextField, NSUInteger idx, BOOL *stop) {
        if (countTextField == textField) {
            ((UIImageView *)countTextField.leftView).highlighted = YES;
        } else {
            ((UIImageView *)countTextField.leftView).highlighted = NO;
        }
    }];
}

#pragma mark - Show or Hidden Bar
- (IBAction)contentViewTapAction:(UITapGestureRecognizer *)sender
{
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

#pragma mark - Left Menu Controller Delegate
- (void)jumpToPageNumber:(int)pageNumber
{
    NSString *message;
    if (pageNumber != 0) {
        message = [NSString stringWithFormat:@"跳至第%d页", pageNumber];
    } else {
        message = @"封面";
    }
    [GInstance() showMessageToView:self.view message:message];

    CGRect frame = _mainContentScrollView.frame;
    frame.origin.x = CGRectGetWidth(_mainContentScrollView.frame) * pageNumber;
    [_mainContentScrollView scrollRectToVisible:frame animated:NO];
}

#pragma mark - Main ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int selectedPage = floorf(scrollView.contentOffset.x / _pageViewWithGapWidth);
    if (selectedPage != GInstance().currentPage) {
        [self update:selectedPage];
    }
}

- (void)update:(int)selectedPage
{
    GInstance().currentPage = selectedPage;
    NSLog(@"selectedPage : %d", selectedPage);

    //Refresh bookmark status

    [self refreshCurrentChapter:GInstance().currentPage];
    _bookmarkButton.selected = [[BookmarkDao sharedInstance] isPageAdded2Bookmark:selectedPage];
    HistoryBean *bean = [HistoryBean new];
    bean.title = GInstance().currentChapter.title;
    bean.date = [NSDate date];
    bean.page = GInstance().currentPage;
    [[HistoryDao sharedInstance] insertHistory:bean];

    //Refresh pageview
    BOOL page1OffsetXMatched = NO;
    BOOL page2OffsetXMatched = NO;
    BOOL page3OffsetXMatched = NO;

    BOOL pageOffsetCurrentMatched = NO;

    CGFloat pageOffsetXCurrent = selectedPage * _pageViewWithGapWidth;
    CGFloat pageOffsetXLeft = (selectedPage - 1) * _pageViewWithGapWidth;
    CGFloat pageOffsetXRight = (selectedPage + 1) * _pageViewWithGapWidth;

    CGFloat page1FrameX = CGRectGetMinX(_pageView1.frame);
    CGFloat page2FrameX = CGRectGetMinX(_pageView2.frame);
    CGFloat page3FrameX = CGRectGetMinX(_pageView3.frame);

    NSLog(@"pageOffsetXCurrent : %f", pageOffsetXCurrent);
    if (pageOffsetXCurrent == page1FrameX) {
        page1OffsetXMatched = YES;
        pageOffsetCurrentMatched = YES;
    } else if (pageOffsetXCurrent == page2FrameX) {
        page2OffsetXMatched = YES;
        pageOffsetCurrentMatched = YES;
    } else if (pageOffsetXCurrent == page3FrameX) {
        page3OffsetXMatched = YES;
        pageOffsetCurrentMatched = YES;
    }

    if (pageOffsetCurrentMatched) {
        if (page1OffsetXMatched) {
            page1FrameX = pageOffsetXCurrent;
            page2FrameX = pageOffsetXLeft;
            page3FrameX = pageOffsetXRight;

            _pageView1.toPageNumber = selectedPage;
            _pageView2.toPageNumber = selectedPage - 1;
            _pageView3.toPageNumber = selectedPage + 1;

            NSLog(@"%f", pageOffsetXCurrent);
            NSLog(@"%f", pageOffsetXLeft);
            NSLog(@"%f", pageOffsetXRight);
        } else if (page2OffsetXMatched) {
            page1FrameX = pageOffsetXRight;
            page2FrameX = pageOffsetXCurrent;
            page3FrameX = pageOffsetXLeft;

            _pageView1.toPageNumber = selectedPage + 1;
            _pageView2.toPageNumber = selectedPage;
            _pageView3.toPageNumber = selectedPage - 1;

            NSLog(@"%f", pageOffsetXRight);
            NSLog(@"%f", pageOffsetXCurrent);
            NSLog(@"%f", pageOffsetXLeft);
        } else if (page3OffsetXMatched) {
            page1FrameX = pageOffsetXLeft;
            page2FrameX = pageOffsetXRight;
            page3FrameX = pageOffsetXCurrent;

            _pageView1.toPageNumber = selectedPage - 1;
            _pageView2.toPageNumber = selectedPage + 1;
            _pageView3.toPageNumber = selectedPage;

            NSLog(@"%f", pageOffsetXLeft);
            NSLog(@"%f", pageOffsetXRight);
            NSLog(@"%f", pageOffsetXCurrent);
        } else {
            NSLog(@"ERROR!! %s", __FUNCTION__);
        }

    } else {
        page1FrameX = pageOffsetXRight;
        page2FrameX = pageOffsetXCurrent;
        page3FrameX = pageOffsetXLeft;

        _pageView1.toPageNumber = selectedPage + 1;
        _pageView2.toPageNumber = selectedPage;
        _pageView3.toPageNumber = selectedPage - 1;

        NSLog(@"Jump: %f", pageOffsetXRight);
        NSLog(@"Jump: %f", pageOffsetXCurrent);
        NSLog(@"Jump: %f", pageOffsetXLeft);
    }

    CGRect frame = CGRectMake(0, 0, ScreenBoundsWidth(), ScreenBoundsHeight() - 20);
    frame.origin.x = page1FrameX;
    _pageView1.frame = frame;
    frame.origin.x = page2FrameX;
    _pageView2.frame = frame;
    frame.origin.x = page3FrameX;
    _pageView3.frame = frame;

    [self.view layoutIfNeeded];

    [self hideShowView:_pageView1 withConstant:page1FrameX];
    [self hideShowView:_pageView2 withConstant:page2FrameX];
    [self hideShowView:_pageView3 withConstant:page3FrameX];
}

- (void)hideShowView:(BookPageView *)aPage withConstant:(CGFloat)constantValue{
    if (constantValue < 0 || constantValue > _scrollContentViewWidth.constant) {
        aPage.hidden = YES;
    } else {
        aPage.hidden = NO;
        if (aPage.pageNumber != aPage.toPageNumber || (aPage.toPageNumber == 0 && aPage == _pageView1)) {
            CGPDFPageRef pdfPage = CGPDFDocumentGetPage(GInstance().document, aPage.toPageNumber + 1);
            [aPage setPage:pdfPage];
            if (aPage.toPageNumber != 0) {
                [aPage refreshTitle:[self chapterTitleForPage:aPage.toPageNumber] pageLabel:[NSString stringWithFormat:@"%d/%ld", aPage.toPageNumber, GInstance().totalPage - 1]];
            } else {
                [aPage refreshTitle:nil pageLabel:nil];
            }
            [aPage setKeyword:@"我们希望本书"];
            aPage.pageNumber = aPage.toPageNumber;
        }
    }
}

#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNoteListCellIndentifier forIndexPath:indexPath];
    cell.textLabel.text = @"测试啊啊啊";
    return cell;
}

#pragma mark - Data
- (void)refreshCurrentChapter:(int)pageNumber
{
    [_chapterArray enumerateObjectsUsingBlock:^(ChapterBean *chapterBean, NSUInteger idx, BOOL *stop) {
        if (chapterBean.pageFrom <= pageNumber && chapterBean.pageTo >= pageNumber) {
            if (GInstance().currentChapter.chapterId != chapterBean.chapterId || !GInstance().currentChapter) {
                GInstance().currentChapter = chapterBean;
            }
        }
    }];
}

- (NSString *)chapterTitleForPage:(int)pageNumber
{
    __block NSString *title = nil;
    [_chapterArray enumerateObjectsUsingBlock:^(ChapterBean *chapterBean, NSUInteger idx, BOOL *stop) {
        if (chapterBean.pageFrom <= pageNumber && chapterBean.pageTo >= pageNumber) {
            title = chapterBean.title;
        }
    }];
    return title;
}

@end


@implementation MainView

#pragma mark - Dispatch Event
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (self.hidden || !self.userInteractionEnabled || self.alpha < 0.01) {
        return nil;
    }

    if (![self pointInside:point withEvent:event]) {
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
