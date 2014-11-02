//
//  LeftMenuViewController.m
//  Work_For_Fun_20140808
//
//  Created by Snail on 12/8/14.
//  Copyright (c) 2014 Snail. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "ChapterDao.h"
#import "ChapterBean.h"
#import "BookmarkDao.h"
#import "BookmarkBean.h"
#import "HistoryDao.h"
#import "HistoryBean.h"
#import "BookContentDao.h"
#import "BookContentBean.h"

typedef NS_ENUM(NSInteger, SegmentedIndex) {
    SegmentedIndexChapter = 0,
    SegmentedIndexLetter = 1,
    SegmentedIndexBookmark = 2,
    SegmentedIndexAbout = 3
};

static CGFloat const scrollViewOffset = 23.0f;
static NSString *const kEmptyCellIdentifier = @"emptyCell";
static NSString *const kSearchResultCellIdentifier = @"searchResultCell";
static NSString *const kChapterCellIdentifier = @"chapterCell";
static NSString *const kLetterCellIdentifier = @"letterCell";
static NSString *const kBookmarkCellIdentifier = @"bookmarkCell";
static NSString *const kHistoryCellIdentifier = @"historyCell";


@interface LeftMenuViewController ()<UITextFieldDelegate, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

// IBOutlet
@property (weak, nonatomic) IBOutlet UIScrollView *menuScrollView;
@property (weak, nonatomic) IBOutlet UIView *scrollContentView;
@property (weak, nonatomic) IBOutlet UIView *blackMaskView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSwitchSegmentedControl;
@property (weak, nonatomic) IBOutlet UIView *typeSwitchAnimationView;
@property (weak, nonatomic) IBOutlet UITableView *chapterTableView;
@property (weak, nonatomic) IBOutlet UITableView *letterTableView;
@property (weak, nonatomic) IBOutlet UIView *bookmarkHistoryView;
@property (weak, nonatomic) IBOutlet UITableView *bookmarkTableView;
@property (weak, nonatomic) IBOutlet UITableView *historyTableView;
@property (weak, nonatomic) IBOutlet UIView *aboutView;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *typeViewsCollection;

@property (weak, nonatomic) IBOutlet UITableView *searchResultTableView;

// IBAction
- (IBAction)tapLeftView:(UITapGestureRecognizer *)sender;
- (IBAction)typeSegmentedControlValueChange:(UISegmentedControl *)sender;

// Contrains
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewContentTop2Bottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidthConstraint;


// Property
@property (strong, nonatomic) NSArray *chapterArrayOrderById;
@property (strong, nonatomic) NSArray *chapterArrayOrderByLetter;
@property (strong, nonatomic) NSMutableDictionary *letter2indexDictionary;
@property (strong, nonatomic) NSArray *bookmarkArrayOrderByDate;
@property (strong, nonatomic) NSArray *historyArrayOrderByDate;

@property (strong, nonatomic) NSArray *searchResultArray;

@end

@implementation LeftMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIImageView *searchIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"leftMenuSearchIcon"] highlightedImage:[UIImage imageNamed:@"leftMenuSearchIcon_highlight"]];
    _searchTextField.leftViewMode = UITextFieldViewModeAlways;
    _searchTextField.leftView = searchIconImageView;

    self.chapterArrayOrderById = GInstance().chapterArrayOrderById;
    self.chapterArrayOrderByLetter = [[ChapterDao sharedInstance] selectAllChapterOrderByLetter];
    self.letter2indexDictionary = [NSMutableDictionary dictionary];

    self.searchResultArray = @[];

    [_bookmarkTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kEmptyCellIdentifier];
    [_historyTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kEmptyCellIdentifier];

    _letterTableView.backgroundColor = [UIColor colorWithRed:231.0f / 255 green:232.0f / 255 blue:226.0f / 255 alpha:1.0f];
    _menuScrollView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    UITableViewHeaderFooterView *bookmarkHeaderFooterView = [_bookmarkTableView headerViewForSection:0];
    bookmarkHeaderFooterView.textLabel.textColor = [UIColor colorWithRed:2.0f/255 green:83.0f/255 blue:157.0f/255 alpha:1.0f];
    UITableViewHeaderFooterView *historyHeaderFooterView = [_historyTableView headerViewForSection:0];
    historyHeaderFooterView.textLabel.textColor = [UIColor colorWithRed:2.0f/255 green:83.0f/255 blue:157.0f/255 alpha:1.0f];

    [_menuScrollView setContentOffset:CGPointMake((ScreenBoundsWidth() - scrollViewOffset), 0) animated:NO];
    _menuScrollView.hidden = NO;
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
    _scrollViewContentTop2Bottom.constant = - ScreenBoundsHeight();
    _contentViewWidthConstraint.constant = ScreenBoundsWidth() * 2 - scrollViewOffset;
    _contentViewHSpaceConstraint.constant = - (ScreenBoundsWidth() * 2 - scrollViewOffset);
    _menuViewWidthConstraint.constant = ScreenBoundsWidth() - scrollViewOffset;
}

