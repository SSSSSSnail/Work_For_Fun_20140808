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
#import "NoteDao.h"
#import "NoteBean.h"

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
static NSString *const kSearchResultCellIndentifier = @"searchResultCell";

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
@property (weak, nonatomic) IBOutlet UIButton *addSaveNoteButton;
@property (weak, nonatomic) IBOutlet UITableView *noteTableView;
@property (weak, nonatomic) IBOutlet UITextView *documentTextView;
@property (weak, nonatomic) IBOutlet UIView *countToolView;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *topMenuViewCollection;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

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
@property (assign, nonatomic) CGRect pageView1Frame;
@property (assign, nonatomic) CGRect pageView2Frame;
@property (assign, nonatomic) CGRect pageView3Frame;

@property (strong, nonatomic) NSIndexPath *selectedIndexPath;
@property (strong, nonatomic) NSMutableArray *noteArray;

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

- (IBAction)addSaveNoteButtonAction:(UIButton *)sender;

- (IBAction)countButtonAction:(UIButton *)sender;
- (IBAction)countViewTouchDown:(id)sender;

- (IBAction)searchViewTouchDown:(id)sender;

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

    UIImageView *searchIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"leftMenuSearchIcon"] highlightedImage:[UIImage imageNamed:@"leftMenuSearchIcon_highlight"]];
    _searchTextField.leftViewMode = UITextFieldViewModeAlways;
    _searchTextField.leftView = searchIconImageView;

    _pageViewWidth = ScreenBoundsWidth();
    _pageViewWithGapWidth = ScreenBoundsWidth() + ScrollViewGapWidth;

    _addSaveNoteButton.layer.borderColor = [UIColor colorWithRed:6.0f / 255 green:119.0f / 255 blue:247.0f / 255 alpha:1.0f].CGColor;

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
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //Reset frame to fix autolayout pop issue
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        HistoryBean *lastHistoryBean = [[HistoryDao sharedInstance] selectLastHistory];
        if (lastHistoryBean.page == 0) {
            [self update:0];
        } else {
            _pageView1.pageNumber = - 1;
            _pageView2.pageNumber = - 1;
            _pageView3.pageNumber = - 1;
            [self jumpToPageNumber:lastHistoryBean.page];
        }
    });

    _pageView1.frame = _pageView1Frame;
    _pageView2.frame = _pageView2Frame;
    _pageView3.frame = _pageView3Frame;
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

    if (_addSaveNoteButton.selected) {
        [self buttonScaleBackAnimation:sender withBounciness:bounciness];
        [GInstance() showMessageToView:self.view message:@"请先保存笔记"];
        return;
    }

    UIView *showView = nil;
    NSString *message;
    switch (sender.tag) {
        case BarButtonProfile:
            [self performSegueWithIdentifier:@"pushUpdateProfileViewController" sender:sender];
            [self buttonScaleBackAnimation:sender withBounciness:bounciness];
            [self dismissAllTopMenuView];
            return;
            break;
        case BarButtonNote:
            _topMenuTitleLabel.text = @"读书笔记";
            showView = _noteTableView;
            if (!sender.selected) {
                NSArray *chapterNoteArray = [[NoteDao sharedInstance] selectNoteOrderByDateDesc:GInstance().currentChapter.chapterId];
                if (chapterNoteArray.count > 0) {
                    self.noteArray = [chapterNoteArray mutableCopy];
                } else {
                    self.noteArray = [NSMutableArray array];
                    [_noteArray addObject:[NSNull null]];
                }
                self.selectedIndexPath = nil;
                [_noteTableView reloadData];
            }
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
            _topMenuTitleLabel.text = @"本章搜索";
            showView = _searchView;
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
            [self dismissAllTopMenuView];
            return;
            break;

        default:
            break;
    }
    [self refreshShowHiddenMenuView:showView];
    if (showView == _noteTableView) {
        _addSaveNoteButton.hidden = NO;
    } else {
        _addSaveNoteButton.hidden = YES;
    }

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

    [_topMenuViewCollection enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        [view endEditing:YES];
    }];
}

- (IBAction)barButtonTouchDragExit:(UIButton *)sender
{
    [self buttonScaleBackAnimation:sender withBounciness:16.0f];
}

