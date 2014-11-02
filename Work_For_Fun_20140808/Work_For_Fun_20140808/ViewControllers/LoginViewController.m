//
//  LoginViewController.m
//  Work_For_Fun_20140808
//
//  Created by Snail on 6/9/14.
//  Copyright (c) 2014 Snail. All rights reserved.
//

#import "LoginViewController.h"
#import "WebViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>

// Property
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFieldCollection;


// IBAction
- (IBAction)backgroundAction:(id)sender;
- (IBAction)loginAction:(UIButton *)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _usernameTextField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loginUser"] highlightedImage:[UIImage imageNamed:@"loginUser_s"]];
    _usernameTextField.leftViewMode = UITextFieldViewModeAlways;
    _passwordTextField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loginPsw"] highlightedImage:[UIImage imageNamed:@"loginPsw_s"]];
    _passwordTextField.leftViewMode = UITextFieldViewModeAlways;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backgroundAction:(id)sender
{
    [self.view endEditing:YES];
    [_textFieldCollection enumerateObjectsUsingBlock:^(UITextField *textField, NSUInteger idx, BOOL *stop) {
        ((UIImageView *)textField.leftView).highlighted = NO;
    }];
}

- (IBAction)loginAction:(UIButton *)sender
{
    if (!_usernameTextField.text.length > 0 || !_passwordTextField.text.length > 0) {
        [AnimationWrapper addShakeAnimation:_usernameTextField completeBLock:^{
        }];
        [AnimationWrapper addShakeAnimation:_passwordTextField completeBLock:^{
        }];
        [GInstance() showMessageToView:self.view message:@"用户名密码不能为空"];
        return;
    }

    MBProgressHUD *hud = [GInstance() showMessageToView:self.view message:@"登录中..." autoHide:NO];
    [RequestWrapper requestWithURL:LOGINURL
                    withParameters:@{@"action" : @"login",
                                     @"username" : _usernameTextField.text,
                                     @"password" : _passwordTextField.text}
                           success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                               NSTimeInterval delayTime = 0.5f;
                               BOOL isUserValid;
                               if ([(NSNumber *)responseObject[@"result"] isEqualToNumber:@(YES)]) {
                                   isUserValid = YES;
                                   hud.labelText = @"登录成功";
                                   SaveStringUserDefault(kUserIdentifier, responseObject[@"userid"]);
                               } else {
                                   isUserValid = NO;
                                   hud.labelText = responseObject[@"msg"];
                                   delayTime = 1.5f;
                               }
                               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                   [hud hide:YES];
                                   if (isUserValid) {
                                       [self dismissViewControllerAnimated:YES completion:^{
                                       }];
                                   }
                               });
                           }
                           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                               hud.labelText = @"登录失败";
                               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                   [hud hide:YES];
                               });
                               NSLog(@"%@", error);
                           }];
}

#pragma makr - UITextField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)aTextField
{
    [_textFieldCollection enumerateObjectsUsingBlock:^(UITextField *textField, NSUInteger idx, BOOL *stop) {
        if (textField == aTextField) {
            ((UIImageView *)textField.leftView).highlighted = YES;
        } else {
            ((UIImageView *)textField.leftView).highlighted = NO;
        }
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _usernameTextField) {
        [_passwordTextField becomeFirstResponder];
    } else {
        [_passwordTextField resignFirstResponder];
        [self loginAction:nil];
    }
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pushRegisterViewController"]) {
        WebViewController *webViewController = segue.destinationViewController;
        webViewController.webViewLoadURL = REGISTERURL;
    } else if ([segue.identifier isEqualToString:@"pushPasswordViewController"]) {
        WebViewController *webViewController = segue.destinationViewController;
        webViewController.webViewLoadURL = GETPASSWORDURL;
    }
}

@end