#pragma mark - Type Change
- (IBAction)typeSegmentedControlValueChange:(UISegmentedControl *)sender
{
    UIView *showView;
    if (sender.selectedSegmentIndex == SegmentedIndexChapter) {
        showView = _chapterTableView;
    } else if (sender.selectedSegmentIndex == SegmentedIndexLetter) {
        showView = _letterTableView;
    } else if (sender.selectedSegmentIndex == SegmentedIndexBookmark) {
        showView = _bookmarkHistoryView;
        [self reloadBookmarkAndHistory];
    } else if (sender.selectedSegmentIndex == SegmentedIndexAbout) {
        showView = _aboutView;
    } else {
        showView = nil;
        NSLog(@"Error Index!");
    }

    [UIView transitionWithView:_typeSwitchAnimationView
                      duration:0.5f
                       options:UIViewAnimationOptionShowHideTransitionViews |
                               UIViewAnimationOptionCurveEaseInOut |
                               UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [self refreshSwithContentView:showView];
    } completion:^(BOOL finished) {

    }];
}

- (void)refreshSwithContentView:(UIView *)showView
{
    for (UIView *view in _typeViewsCollection) {
        if (showView == view) {
            view.hidden = NO;
        } else {
            view.hidden = YES;
        }
    }
}

#pragma mark - UITextField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    ((UIImageView *)textField.leftView).highlighted = YES;
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _searchResultTableView.alpha = 1.0f;
    } completion:^(BOOL finished) {

    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    ((UIImageView *)textField.leftView).highlighted = NO;
    if (!textField.text.length > 0) {
        [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _searchResultTableView.alpha = 0;
            self.searchResultArray = nil;
            [_searchResultTableView reloadData];
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [textField resignFirstResponder];
    });
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _searchTextField) {
        [_searchTextField resignFirstResponder];

        if (textField.text.length > 0) {
            int fromPage = 1;
            int toPage = 1008;
            self.searchResultArray = [[BookContentDao sharedInstance] selectBookContent:_searchTextField.text fromPage:fromPage toPage:toPage];
            [_searchResultTableView reloadData];
            if (!_searchResultArray.count > 0) {
                [GInstance() showMessageToView:self.view message:@"没有匹配记录"];
            }
        }
    }
    return YES;
}

- (IBAction)tapLeftView:(UITapGestureRecognizer *)sender
{
    if (_searchTextField.isFirstResponder) {
        [_searchTextField resignFirstResponder];
        ((UIImageView *)_searchTextField.leftView).highlighted = NO;
    }
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _menuScrollView) {
        _blackMaskView.alpha = 0.4f * (ScreenBoundsWidth() - scrollViewOffset - scrollView.contentOffset.x) / (ScreenBoundsWidth() - scrollViewOffset);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _menuScrollView) {
        if (scrollView.contentOffset.x == 0) {
            if ([_delegate respondsToSelector:@selector(leftMenuShowed)]) {
                [_delegate leftMenuShowed];
            }
            if (_typeSwitchSegmentedControl.selectedSegmentIndex == SegmentedIndexBookmark) {
                [self reloadBookmarkAndHistory];
            }
        }

    }
}

