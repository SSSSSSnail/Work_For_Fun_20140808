//
//  WebViewController.m
//  Work_For_Fun_20140808
//
//  Created by Snail on 7/9/14.
//  Copyright (c) 2014 Snail. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) MBProgressHUD *hud;

@end

@implementation WebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    _webView.scrollView.bounces = NO;
    if ([_webViewLoadURL isEqualToString:PROFILEURL]) {
        NSString *body = [NSString stringWithFormat:@"userid=%@", LoadStringUserDefault(kUserIdentifier)];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:_webViewLoadURL]];
        [request setHTTPMethod: @"POST"];
        [request setHTTPBody: [body dataUsingEncoding: NSUTF8StringEncoding]];
        [_webView loadRequest: request];
    } else {
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_webViewLoadURL]]];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *absoluteURLString = request.URL.absoluteString;
    if ([absoluteURLString isEqualToString:kRegisterSuccess]) {
        [self.navigationController popViewControllerAnimated:YES];
        return NO;
    } else if ([absoluteURLString isEqualToString:REGISTERURL]) {
        self.hud = [GInstance() showMessageToView:self.view message:@"页面加载中..." autoHide:NO];
    } else if ([absoluteURLString isEqualToString:PROFILEURL]) {
        self.hud = [GInstance() showMessageToView:self.view message:@"页面加载中..." autoHide:NO];
    } else {
        NSLog(@"%@", absoluteURLString);
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *absoluteURLString = webView.request.URL.absoluteString;
    if ([absoluteURLString isEqualToString:REGISTERURL] || [absoluteURLString isEqualToString:PROFILEURL]) {
        [_hud hide:YES];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSString *absoluteURLString = webView.request.URL.absoluteString;
    if ([absoluteURLString isEqualToString:REGISTERURL] || [absoluteURLString isEqualToString:PROFILEURL]) {
        [_hud hide:YES];
    }
}

@end
