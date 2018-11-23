//
//  SignUpViewController.m
//  Societly
//
//  Created by Katrin Annuk on 25/10/16.
//  Copyright © 2016 MobiLab. All rights reserved.
//

#import "SignUpViewController.h"
#import "NetworkManager+Customer.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "NavigationHelper.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"
#import "UIAlertController+Additions.h"
#import <Google/SignIn.h>
#import "MBProgressHUD.h"

@interface SignUpViewController ()<GIDSignInUIDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property(weak, nonatomic) IBOutlet GIDSignInButton *googleSignInButton;

@end

@implementation SignUpViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(googleSignInSuccess:) name:@"googleSignin" object:nil];
  
  [GIDSignIn sharedInstance].uiDelegate = self;

  self.emailField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Email", nil) attributes:@{ NSForegroundColorAttributeName : [UIColor themeWhiteDarkColor],  NSFontAttributeName : [UIFont themeTextfieldTextFont]}];
  
  self.passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Password", nil) attributes:@{ NSForegroundColorAttributeName : [UIColor themeWhiteDarkColor],  NSFontAttributeName : [UIFont themeTextfieldTextFont]}];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backgroundTapped:(id)sender {
    [self.emailField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

- (IBAction)backTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)signUpTapped:(id)sender {
    MLLog(@"Sign up tapped")
  [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [[NetworkManager sharedInstance] signUpWithEmail:self.emailField.text andPassword:self.passwordField.text withSuccess:^{
        MLLog(@"Sign up success")
      [MBProgressHUD hideHUDForView:self.view animated:YES];

        [NavigationHelper setMainViewOnNavController:self.navigationController];
    } andFailure:^(NSError *error) {
        MLLog(@"Sign up error %@", error)
      [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self presentViewController:[UIAlertController errorAlertForError:error] animated:YES completion:nil];

    }];
}

- (IBAction)signUpWithFBTapped:(id)sender {
  
  FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
  [login
   logInWithReadPermissions: @[@"public_profile", @"email"]
   fromViewController:self
   handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
     if (error) {
       MLLog(@"Facebook signin error");
       [self presentViewController:[UIAlertController errorAlertForError:error] animated:YES completion:nil];
       
     } else if (result.isCancelled) {
       MLLog(@"Facebook signin cancelled");
     } else {
       MLLog(@"Facebook logged in");
       [MBProgressHUD showHUDAddedTo:self.view animated:YES];
       
       [[NetworkManager sharedInstance] signUpWithToken:result.token.tokenString andProvider:@"facebook" withSuccess:^{
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         [NavigationHelper setViewControllerAfterLogin:self.navigationController];
         
       } andFailure:^(NSError *error) {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         [self presentViewController:[UIAlertController errorAlertForError:error] animated:YES completion:nil];
       }];
     }
   }];

}

- (IBAction)signUpWithGoogleTapped:(id)sender {
  [self.googleSignInButton sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void)googleSignInSuccess:(NSNotification *)notification {
  NSString *token = notification.object;
  [MBProgressHUD showHUDAddedTo:self.view animated:YES];

  [[NetworkManager sharedInstance] signUpWithToken:token andProvider:@"google" withSuccess:^{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [NavigationHelper setViewControllerAfterLogin:self.navigationController];


  } andFailure:^(NSError *error) {
    MLLog(@"Sign in error: %@", error);
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self presentViewController:[UIAlertController errorAlertForError:error] animated:YES completion:nil];
  }];
  
}

- (void)keyboardWillShow:(NSNotification*)aNotification {
    
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0, 0, kbSize.height, 0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
}

- (void)keyboardWillHide:(NSNotification *)aNotification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