#pragma mark - UITableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _chapterTableView) {
        return _chapterArrayOrderById.count;
    } else if (tableView == _letterTableView) {
        return _chapterArrayOrderByLetter.count;
    } else if (tableView == _bookmarkTableView) {
        return _bookmarkArrayOrderByDate.count > 0 ? _bookmarkArrayOrderByDate.count : 1;
    } else if (tableView == _historyTableView) {
        return _historyArrayOrderByDate.count > 0 ? _historyArrayOrderByDate.count : 1;
    } else if (tableView == _searchResultTableView) {
        return _searchResultArray.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _chapterTableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kChapterCellIdentifier forIndexPath:indexPath];
        UILabel *label = (UILabel *)[cell viewWithTag:11];
        label.text = [_chapterArrayOrderById[indexPath.row] title];
        return cell;
    } else if (tableView == _letterTableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kLetterCellIdentifier forIndexPath:indexPath];
        UILabel *label = (UILabel *)[cell viewWithTag:11];
        label.text = [_chapterArrayOrderByLetter[indexPath.row] title];
        return cell;
    } else if (tableView == _bookmarkTableView) {
        if (_bookmarkArrayOrderByDate.count > 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kBookmarkCellIdentifier forIndexPath:indexPath];
            BookmarkBean *bean = _bookmarkArrayOrderByDate[indexPath.row];
            UILabel *titleLabel = (UILabel *)[cell viewWithTag:11];
            titleLabel.text = bean.title;
            UILabel *pageLabel = (UILabel *)[cell viewWithTag:12];
            if (bean.page == 0) {
                pageLabel.text = nil;
            } else {
                pageLabel.text = [NSString stringWithFormat:@"%d", bean.page];
            }
            return cell;
        } else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kEmptyCellIdentifier forIndexPath:indexPath];
            cell.backgroundColor = [UIColor colorWithRed:231.0f / 255 green:232.0f / 255 blue:226.0f / 255 alpha:1.0f];
            cell.textLabel.font = [UIFont systemFontOfSize:16];
            cell.textLabel.textColor = [UIColor darkGrayColor];
            cell.textLabel.text = @"暂无记录";
            return cell;
        }
    } else if (tableView == _historyTableView) {
        if (_historyArrayOrderByDate.count > 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kHistoryCellIdentifier forIndexPath:indexPath];
            HistoryBean *bean = _historyArrayOrderByDate[indexPath.row];
            UILabel *titleLabel = (UILabel *)[cell viewWithTag:11];
            titleLabel.text = bean.title;
            UILabel *pageLabel = (UILabel *)[cell viewWithTag:12];
            if (bean.page == 0) {
                pageLabel.text = nil;
            } else {
                pageLabel.text = [NSString stringWithFormat:@"%d", bean.page];
            }
            UILabel *dateLabel = (UILabel *)[cell viewWithTag:13];
            dateLabel.text = [self formatedDateString:bean.date];
            return cell;
        } else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kEmptyCellIdentifier forIndexPath:indexPath];
            cell.backgroundColor = [UIColor colorWithRed:231.0f / 255 green:232.0f / 255 blue:226.0f / 255 alpha:1.0f];
            cell.textLabel.font = [UIFont systemFontOfSize:16];
            cell.textLabel.textColor = [UIColor darkGrayColor];
            cell.textLabel.text = @"暂无记录";
            return cell;
        }
    } else if (tableView == _searchResultTableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSearchResultCellIdentifier forIndexPath:indexPath];
        BookContentBean *bean = _searchResultArray[indexPath.row];
        UILabel *titleLabel = (UILabel *)[cell viewWithTag:11];
        titleLabel.text = [self chapterTitleForPage:bean.page];
        UILabel *pageLabel = (UILabel *)[cell viewWithTag:12];
        pageLabel.text = [NSString stringWithFormat:@"%d", bean.page];
        return cell;
    }
    return [[UITableViewCell alloc] init];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == _bookmarkTableView) {
        return @"书签";
    } else if (tableView == _historyTableView) {
        return @"浏览历史";
    }
    return nil;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *letterArray = [NSMutableArray array];
    if (tableView == _letterTableView) {
        __block NSString *lastLetter = nil;
        [_chapterArrayOrderByLetter enumerateObjectsUsingBlock:^(ChapterBean *chapter, NSUInteger idx, BOOL *stop) {
            if (![lastLetter isEqualToString:chapter.letter]) {
                [letterArray addObject:chapter.letter];
                [_letter2indexDictionary setObject:@(idx) forKey:chapter.letter];
                lastLetter = chapter.letter;
            }
        }];
    }
    return letterArray;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (tableView == _letterTableView) {
        [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:((NSNumber *)_letter2indexDictionary[title]).intValue inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [GInstance() showMessageToView:self.view message:title];
    }
    return index;
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int pageNumber;
    if (tableView == _chapterTableView) {
        pageNumber = [_chapterArrayOrderById[indexPath.row] pageFrom];
    } else if (tableView == _letterTableView) {
        pageNumber = [_chapterArrayOrderByLetter[indexPath.row] pageFrom];
    } else if (tableView == _bookmarkTableView) {
        pageNumber = [_bookmarkArrayOrderByDate[indexPath.row] page];
    } else if (tableView == _historyTableView) {
        pageNumber = [_historyArrayOrderByDate[indexPath.row] page];
    } else if (tableView == _searchResultTableView) {
        pageNumber = [_searchResultArray[indexPath.row] page];
    } else {
        pageNumber = 0;
    }
    if ([_delegate respondsToSelector:@selector(jumpToPageNumber:)]) {
        [_delegate jumpToPageNumber:pageNumber];
    }
    [_menuScrollView setContentOffset:CGPointMake(ScreenBoundsWidth() - scrollViewOffset, 0) animated:YES];
}

#pragma mark - Data
- (void)reloadBookmarkAndHistory
{
    self.bookmarkArrayOrderByDate = [[BookmarkDao sharedInstance] selectBookmarkOrderByDateDesc];
    [_bookmarkTableView reloadData];

    self.historyArrayOrderByDate = [[HistoryDao sharedInstance] selectHistoryOrderByDateDesc];
    [_historyTableView reloadData];
}

- (NSString *)formatedDateString:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter stringFromDate:date];
}

- (NSString *)chapterTitleForPage:(int)pageNumber
{
    __block NSString *title = nil;
    [_chapterArrayOrderById enumerateObjectsUsingBlock:^(ChapterBean *chapterBean, NSUInteger idx, BOOL *stop) {
        if (chapterBean.pageFrom <= pageNumber && chapterBean.pageTo >= pageNumber) {
            title = chapterBean.title;
        }
    }];
    return title;
}

@end


@implementation MenuScrollView

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (point.x <= ScreenBoundsWidth()) {
        return YES;
    } else {
        return NO;
    }
}

@end