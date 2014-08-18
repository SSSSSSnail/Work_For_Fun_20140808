//
//  LeftMenuViewController.m
//  Work_For_Fun_20140808
//
//  Created by Snail on 12/8/14.
//  Copyright (c) 2014 Snail. All rights reserved.
//

#import "LeftMenuViewController.h"

typedef NS_ENUM(NSInteger, SegmentedIndex) {
    SegmentedIndexChapter = 0,
    SegmentedIndexLetter = 1,
    SegmentedIndexBookmark = 2,
    SegmentedIndexAbout = 3
};

static CGFloat const scrollViewOffset = 297.0f;

@interface LeftMenuViewController ()<UITextFieldDelegate, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIScrollView *menuScrollView;
@property (weak, nonatomic) IBOutlet UIView *scrollContentView;
@property (weak, nonatomic) IBOutlet UIView *blackMaskView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@property (weak, nonatomic) IBOutlet UIView *typeSwitchAnimationView;
@property (weak, nonatomic) IBOutlet UITableView *chapterTableView;
@property (weak, nonatomic) IBOutlet UITableView *letterTableView;
@property (weak, nonatomic) IBOutlet UIView *bookmarkHistoryView;
@property (weak, nonatomic) IBOutlet UITableView *bookmarkTableView;
@property (weak, nonatomic) IBOutlet UITableView *historyTableView;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *typeViewsCollection;

- (IBAction)contentViewTouchDown:(UIControl *)sender;
- (IBAction)typeSegmentedControlValueChange:(UISegmentedControl *)sender;

#pragma mark - Contrains
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewContentTop2Bottom;

@end

@implementation LeftMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIImageView *searchIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"leftMenuSearchIcon"] highlightedImage:[UIImage imageNamed:@"leftMenuSearchIcon_highlight"]];
    _searchTextField.leftViewMode = UITextFieldViewModeAlways;
    _searchTextField.leftView = searchIconImageView;

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [_menuScrollView setContentOffset:CGPointMake(scrollViewOffset, 0) animated:YES];

    UITableViewHeaderFooterView *bookmarkHeaderFooterView = [_bookmarkTableView headerViewForSection:0];
    bookmarkHeaderFooterView.textLabel.textColor = [UIColor colorWithRed:2.0f/255 green:83.0f/255 blue:157.0f/255 alpha:1.0f];
    UITableViewHeaderFooterView *historyHeaderFooterView = [_historyTableView headerViewForSection:0];
    historyHeaderFooterView.textLabel.textColor = [UIColor colorWithRed:2.0f/255 green:83.0f/255 blue:157.0f/255 alpha:1.0f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    _scrollViewContentTop2Bottom.constant = - [UIScreen mainScreen].bounds.size.height;
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
    } else if (sender.selectedSegmentIndex == SegmentedIndexAbout) {

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

#pragma mark UITextField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    ((UIImageView *)textField.leftView).highlighted = YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    ((UIImageView *)textField.leftView).highlighted = NO;
}

- (IBAction)contentViewTouchDown:(UIControl *)sender
{
    if (_searchTextField.isFirstResponder) {
        [_searchTextField resignFirstResponder];
    }
}

#pragma mark UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_searchTextField.isFirstResponder) {
        [_searchTextField resignFirstResponder];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _blackMaskView.alpha = 0.75f * (scrollViewOffset - scrollView.contentOffset.x) / scrollViewOffset;
}

#pragma mark UITableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _chapterTableView) {
        return 10;
    } else if (tableView == _letterTableView) {
        return 15;
    } else if (tableView == _bookmarkTableView) {
        return 10;
    } else if (tableView == _historyTableView) {
        return 20;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _chapterTableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chapterCell" forIndexPath:indexPath];
        UILabel *label = (UILabel *)[cell viewWithTag:11];
        label.text = @"血液系统恶性肿瘤";
        return cell;
    } else if (tableView == _letterTableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"letterCell" forIndexPath:indexPath];
        UILabel *label = (UILabel *)[cell viewWithTag:11];
        label.text = @"字母排序";
        return cell;
    } else if (tableView == _bookmarkTableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bookmarkCell" forIndexPath:indexPath];
        UILabel *titleLabel = (UILabel *)[cell viewWithTag:11];
        titleLabel.text = @"添加这里添加书签";
        UILabel *dateLabel = (UILabel *)[cell viewWithTag:12];
        dateLabel.text = @"2014-09-09";
        return cell;
    } else if (tableView == _historyTableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"historyCell" forIndexPath:indexPath];
        UILabel *titleLabel = (UILabel *)[cell viewWithTag:11];
        titleLabel.text = @"历史记录显示位置";
        UILabel *dateLabel = (UILabel *)[cell viewWithTag:12];
        dateLabel.text = @"2014-09-09";
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

#pragma mark UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_menuScrollView setContentOffset:CGPointMake(scrollViewOffset, 0) animated:YES];
}

@end
