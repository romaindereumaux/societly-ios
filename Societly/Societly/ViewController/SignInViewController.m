//
//  SignInViewController.m
//  Societly
//
//  Created by Katrin Annuk on 25/10/16.
//  Copyright © 2016 MobiLab. All rights reserved.
//

#import "SignInViewController.h"
#import "NetworkManager+Customer.h"
#import "NavigationHelper.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"
#import "UIAlertController+Additions.h"
#import <Google/SignIn.h>
#import "MBProgressHUD.h"

@interface SignInViewController ()<GIDSignInUIDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property(weak, nonatomic) IBOutlet GIDSignInButton *googleSignInButton;

@end

@implementation SignInViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardDidHideNotification object:nil];
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   // [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController setNavigationBarHidden:YES];
    
}

- (IBAction)signInTapped:(id)sender {
  [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    MLLog(@"Sign in tapped")
    [[NetworkManager sharedInstance] signInWithEmail:self.emailField.text andPassword:self.passwordField.text withSuccess:^{
        MLLog(@"Sign in success")
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [NavigationHelper setViewControllerAfterLogin:self.navigationController];
        
    } andFailure:^(NSError *error) {
        MLLog(@"Sign in failed: %@", error)
      [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self presentViewController:[UIAlertController errorAlertForError:error] animated:YES completion:nil];
    }];
}

- (IBAction)signInWithFbTapped:(id)sender {

  FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
  [login
   logInWithReadPermissions: @[@"public_profile", @"email"]
   fromViewController:self
   handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
     
     if (error) {
       MLLog(@"Facebook signin error %@", error);
       [self presentViewController:[UIAlertController errorAlertForError:error] animated:YES completion:nil];
       
     } else if (result.isCancelled) {
       MLLog(@"Facebook signin cancelled");
     } else {
       MLLog(@"Logged in with token %@", result.token.tokenString);
       [MBProgressHUD showHUDAddedTo:self.view animated:YES];
       
       [[NetworkManager sharedInstance] signInWithToken:result.token.tokenString andProvider:@"facebook" withSuccess:^{
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         
           [NavigationHelper setViewControllerAfterLogin:self.navigationController];
       } andFailure:^(NSError *error) {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         [self presentViewController:[UIAlertController errorAlertForError:error] animated:YES completion:nil];
         
       }];
     }
   }];
}

- (IBAction)signInWithGoogleTapped:(id)sender {
  [self.googleSignInButton sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void)googleSignInSuccess:(NSNotification *)notification {
    NSString *token = notification.object;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NetworkManager sharedInstance] signInWithToken:token andProvider:@"google" withSuccess:^{

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