- (IBAction)addSaveNoteButtonAction:(UIButton *)sender
{
    BOOL shouldInserCell;
    NSIndexPath *indexPath = _selectedIndexPath;
    if (sender.selected) {
        sender.selected = NO;
        UITextView *contentTextView = (UITextView *)[[_noteTableView cellForRowAtIndexPath:indexPath] viewWithTag:11];
        if (![_noteArray[indexPath.row] isKindOfClass:[NSNull class]]) {
            NoteBean *bean = _noteArray[indexPath.row];
            bean.chapterId = GInstance().currentChapter.chapterId;
            bean.content = contentTextView.text;
            if (bean.beanId) {
                [[NoteDao sharedInstance] updateNote:bean];
            } else {
                bean.date = [NSDate date];
                [[NoteDao sharedInstance] insertNote:bean];
            }
        } else {
            NoteBean *bean = [NoteBean new];
            bean.date = [NSDate date];
            bean.chapterId = GInstance().currentChapter.chapterId;
            bean.content = contentTextView.text;
            [[NoteDao sharedInstance] insertNote:bean];
            [_noteArray replaceObjectAtIndex:0 withObject:bean];
        }
        shouldInserCell = NO;
        self.selectedIndexPath = nil;
        [self.view endEditing:YES];
        _noteTableView.scrollEnabled = YES;
        [sender setTitle:@"新建笔记" forState:UIControlStateNormal];
    } else {
        sender.selected = YES;
        self.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        indexPath = _selectedIndexPath;
        if (![_noteArray[0] isKindOfClass:[NSNull class]]) {
            shouldInserCell = YES;
            NoteBean *bean = [NoteBean new];
            [_noteArray insertObject:bean atIndex:0];
        } else {
            shouldInserCell = NO;
        }
        [sender setTitle:@"保存笔记" forState:UIControlStateNormal];
    }
    [_noteTableView beginUpdates];
    if (shouldInserCell) {
        [_noteTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        [_noteTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    [_noteTableView endUpdates];
    [self buttonScaleBackAnimation:sender withBounciness:16.0f];
    [self.view layoutIfNeeded];
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
}

- (IBAction)searchViewTouchDown:(id)sender
{
    [_searchView endEditing:YES];
}

- (void)buttonScaleBackAnimation:(UIButton *)sender withBounciness:(CGFloat)bounciness
{
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    scaleAnimation.springBounciness = bounciness;
    scaleAnimation.springSpeed = 6.0f;
    scaleAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0f, 1.0f)];
    [sender pop_addAnimation:scaleAnimation forKey:kAnimationScaleUpOrDown];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pushUpdateProfileViewController"]) {
        WebViewController *webViewController = segue.destinationViewController;
        webViewController.webViewLoadURL = PROFILEURL;
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
    if (textField == _searchTextField) {
        ((UIImageView *)_searchTextField.leftView).highlighted = YES;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    ((UIImageView *)textField.leftView).highlighted = NO;
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

- (void)leftMenuShowed
{
    [self dismissAllTopMenuView];
}

- (void)dismissAllTopMenuView
{
    [_barButtonCollection enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
        if (button.selected) {
            [self barButtonAction:button];
        }
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
    _pageView1Frame = frame;
    _pageView1.frame = frame;
    frame.origin.x = page2FrameX;
    _pageView2Frame = frame;
    _pageView2.frame = frame;
    frame.origin.x = page3FrameX;
    _pageView3Frame = frame;
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
    return _noteArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath compare:_selectedIndexPath] == NSOrderedSame) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNoteDetailCellIndentifier forIndexPath:indexPath];
        UITextView *contentTextView = (UITextView *)[cell viewWithTag:11];
        if ([_noteArray[indexPath.row] isKindOfClass:[NSNull class]]) {
            contentTextView.text = nil;
        } else {
            NoteBean *noteBean = _noteArray[indexPath.row];
            contentTextView.text = noteBean.content;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [contentTextView becomeFirstResponder];
        });
        tableView.scrollEnabled = NO;
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNoteListCellIndentifier forIndexPath:indexPath];
        UILabel *noteLabel = (UILabel *)[cell viewWithTag:11];
        UILabel *dateLabel = (UILabel *)[cell viewWithTag:12];
        if ([_noteArray[indexPath.row] isKindOfClass:[NSNull class]]) {
            noteLabel.text = @"暂无笔记";
            dateLabel.text = nil;
            return cell;
        } else {
            NoteBean *noteBean = _noteArray[indexPath.row];
            noteLabel.text = noteBean.content;
            dateLabel.text = [self formatedDateString:noteBean.date];
            return cell;
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![_noteArray[0] isKindOfClass:[NSNull class]]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        self.noteArray = [[[NoteDao sharedInstance] selectNoteOrderByDateDesc:GInstance().currentChapter.chapterId] mutableCopy];
        NoteBean *bean = _noteArray[indexPath.row];
        [_noteArray removeObject:bean];
        [[NoteDao sharedInstance] deleteNoteById:bean.beanId];

        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath compare:_selectedIndexPath] == NSOrderedSame) {
        if (ISSCREEN4) {
            return 445.0f;
        } else {
            return 357.0f;
        }
    } else {
        return 40.0f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![_noteArray[indexPath.row] isKindOfClass:[NSNull class]]) {
        self.noteArray = [[[NoteDao sharedInstance] selectNoteOrderByDateDesc:GInstance().currentChapter.chapterId] mutableCopy];
        self.selectedIndexPath = indexPath;
        [_addSaveNoteButton setTitle:@"保存笔记" forState:UIControlStateNormal];
        _addSaveNoteButton.selected = YES;
        [_noteTableView beginUpdates];
        [_noteTableView reloadRowsAtIndexPaths:@[_selectedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        [_noteTableView endUpdates];
        [_noteTableView scrollToRowAtIndexPath:_selectedIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
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

- (NSString *)formatedDateString:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter stringFromDate:date];
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
